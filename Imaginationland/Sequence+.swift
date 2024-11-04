// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


extension Sequence {

  var asArray: [Element] { map { $0 } }

  func asyncMap<OtherElement>(_ transform: (Element) async -> OtherElement) async -> [OtherElement] {
    var result: [OtherElement] = []

    for element in self {
      await result.append(transform(element))
    }

    return result
  }
}


extension Sequence where Element: AdditiveArithmetic {

  var sum: Element { reduce(.zero, +) }
}


extension Array {

  var isNotEmpty: Bool { !isEmpty }

  mutating func updateElements(_ transform: (Element) -> Element,
                               where condition: (Element) -> Bool) {
    self = map {
      condition($0) ? transform($0) : $0
    }
  }

  @discardableResult
  mutating func removeFirstSafely() -> Element? {
    isNotEmpty ? removeFirst() : nil
  }

  @discardableResult
  mutating func removeLastSafely() -> Element? {
    isNotEmpty ? removeLast() : nil
  }

  mutating func removeSafely(where condition: (Element) -> Bool) {
    self = filter { !condition($0) }
  }

  func chunks(length: Int) -> [[Element]] {
    stride(from: 0, to: count, by: length)
      .map { Array(dropFirst($0).prefix(length)) }
  }

  func chunksFromRight(length: Int) -> [[Element]] {
    stride(from: 0, to: count, by: length)
      .map { Array(dropLast($0).suffix(length)) }
      .reversed()
  }

  func splitBeforeIndex(_ index: Int) -> (Self, Self) {
    let safeIndex = index.clamped(inside: 0...count)

    return (
      Array(self[0..<safeIndex]),
      Array(self[safeIndex..<count])
    )
  }

  static func fromUnsafePointer(_ unsafePointer: UnsafePointer<Element>,
                                length: Int) -> Self {
    Array(
      UnsafeBufferPointer(start: unsafePointer, count: length)
    )
  }
}


extension Array<CGFloat> {

  var average: CGFloat {
    reduce(0, +) / CGFloat(count)
  }
}
