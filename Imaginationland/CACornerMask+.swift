// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


extension CACornerMask {

  static let topLeft: CACornerMask = .layerMinXMinYCorner
  static let topRight: CACornerMask = .layerMaxXMinYCorner
  static let bottomLeft: CACornerMask = .layerMinXMaxYCorner
  static let bottomRight: CACornerMask = .layerMaxXMaxYCorner

  static let left: CACornerMask = [.topLeft, .bottomLeft]
  static let right: CACornerMask = [.topRight, .bottomRight]
  static let top: CACornerMask = [.topLeft, .topRight]
  static let bottom: CACornerMask = [.bottomLeft, .bottomRight]
}
