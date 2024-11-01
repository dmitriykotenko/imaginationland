// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


extension CGRect {

  var center: CGPoint { .init(x: midX, y: midY) }

  var topSideCenter: CGPoint { .init(x: midX, y: minY) }
  var bottomSideCenter: CGPoint { .init(x: midX, y: maxY) }
  var leftSideCenter: CGPoint { .init(x: minX, y: midY) }
  var rightSideCenter: CGPoint { .init(x: maxX, y: midY) }

  var topLeftCorner: CGPoint { .init(x: minX, y: minY) }
  var topRightCorner: CGPoint { .init(x: maxX, y: minY) }
  var bottomLeftCorner: CGPoint { .init(x: minX, y: maxY) }
  var bottomRightCorner: CGPoint { .init(x: maxX, y: maxY) }
}


extension CGRect: Buildable {}
extension CGPoint: Buildable {}
