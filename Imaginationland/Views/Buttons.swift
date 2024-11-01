// @ Dmitry Kotenko

import SnapKit
import UIKit


extension UIButton {

  static var standard: UIButton {
    button(
      font: .systemFont(ofSize: 24),
      cornerRadius: 8
    )
  }

  static func iconic(image: UIImage?,
                     tintColors: [UIControl.State: UIColor] = [
                      .normal: .buttonTintColor,
                      .selected: .buttonTintColor.withBrightnessMultiplied(by: 0.9)
                     ],
                     width: CGFloat = 60,
                     height: CGFloat = 44) -> UIButton {
    iconic(
      images: [.normal: image],
      tintColors: tintColors,
      width: width,
      height: height
    )
  }

  static func iconic(images: [UIControl.State: UIImage?],
                     tintColors: [UIControl.State: UIColor] = [
                      .normal: .buttonTintColor,
                      .selected: .systemPink
                     ],
                     width: CGFloat = 60,
                     height: CGFloat = 44) -> UIButton {
    let iconicButton = button(backgroundColor: .clear, height: height)
    iconicButton.imageView?.contentMode = .scaleAspectFit
    iconicButton.tintColors = tintColors

    iconicButton.snp.makeConstraints { $0.width.equalTo(width) }

    return iconicButton.with(images: images)
  }

  static func small(height: CGFloat = 44) -> UIButton {
    button(
      font: .systemFont(ofSize: 14),
      cornerRadius: 0,
      height: height
    )
  }

  static func button(font: UIFont? = nil,
                     textColor: UIColor = .white,
                     backgroundColor: UIColor = .systemBlue,
                     cornerRadius: CGFloat = 0,
                     height: CGFloat? = 44) -> Button {
    let button = Button()

    button.translatesAutoresizingMaskIntoConstraints = false
    button.adjustsImageWhenHighlighted = false
    button.adjustsImageWhenDisabled = false

    if let height {
      button.snp.makeConstraints { $0.height.equalTo(height) }
    }

    if let font {
      button.titleLabel?.font = font
    }

    button.setTitleColor(textColor, for: UIControl.State.normal)

    button.backgroundColor = backgroundColor
    button.layer.cornerRadius = cornerRadius

    return button
  }

  func with(title: String) -> Self {
    setTitle(title, for: UIControl.State.normal)
    return self
  }

  func with(titleColor: UIColor,
            forState state: UIControl.State) -> Self {
    setTitleColor(titleColor, for: state)
    return self
  }

  func with(images: [UIControl.State: UIImage?]) -> Self {
    images.forEach { setImage($1, for: $0) }
    return self
  }

  func with(image: UIImage?,
            forState state: UIControl.State = .normal) -> Self {
    setImage(image, for: state)
    return self
  }

  func with(width: CGFloat) -> Self {
    snp.makeConstraints { $0.width.equalTo(width) }
    return self
  }

  func with(selectedTitleColor: UIColor) -> Self {
    with(titleColor: selectedTitleColor, forState: .selected)
  }

  func with(backgroundColor: UIColor) -> Self {
    self.backgroundColor = backgroundColor
    return self
  }

  func with(contentHorizontalAlignment: UIControl.ContentHorizontalAlignment) -> Self {
    self.contentHorizontalAlignment = contentHorizontalAlignment
    return self
  }

  func with(contentEdgeInsets: UIEdgeInsets) -> Self {
    self.contentEdgeInsets = contentEdgeInsets
    return self
  }

  func with(cornerRadius: CGFloat) -> Self {
    self.layer.masksToBounds = true
    self.layer.cornerRadius = cornerRadius
    return self
  }
}
