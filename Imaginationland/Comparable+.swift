// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


extension Comparable {

  func clamped(inside bounds: ClosedRange<Self>) -> Self {
    min(bounds.upperBound, max(bounds.lowerBound, self))
  }
}
