// @ Dmitry Kotenko

import Foundation
import UIKit


class ShotsCache: Buildable {

  var canvasSize: Size
  var cgSize: CGSize
  var rasterizationScale: CGFloat = UIScreen.main.scale

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
      removeLastRasterization(of: shot)

      let uiImage = rasterize(shot: shot)
      shotVersionIds[shot.id] = shot.versionId
      rasterizedShots[shot.versionId] = uiImage
      return uiImage
    }
  }

  func removeLastRasterization(of shot: Shot) {
    if let versionId = shotVersionIds[shot.id] {
      rasterizedShots[versionId] = nil
      shotVersionIds[shot.id] = nil
    }
  }

  func rasterize(shot: Shot) -> UIImage {
    guard cgSize.width > 0 && cgSize.height > 0
    else { return UIImage() }

    UIGraphicsBeginImageContextWithOptions(cgSize, false, rasterizationScale)

    UIGraphicsGetCurrentContext().map { cgContext in
      let builder = ShotImageBuilder(
        shot: shot,
        context: cgContext,
        frame: .init(origin: .zero, size: canvasSize),
        cgFrame: .init(origin: .zero, size: cgSize)
      )

      builder.buildImage()
    }

    let image = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()

    return UIImage(cgImage: image!.cgImage!, scale: rasterizationScale, orientation: .up)
  }
}
