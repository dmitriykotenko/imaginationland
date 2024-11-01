// @ Dmitry Kotenko

import Foundation


struct Rect: Equatable, Hashable, Codable, Buildable {

  var origin: Point
  var size: Size

  var width: Int { size.width }
  var height: Int { size.height }
}
