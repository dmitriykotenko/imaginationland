// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


struct PointConverter {

  var canvasFrame: Rect
  var cgFrame: CGRect

  func cgPoint(from point: Point) -> CGPoint {
    cgFrame.origin + cgOffset(from: point)
  }

  private func cgOffset(from point: Point) -> CGSize {
    let relativePosition = relativePosition(of: point)

    return .init(
      width: cgFrame.width * relativePosition.width,
      height: cgFrame.height * relativePosition.height
    )
  }

  private func relativePosition(of point: Point) -> CGSize {
    .init(
      width: CGFloat(point.x - canvasFrame.origin.x) / CGFloat(canvasFrame.width),
      height: CGFloat(point.y - canvasFrame.origin.y) / CGFloat(canvasFrame.height)
    )
  }

  func point(from cgPoint: CGPoint) -> Point {
    canvasFrame.origin + offset(from: cgPoint)
  }

  private func offset(from cgPoint: CGPoint) -> Size {
    let relativePosition = relativePosition(of: cgPoint)

    return .init(
      width: Int(CGFloat(canvasFrame.width) * relativePosition.width),
      height: Int(CGFloat(canvasFrame.height) * relativePosition.height)
    )
  }

  private func relativePosition(of cgPoint: CGPoint) -> CGSize {
    .init(
      width: (cgPoint.x - cgFrame.origin.x) / CGFloat(cgFrame.width),
      height: (cgPoint.y - cgFrame.origin.y) / CGFloat(cgFrame.height)
    )
  }
}

extension CGFloat {

  func normalizedInside(bounds: ClosedRange<CGFloat>) -> CGFloat {
    (self - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
  }
}


extension Float {

  func normalizedInside(bounds: ClosedRange<Float>) -> Float {
    (self - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
  }
}
