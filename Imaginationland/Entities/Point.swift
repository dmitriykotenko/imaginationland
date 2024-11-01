// @ Dmitry Kotenko

import Foundation


struct Point: Equatable, Hashable, Codable, Buildable {

  var x: Int
  var y: Int

  static let zero = Point(x: 0, y: 0)

  static func + (point: Point,
                 offset: Size) -> Point {
    .init(
      x: point.x + offset.width,
      y: point.y + offset.height
    )
  }
}
