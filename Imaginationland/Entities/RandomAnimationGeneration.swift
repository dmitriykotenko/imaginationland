// @ Dmitry Kotenko

import Foundation


enum RandomAnimationGeneration: Equatable, Hashable, Codable, Buildable {

  case hidden
  case isPickingShotsCount(userText: String)
  case isGenerating(shotsCount: Int)

  var canBeHidden: Bool {
    switch self {
    case .hidden, .isGenerating:
      return false
    case .isPickingShotsCount:
      return true
    }
  }
}
