// @ Dmitry Kotenko

import SnapKit
import UIKit


extension UIColor {

  static var mainBackground: UIColor {
    UIColor {
      $0.userInterfaceStyle == .dark ? .black : .white
    }
  }

  static var mainTextColor: UIColor {
    UIColor {
      $0.userInterfaceStyle == .dark ? .white : .black
    }
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
    UIColor {
      $0.userInterfaceStyle == .dark ? .white : .black
    }
  }

  static var greenishTintColor: UIColor {
    UIColor {
      $0.userInterfaceStyle == .dark ? 
        .init(
          red: 180.0 / 255.0,
          green: 236.0 / 255.0,
          blue: 81.0 / 255.0,
          alpha: 1
        ) :
        .init(
          red: 137.0 / 255.0,
          green: 217.0 / 255.0,
          blue: 0.0 / 255.0,
          alpha: 1
        )
    }

  }

  static var yellowishTintColor: UIColor {
    .systemYellow
  }
}
