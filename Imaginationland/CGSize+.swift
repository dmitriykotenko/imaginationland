// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


extension CGSize: Hashable {

  var isDegenerated: Bool { width == 0 || height == 0 }

  var widthPerHeight: CGFloat { width / height }

  var heightPerWidth: CGFloat { height / width }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(width)
    hasher.combine(height)
  }

  public init(width: CGFloat,
              heightPerWidth: CGFloat) {
    self.init(
      width: width,
      height: width * heightPerWidth
    )
  }

  public init(height: CGFloat,
              widthPerHeight: CGFloat) {
    self.init(
      width: height * widthPerHeight,
      height: height
    )
  }
}
