// @ Dmitry Kotenko

import Foundation


enum ImaginationlandError: Error, Equatable, Hashable, Codable {

  case plain(reason: String)

  case degeneratedCanvasSize(Size)
  case degeneratedCgSize(CGSize)
}
