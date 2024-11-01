// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


extension Rect {

  var minX: Int { origin.x }
  var maxX: Int { origin.x + size.width }
  var midX: Int { (minX + maxX) / 2 }

  var minY: Int { origin.y }
  var maxY: Int { origin.y + size.height }
  var midY: Int { (minY + maxY) / 2 }

  var center: Point { .init(x: midX, y: midY) }

  var topSideCenter: Point { .init(x: midX, y: minY) }
  var bottomSideCenter: Point { .init(x: midX, y: maxY) }
  var leftSideCenter: Point { .init(x: minX, y: midY) }
  var rightSideCenter: Point { .init(x: maxX, y: midY) }

  var topLeftCorner: Point { .init(x: minX, y: minY) }
  var topRightCorner: Point { .init(x: maxX, y: minY) }
  var bottomLeftCorner: Point { .init(x: minX, y: maxY) }
  var bottomRightCorner: Point { .init(x: maxX, y: maxY) }
}
