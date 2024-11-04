// @ Dmitry Kotenko

import CoreGraphics
import Foundation


enum UserAction: Equatable, Hashable, Codable, Buildable {

  case addHatch(withSegments: [Hatch.Segment], toShot: Shot)
  case addHatchSegments([Hatch.Segment], toShot: Shot)

  case insertShot(Shot, atIndex: Int)
  case showAnimationGeneratorView
  case hideAnimationGeneratorView
  case generateRandomAnimation(shotsCount: Int)
  case replace(oldCartoon: Cartoon, oldCurrentShotId: UUID, byNewCartoon: Cartoon)

  case deleteShot(shot: Shot, atIndex: Int)
  case clearTheOnlyShot(shot: Shot)
  case deleteShots(shots: [Shot], currentShotId: UUID)

  case go(fromShotId: UUID, toShotId: UUID)

  case undoHatch
  case redoHatch
  case undo
  case redo
  case showHelp
  case hideHelp

  case updateFilling(old: Filling, new: Filling)

  case play
  case stopPlaying

  case changeCanvasViewSize(CGSize)

  var asHatchAdding: ([Hatch.Segment], Shot)? {
    switch self {
    case .addHatch(let withSegments, let toShot):
      (withSegments, toShot)
    default:
      nil
    }
  }

  var canBeUndoed: Bool {
    switch self {
    case .addHatch:
      true
    case .addHatchSegments:
      false
    case .insertShot, .deleteShot, .deleteShots, .clearTheOnlyShot, .updateFilling:
      true
    case .replace(let oldCartoon, _, let newCartoon):
      true
    case .go(let fromShotId, let toShotId):
      true
    case .undo, .redo, .undoHatch, .redoHatch, .play, .stopPlaying, .changeCanvasViewSize:
      false
    case .showAnimationGeneratorView, .hideAnimationGeneratorView, .generateRandomAnimation:
      false
    case .showHelp, .hideHelp:
      false
    }
  }
}
