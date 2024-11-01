// @ Dmitry Kotenko

import Foundation


enum CartoonFormat {

  enum Brush {
    case main
  }

  struct Color {
    var red: Int
    var green: Int
    var blue: Int
    var alpha: Double
  }

  enum Filling {
    case color(Color)
    case eraser
  }

  struct Hatch {

    enum Segment {
      case line(Line)
      case spline(Spline)
    }

    struct Line {
      var start: Point
      var end: Point
    }

    struct Spline {
      var start: Point
      var end: Point
      var startControlPoint: Point
      var endControlPoint: Point
    }

    var brush: Brush
    var filling: Filling
    var segments: [Segment]
  }

  struct Point {
    var x: Int
    var y: Int
  }

  struct Shot {
    var id: UUID = .init()
    var hatches: [Hatch] = []
  }

  struct Cartoon {
    var shots: [Shot]
    var shotsPerSecond: Int
  }
}
