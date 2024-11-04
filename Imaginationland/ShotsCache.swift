// @ Dmitry Kotenko

import Foundation
import UIKit


class ShotsCache: Buildable {

  var canvasSize: Size
  var cgSize: CGSize
  var rasterizationScale: CGFloat = UIScreen.main.scale

  var savedShots: [UUID: Shot] = [:]

  var contextfulShotId: UUID?

  private lazy var fixedContext: CGContext = {
    let scale = UIScreen.main.scale

    var size = cgSize
    size.width *= scale
    size.height *= scale

    let colorSpace = CGColorSpaceCreateDeviceRGB()

    let context: CGContext = CGContext(
      data: nil,
      width: Int(size.width),
      height: Int(size.height),
      bitsPerComponent: 8,
      bytesPerRow: 0,
      space: colorSpace,
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )!

    context.setLineCap(.round)
    let transform = CGAffineTransform(scaleX: scale, y: scale)
    context.concatenate(transform)

    return context
  }()

  init(canvasSize: Size, 
       cgSize: CGSize,
       rasterizedShots: [Shot.VersionId: UIImage] = [:]) throws {
    if canvasSize.isDegenerated {
      throw ImaginationlandError.degeneratedCanvasSize(canvasSize)
    }

    if cgSize.isDegenerated {
      throw ImaginationlandError.degeneratedCgSize(cgSize)
    }

    self.canvasSize = canvasSize
    self.cgSize = cgSize
    self.rasterizedShots = rasterizedShots
  }

  private var rasterizedShots: [Shot.VersionId: UIImage] = [:]
  private var shotVersionIds: [UUID: Shot.VersionId] = [:]

  @discardableResult
  func add(shot: Shot) -> UIImage {
    rasterizedVersion(of: shot)
  }

  func rasterizedVersion(of shot: Shot) -> UIImage {
    switch rasterizedShots[shot.versionId] {
    case let uiImage?:
      return uiImage
    case nil:
      let savedShot = savedShots[shot.id]

      let uiImage = rasterize(shot: shot, butNot: savedShot)
      shotVersionIds[shot.id] = shot.versionId
      rasterizedShots[shot.versionId] = uiImage

      savedShots[shot.id] = shot

      return uiImage
    }
  }

  func removeLastRasterization(of shot: Shot) {
    if let versionId = shotVersionIds[shot.id] {
      rasterizedShots[versionId] = nil
      shotVersionIds[shot.id] = nil
    }
  }

  func rasterize(shot: Shot,
                 butNot savedShot: Shot?) -> UIImage {
    guard cgSize.width > 0 && cgSize.height > 0
    else { return UIImage() }

    if let savedShot, !shot.isMoreRecentVersion(of: savedShot) {
      fixedContext.clear(
        .init(origin: .zero, size: cgSize)
      )
    }

    if contextfulShotId != shot.id {
      fixedContext.clear(
        .init(origin: .zero, size: cgSize)
      )
    }

    let builder = ShotImageBuilder(
      shot: shot,
      context: fixedContext,
      frame: .init(origin: .zero, size: canvasSize),
      cgFrame: .init(origin: .zero, size: cgSize),
      numberOfRasterizedHatches: savedShot?.hatches.count ?? 0,
      rasterizedPartOfShot: (savedShot?.versionId).flatMap { rasterizedShots[$0] },
      newHatches: shot.newHatches(inComparisonWith: savedShot ?? shot.with(\.hatches, []))
    )

    builder.buildImage()

    contextfulShotId = shot.id

    let cgImage = fixedContext.makeImage()

    return 
      cgImage.map { UIImage(cgImage: $0, scale: rasterizationScale, orientation: .up) }
      ?? UIImage()
  }

  func rasterize2(shot: Shot,
                  butNot savedShot: Shot?) -> UIImage {
    guard cgSize.width > 0 && cgSize.height > 0
    else { return UIImage() }

    UIGraphicsBeginImageContextWithOptions(cgSize, false, rasterizationScale)

    UIGraphicsGetCurrentContext().map { cgContext in
      let builder = ShotImageBuilder(
        shot: shot,
        context: cgContext,
        frame: .init(origin: .zero, size: canvasSize),
        cgFrame: .init(origin: .zero, size: cgSize),
        numberOfRasterizedHatches: savedShot?.hatches.count ?? 0,
        rasterizedPartOfShot: (savedShot?.versionId).flatMap { rasterizedShots[$0] },
        newHatches: []
      )

      builder.buildImage()
    }

    let image = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()

    return UIImage(cgImage: image!.cgImage!, scale: rasterizationScale, orientation: .up)
  }
}
