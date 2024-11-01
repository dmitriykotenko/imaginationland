// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


extension Optional {

  var asArray: [Wrapped] { self.map { [$0] } ?? [] }
}
