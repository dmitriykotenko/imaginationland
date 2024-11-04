// @ Dmitry Kotenko

import SnapKit
import UIKit


extension UIColor {

  static var mainBackground: UIColor {
    .black
  }

  static var mainTextColor: UIColor {
    .white
  }

  static var melodyVisualisationStroke: UIColor {
    .systemGreen
  }

  static var mainTintColor: UIColor {
    .init(
      hue: 187.0 / 360.0,
      saturation: 0.9,
      brightness: 0.9,
      alpha: 1
    )
  }

  static var buttonTintColor: UIColor {
    Color.basicPink.asUiColor
  }

  static var yellowishTintColor: UIColor {
    .systemYellow
  }
}
