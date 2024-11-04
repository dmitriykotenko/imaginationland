// @ Dmitry Kotenko

import CoreGraphics
import Foundation


enum UserAction: Equatable, Hashable, Codable, Buildable {

  case addHatchSegment(Hatch.Segment, toShot: Shot)
  case addHatchSegments([Hatch.Segment], toShot: Shot)
  case commitHatch

  case appendShot
  case duplicateShot(id: UUID)
  case showAnimationGeneratorView
  case hideAnimationGeneratorView
  case appendRandomAnimation(shotsCount: Int)

  case deleteShot(id: UUID)
  case deleteEverything
  
  case startEditingOfShot(id: UUID)

  case undoHatch
  case redoHatch

  case enableFilling(Filling)

  case play
  case stopPlaying

  case changeCanvasViewSize(CGSize)
}
