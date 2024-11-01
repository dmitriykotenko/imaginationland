// @ Dmitry Kotenko

import Foundation


enum UserAction: Equatable, Hashable, Codable, Buildable {

  case addHatchSegment(Hatch.Segment, toShot: Shot)
  case commitHatch

  case appendShot
  case deleteLastShot

  case undoHatch
  case redoHatch

  case enableFilling(Filling)

  case play
  case stopPlaying
}
