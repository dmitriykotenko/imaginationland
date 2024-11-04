// @ Dmitry Kotenko

import Foundation


struct Size: Equatable, Hashable, Codable, Buildable {

  var width: Int
  var height: Int

  var isDegenerated: Bool { width == 0 || height == 0 }

  static let zero = Size(width: 0, height: 0)
}
