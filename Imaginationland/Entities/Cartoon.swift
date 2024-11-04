// @ Dmitry Kotenko

import Foundation


struct Cartoon: Equatable, Hashable, Codable, Buildable {

  var shots: [Shot] = []
  var shotsPerSecond: Int = 10

  var lastShot: Shot? {
    get { shots.last }
    set {
      guard shots.isNotEmpty else { return }

      switch newValue {
      case nil:
        shots.removeLast()
      case let element?:
        shots[shots.count - 1] = element
      }
    }
  }

  var duration: TimeInterval {
    TimeInterval(shots.count) / TimeInterval(shotsPerSecond)
  }

  var hatches: [Hatch] { shots.flatMap(\.hatches) }
  var segments: [Hatch.Segment] { shots.flatMap(\.hatches).flatMap(\.segments) }

  var isEmpty: Bool {
    shots.isEmpty || (shots.count == 1 && shots[0].hatches.isEmpty)
  }

  var canHaveMoreShots: Bool {
    shots.count < Int.max
  }

  var isNotEmpty: Bool { !isEmpty }
}
