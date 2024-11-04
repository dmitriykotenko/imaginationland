// @ Dmitry Kotenko

import Foundation
import UIKit


struct Color: Equatable, Hashable, Codable, Buildable {

  var red: Int
  var green: Int
  var blue: Int
  var alpha: Double

  var asUiColor: UIColor {
    .init(
      displayP3Red: CGFloat(red) / 255.0,
      green: CGFloat(green) / 255.0,
      blue: CGFloat(blue) / 255.0,
      alpha: CGFloat(alpha)
    )
  }

  static let `default` = Color.black

  static let white = Color(red: 255, green: 255, blue: 255, alpha: 1)
  static let black = Color(red: 0, green: 0, blue: 0, alpha: 1)
  static let red = Color(red: 255, green: 61, blue: 0, alpha: 1)
  static let blue = Color(red: 25, green: 118, blue: 210, alpha: 1)

  static let basicPink = Color(red: 255, green: 0, blue: 98, alpha: 1)

  static var random: Color {
    .init(
      red: .random(in: 0...255),
      green: .random(in: 0...255),
      blue: .random(in: 0...255),
      alpha: 1
    )
  }

  func mixed(with other: Color,
             selfPortion: Double) -> Color {
    .init(
      red: red.mixed(with: other.red, selfPortion: selfPortion),
      green: green.mixed(with: other.green, selfPortion: selfPortion),
      blue: blue.mixed(with: other.blue, selfPortion: selfPortion),
      alpha: alpha.mixed(with: other.alpha, selfPortion: selfPortion)
    )
  }
}


private extension Int {

  func mixed(with other: Int,
             selfPortion: Double) -> Int {
    Int(
      Double(self).mixed(with: Double(other), selfPortion: selfPortion)
    )
  }
}


private extension Double {

  func mixed(with other: Double,
             selfPortion: Double) -> Double {
      self * selfPortion + other * (1 - selfPortion)
  }
}
