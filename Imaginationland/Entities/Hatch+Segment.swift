// @ Dmitry Kotenko

import Foundation


extension Hatch {

  enum Segment: Equatable, Hashable, Codable, Buildable {

    case line(Line)
    case spline(Spline)
  }

  struct Line: Equatable, Hashable, Codable, Buildable {
  
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
