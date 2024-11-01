// @ Dmitry Kotenko

import Foundation


struct Hatch: Equatable, Hashable, Codable, Buildable {

  var brush: Brush
  var filling: Filling
  var segments: [Segment]

  static let basic = Hatch(
    brush: .main, 
    filling: .color(.default),
    segments: []
  )

  static func basic(firstSegment: Segment) -> Hatch {
    .init (
      brush: .main,
      filling: .color(.default),
      segments: [firstSegment]
    )
  }
}
