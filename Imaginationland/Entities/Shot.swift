// @ Dmitry Kotenko

import Foundation


struct Shot: Equatable, Hashable, Codable, Buildable {

  struct VersionId: Hashable {
    var id: UUID
    var hash: Int
  }

  var id: UUID = .init()
  var hatches: [Hatch] = []

  var versionId: VersionId {
    .init(
      id: id,
      hash: hashValue
    )
  }

  var totalSegmentsCount: Int { hatches.map(\.segments.count).sum }

  func appending(hatch: Hatch) -> Shot {
    var result = self
    result.hatches.append(hatch)
    return result
  }

  func updatingLastHatch(_ lastHatch: Hatch) -> Shot {
    var result = self
    result.hatches = result.hatches.dropLast() + [lastHatch]
    return result
  }

  static var empty: Shot { .init() }
}
