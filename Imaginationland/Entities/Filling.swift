// @ Dmitry Kotenko

import CoreGraphics
import Foundation
import UIKit


enum Filling: Equatable, Hashable, Codable, Buildable {

  case color(Color)
  case eraser

  var isNotEraser: Bool { self != .eraser }

  var uiColor: UIColor {
    switch self {
    case .color(let color):
      color.asUiColor
    case .eraser:
      .systemCyan
    }
  }

  var cgColor: CGColor { uiColor.cgColor }
}
