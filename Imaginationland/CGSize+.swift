// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


extension CGSize: Hashable {

  var isDegenerated: Bool { width == 0 || height == 0 }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(width)
    hasher.combine(height)
  }
}
