// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


struct ShotDrawerV1 {

  var shot: Shot
  var context: CGContext
  var frame: Rect
  var cgFrame: CGRect

  var pointConverter: PointConverter {
    .init(canvasFrame: frame, cgFrame: cgFrame)
  }

  func drawIntoImage() -> UIImage {
    UIGraphicsImageRenderer(size: cgFrame.size).image { context in
      var nestedDrawer = self
      nestedDrawer.context = context.cgContext
      nestedDrawer.draw()
    }
  }

  func draw() {
    context.setLineCap(.round)
    context.setLineJoin(.round)
    shot.hatches.forEach(draw(hatch:))
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
    cgFrame.origin + cgOffset(from: point)
  }

  private func cgOffset(from point: Point) -> CGSize {
    .init(
      width:
        cgFrame.width * CGFloat(point.x - frame.origin.x) / CGFloat(frame.width),
      height:
        cgFrame.height * CGFloat(point.y - frame.origin.y) / CGFloat(frame.height)
    )
  }
}
