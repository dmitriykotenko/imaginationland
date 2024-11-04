// @ Dmitry Kotenko

import Foundation


class AnimationGenerator {

  var canvasSize: Size
  var shotsCount: Int

  init(canvasSize: Size,
       shotsCount: Int) {
    self.canvasSize = canvasSize
    self.shotsCount = shotsCount
  }

  func generate() -> [Shot] {
    generateRandomChapter(shotsCount: shotsCount)
  }

  func generateRandomChapter(shotsCount: Int) -> [Shot] {
    (1...shotsCount).map { _ in randomShot }
  }

  var randomShot: Shot {
    let shapesCount = Int.random(in: 1...10)

    return Shot(
      hatches: (1...shapesCount).flatMap { _ in randomShape }
    )
  }

  var randomShape: [Hatch] {
    randomShape(
      kind: randomShapeKind,
      size: .random(in: 30...300),
      brush: .main,
      filling: .color(.random)
    )
  }

  private var randomShapeKind: ShapeKind {
    switch Int.random(in: 0...5) {
    case 0: .line
    case 1: .circle
    case 2: .square
    case 3: .rectangle
    case 4: .triangle
    default: .polygon(edgesCount: .random(in: 4...10))
    }
  }

  private func randomShape(kind: ShapeKind,
                           size: Int,
                           brush: Brush,
                           filling: Filling) -> [Hatch] {
    switch kind {
    case .line:
      randomLine(size: size, brush: brush, filling: filling)
    case .square:
      randomSquare(size: size, brush: brush, filling: filling)
    case .circle:
      randomCircle(size: size, brush: brush, filling: filling)
    case .triangle:
      randomTriangle(size: size, brush: brush, filling: filling)
    case .rectangle:
      randomRectangle(size: size, brush: brush, filling: filling)
    case .polygon(let edgesCount):
      randomPolygon(size: size, edgesCount: edgesCount, brush: brush, filling: filling)
    }
  }

  private func randomLine(size: Int,
                          brush: Brush,
                          filling: Filling) -> [Hatch] {
    let center = randomShapeCenter

    return [
      .init(
        brush: brush,
        filling: filling,
        segments: [
          .init(
            start: .random(
              xBounds: (center.x - size)...(center.x + size),
              yBounds: (center.y - size)...(center.y + size)
            ),
            end: .random(
              xBounds: (center.x - size)...(center.x + size),
              yBounds: (center.y - size)...(center.y + size)
            )
          )
        ]
      )
    ]
  }

  private func randomSquare(size: Int,
                            brush: Brush,
                            filling: Filling) -> [Hatch] {
    let center = randomShapeCenter

    return polygon(
      points: [
        center + .init(width: -size, height: -size),
        center + .init(width: size, height: -size),
        center + .init(width: size, height: size),
        center + .init(width: -size, height: size)
      ],
      brush: brush,
      filling: filling
    )
  }

  private func randomRectangle(size: Int,
                               brush: Brush,
                               filling: Filling) -> [Hatch] {
    let center = randomShapeCenter
    let width = size + Int.random(in: 0...size)
    let height = size - Int.random(in: 0..<size)

    return polygon(
      points: [
        center + .init(width: -(width / 2), height: -(height / 2)),
        center + .init(width: (width / 2), height: -(height / 2)),
        center + .init(width: (width / 2), height: (height / 2)),
        center + .init(width: -(width / 2), height: (height / 2))
      ],
      brush: brush,
      filling: filling
    )
  }

  private func randomTriangle(size: Int,
                              brush: Brush,
                              filling: Filling) -> [Hatch] {
    let center = randomShapeCenter

    return polygon(
      points: [
        center + .init(width: .random(in: -size...size), height: .random(in: -size...size)),
        center + .init(width: .random(in: -size...size), height: .random(in: -size...size)),
        center + .init(width: .random(in: -size...size), height: .random(in: -size...size))
      ],
      brush: brush,
      filling: filling
    )
  }

  private func randomPolygon(size: Int,
                             edgesCount: Int,
                             brush: Brush,
                             filling: Filling) -> [Hatch] {
    let center = randomShapeCenter

    return polygon(
      points: (1...edgesCount).map { _ in
        center + .init(
          width: .random(in: -size...size), 
          height: .random(in: -size...size)
        )
      },
      brush: brush,
      filling: filling
    )
  }

  private func randomCircle(size: Int,
                            brush: Brush,
                            filling: Filling) -> [Hatch] {
    let center = randomShapeCenter

    let edgesCount = 30
    let angles = (0..<edgesCount).map { CGFloat($0) * 2 * .pi / CGFloat(edgesCount) }

    return polygon(
      points: angles.map {
        center + .init(
          width: Int(CGFloat(size) * cos($0)),
          height: Int(CGFloat(size) * sin($0))
        )
      },
      brush: brush,
      filling: filling
    )
  }

  private func polygon(points: [Point],
                       brush: Brush,
                       filling: Filling) -> [Hatch] {
    let edges = zip(points, points.dropFirst() + [points[0]])

    return edges.map {
      .init(
        brush: brush,
        filling: filling,
        segments: [
          .init(
            start: $0,
            end: $1
          )
        ]
      )
    }
  }

  private var randomShapeCenter: Point {
    .random(
      xBounds: 0...canvasSize.width,
      yBounds: 0...canvasSize.height
    )
  }

  private enum ShapeKind {
    case line
    case square
    case circle
    case triangle
    case rectangle
    case polygon(edgesCount: Int)
  }
}


extension Point {

  static func random(xBounds: ClosedRange<Int>,
                     yBounds: ClosedRange<Int>) -> Point {
    .init(
      x: .random(in: xBounds),
      y: .random(in: yBounds)
    )
  }
}
