// @ Dmitry Kotenko

import SnapKit
import UIKit


extension UILabel {

  static var standard: UILabel {
    label(font: .systemFont(ofSize: 18, weight: .medium, width: .condensed))
  }

  static var large: UILabel {
    label(font: .systemFont(ofSize: 24, weight: .medium, width: .condensed))
  }

  static var largeWithMonospacedDigits: UILabel {
    label(font: .monospacedDigitSystemFont(ofSize: 24, weight: .medium))
  }

  static var small: UILabel {
    label(font: .systemFont(ofSize: 14, weight: .semibold, width: .condensed))
  }

  static func label(font: UIFont,
                    textColor: UIColor = .black,
                    textAlignment: NSTextAlignment = .left,
                    isMultilined: Bool = true) -> UILabel {
    let label = UILabel()

    label.translatesAutoresizingMaskIntoConstraints = false

    label.font = font
    label.textColor = textColor
    label.textAlignment = textAlignment

    if isMultilined {
      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping
    } else {
      label.numberOfLines = 1
      label.lineBreakMode = .byTruncatingTail
    }

    return label.preparedForAutoLayout()
  }

  var singlelinded: Self {
    numberOfLines = 1
    lineBreakMode = .byTruncatingTail
    return self
  }

  func with(text: String?) -> Self {
    self.text = text
    return self
  }

  func with(textAlignment: NSTextAlignment) -> Self {
    self.textAlignment = textAlignment
    return self
  }

  func with(textColor: UIColor) -> Self {
    self.textColor = textColor
    return self
  }
}
