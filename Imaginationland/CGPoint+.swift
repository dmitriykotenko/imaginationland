// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


extension CGPoint {

  static func + (point: CGPoint,
                 offset: CGSize) -> CGPoint {
    .init(
      x: point.x + offset.width,
      y: point.y + offset.height
    )
  }
}
