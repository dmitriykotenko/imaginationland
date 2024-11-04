// @ Dmitry Kotenko

import SnapKit
import UIKit


extension UITextField {

  static var standard: UITextField {
    textField(
      font: .systemFont(
        ofSize: 24,
        weight: .medium,
        width: .condensed
      )
    )
  }

  static func textField(font: UIFont,
                        textColor: UIColor = .mainTextColor,
                        textAlignment: NSTextAlignment = .left) -> UITextField {
    let textField = UITextField()

    textField.translatesAutoresizingMaskIntoConstraints = false

    textField.font = font
    textField.textColor = textColor
    textField.textAlignment = textAlignment

    return textField.preparedForAutoLayout()
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
