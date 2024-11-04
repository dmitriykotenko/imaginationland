// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


extension CGPoint {

  var asZeroSizeRect: CGRect {
    .init(
      origin: self,
      size: .zero
    )
  }

  static func + (point: CGPoint,
                 offset: CGSize) -> CGPoint {
    .init(
      x: point.x + offset.width,
      y: point.y + offset.height
    )
  }
}
