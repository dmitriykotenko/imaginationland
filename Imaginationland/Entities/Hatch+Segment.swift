// @ Dmitry Kotenko

import Foundation


extension Hatch {

  struct Segment: Equatable, Hashable, Codable, Buildable {

    var start: Point
    var end: Point
  }

  struct Spline: Equatable, Hashable, Codable, Buildable {

    var start: Point
    var end: Point
    var startControlPoint: Point
    var endControlPoint: Point
  }
}
