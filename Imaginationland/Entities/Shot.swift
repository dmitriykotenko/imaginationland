// @ Dmitry Kotenko

import Foundation


struct Shot: Equatable, Hashable, Codable, Buildable {

  struct VersionId: Hashable {
    var id: UUID
    var hash: Int
  }

  var id: UUID = .init()
  var hatches: [Hatch] = []

  var duplicated: Shot {
    self.with(\.id, .init())
  }

  var versionId: VersionId {
    .init(
      id: id,
      hash: hashValue
    )
  }

  var totalSegmentsCount: Int { hatches.map(\.segments.count).sum }

  func isMoreRecentVersion(of other: Shot) -> Bool {
    id == other.id && hatches.count >= other.hatches.count
  }

  func newHatches(inComparisonWith previousVersion: Shot) -> [Hatch] {
    let needsCompleteRedrawing =
      id != previousVersion.id || hatches.count < previousVersion.hatches.count

    return if needsCompleteRedrawing {
      hatches
    } else if hatches.isEmpty {
      hatches
    } else if hatches.count == previousVersion.hatches.count {
      [
        hatches.last!.with(
          \.segments,
           { $0.dropFirst(previousVersion.hatches.last?.segments.count ?? 0).asArray }
        )
      ]
    } else {
      hatches.dropFirst(previousVersion.hatches.count).asArray
    }
  }

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

  static var random: Shot {
    .init(
      hatches: [
        .init(
          brush: .main,
          filling: .color(.random),
          segments: [
            .init(
              start: .init(
                x: .random(in: 0...1000), 
                y: .random(in: 0...2000)
              ),
              end: .init(
                x: .random(in: 0...1000),
                y: .random(in: 0...2000)
              )
            )
          ]
        )
      ]
    )
  }
}
