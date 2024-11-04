// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


struct ShotImageBuilder {

  var shot: Shot
  var context: CGContext
  var frame: Rect
  var cgFrame: CGRect

  var numberOfRasterizedHatches: Int
  var rasterizedPartOfShot: UIImage?
  var newHatches: [Hatch]

  var pointConverter: PointConverter {
    .init(canvasFrame: frame, cgFrame: cgFrame)
  }

  let style = (
    strokeColor: UIColor.melodyVisualisationStroke,
    strokeWidth: CGFloat(2),
    shadowColor: UIColor.melodyVisualisationStroke,
    finalCircleRadius: CGFloat(4),
    finalCircleShadowRadius: CGFloat(12)
  )

  func buildImage() {
//    print("Build shot...")

    if rasterizedPartOfShot == nil {
      context.clear(cgFrame)
    }

    context.setLineCap(.round)
    context.setLineJoin(.round)

//    rasterizedPartOfShot?.cgImage.map {
//      context.draw($0, in: cgFrame, byTiling: false)
//    }

//    print("[RRR] (Rasterized, non-rasterized): ")
//    print("[RRR] (\(numberOfRasterizedHatches), \(shot.hatches.count - numberOfRasterizedHatches))")
//    print("[RRR] Segments to draw: \(newHatches.flatMap(\.segments).count)")

    newHatches.forEach(draw(hatch:))
//    shot.hatches
//      .dropFirst(numberOfRasterizedHatches)
//      .forEach(draw(hatch:))
//
//    context.setLineWidth(6)
//    context.setStrokeColor(UIColor.systemMint.cgColor)
//    context.move(to: cgFrame.topLeftCorner)
//    context.addLine(to: cgFrame.topRightCorner)
//    context.addLine(to: cgFrame.bottomRightCorner)
//    context.addLine(to: cgFrame.bottomLeftCorner)
//    context.addLine(to: cgFrame.topLeftCorner)
//    context.strokePath()
  }

  private func draw(hatch: Hatch) {
    context.setLineWidth(hatch.brush.width)

    switch hatch.filling {
    case .color(let color):
      context.setBlendMode(.normal)
      context.setStrokeColor(color.asUiColor.cgColor)
    case .eraser:
      context.setBlendMode(.clear)
    }

    hatch.segments.forEach(draw(segment:))

    context.strokePath()
  }

  private func draw(segment: Hatch.Segment) {
    context.move(to: cgPoint(from: segment.start))
    context.addLine(to: cgPoint(from: segment.end))
  }

  private func cgPoint(from point: Point) -> CGPoint {
    pointConverter.cgPoint(from: point)
  }
}
