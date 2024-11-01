// @ Dmitry Kotenko

import Foundation
import UIKit


class ShotsCache: Buildable {

  private var rasterizedShots: Dictionary<Shot.VersionId, UIImage> = [:]

  func rasterisedVersion(of shot: Shot) -> UIImage {
    switch rasterizedShots[shot.versionId] {
    case let uiImage?:
      return uiImage
    case nil:
      let uiImage = rasterise(shot: shot)
      rasterizedShots[shot.versionId] = uiImage
      return uiImage
    }
  }

  func rasterise(shot: Shot) -> UIImage {
    .init()
  }
}
