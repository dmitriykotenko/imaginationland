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

  let style = (
    strokeColor: UIColor.melodyVisualisationStroke,
    strokeWidth: CGFloat(2),
    shadowColor: UIColor.melodyVisualisationStroke,
    finalCircleRadius: CGFloat(4),
    finalCircleShadowRadius: CGFloat(12)
  )

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
    switch segment {
    case .line(let line):
      context.move(to: cgPoint(from: line.start))
      context.addLine(to: cgPoint(from: line.end))
    case .spline(let spline):
      let bezierPath = UIBezierPath()
      bezierPath.move(to: cgPoint(from: spline.start))
      bezierPath.addCurve(
        to: cgPoint(from: spline.end),
        controlPoint1: cgPoint(from: spline.startControlPoint),
        controlPoint2: cgPoint(from: spline.endControlPoint)
      )
    }
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