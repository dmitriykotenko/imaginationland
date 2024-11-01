// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


extension UIGestureRecognizer {

  var stateName: String {
    switch state {
    case .possible:
      return "possible"
    case .began:
      return "began"
    case .changed:
      return "changed"
    case .cancelled:
      return "canceled"
    case .ended:
      return "ended"
    case .failed:
      return "failed"
    @unknown default:
      return "unkown-gesture-state[state=\(state)]"
    }
  }
}
