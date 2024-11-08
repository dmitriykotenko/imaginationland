// @ Dmitry Kotenko

import SnapKit
import UIKit


class Button: UIButton {

  var tintColors: [UIControl.State: UIColor] = [:]

  override var isEnabled: Bool { didSet { displayState() } }
  override var isHighlighted: Bool { didSet { displayState() } }
  override var isSelected: Bool { didSet { displayState() } }

  private func displayState() {
    tintColor = tintColors[state] ?? tintColors[.normal]
    alpha = isEnabled ? 1 : 0.5

    transform = isSelected ? .init(scaleX: 1.5, y: 1.5) : .identity
  }
}


extension UIControl.State: Hashable {}
