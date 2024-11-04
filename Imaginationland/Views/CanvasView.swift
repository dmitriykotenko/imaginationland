// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


class CanvasView: View {

  var shot: Shot = .empty {
    didSet {
      guard !frame.size.isDegenerated else { return }

      guard shot != oldValue else { return }

      previousVersionOfShot = oldValue

      newHatches = shot.newHatches(inComparisonWith: previousVersionOfShot)

      let newSegments = newHatches.flatMap(\.segments)
      let newPoints = (newSegments.first?.start).asArray + newSegments.map(\.end)
      let newCgPoints = newPoints.map { pointConverter.cgPoint(from: $0) }

      let dirtyRects = newCgPoints
        .map(\.asZeroSizeRect)
        .map { $0.insetBy(dx: -Brush.main.width, dy: -Brush.main.width) }

      if shot.isMoreRecentVersion(of: previousVersionOfShot) {
        dirtyRects.forEach(setNeedsDisplay)
      } else {
        setNeedsDisplay()
      }
    }
  }

  var previousVersionOfShot: Shot
  var newHatches: [Hatch] = []

  var rasterizedShot: UIImage?

  var cgSizeListeners: [(CGSize) -> Void] = []

  let canvasWidth = 1000

  var canvasHeight: Int {
    Int(CGFloat(canvasWidth) * (frame.height / frame.width))
  }

  var canvasFrame: Rect {
    .init(
      origin: .zero,
      size: .init(
        width: canvasWidth,
        height: canvasHeight
      )
    )
  }

  var pointConverter: PointConverter {
    .init(canvasFrame: canvasFrame, cgFrame: frame)
  }

  private lazy var frozenContext: CGContext = {
    let scale = UIScreen.main.scale

    var size = frame.size
    size.width *= scale
    size.height *= scale

    let colorSpace = CGColorSpaceCreateDeviceRGB()

    let context: CGContext = CGContext(
      data: nil,
      width: Int(size.width),
      height: Int(size.height),
      bitsPerComponent: 8,
      bytesPerRow: 0,
      space: colorSpace,
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )!

    context.setLineCap(.round)
    let transform = CGAffineTransform(scaleX: scale, y: scale)
    context.concatenate(transform)

    return context
  }()

  private let cartoonist: Cartoonist

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  init(cartoonist: Cartoonist) {
    self.cartoonist = cartoonist
    self.previousVersionOfShot = shot

    super.init()
    isOpaque = false
    setupBasicDrawing()
  }

  override func touchesBegan(_ touches: Set<UITouch>, 
                             with event: UIEvent?) {
//    print("[TTT] Began, count = \(touches.count)")
    process(touches, with: event)
  }

  override func touchesMoved(_ touches: Set<UITouch>, 
                             with event: UIEvent?) {
//    print("[TTT] Moved, count = \(touches.count)")
    process(touches, with: event)
  }

  override func touchesEnded(_ touches: Set<UITouch>, 
                             with event: UIEvent?) {
//    print("[TTT] Ended, count = \(touches.count)")
    process(touches, with: event)
    lastSegmentEnd = nil
    cartoonist ! .commitHatch
  }

  private var lastSegmentEnd: Point?

  private func process(_ touches: Set<UITouch>,
                       with event: UIEvent?) {
    let touch = touches.first!
    let coalescedTouches = event?.coalescedTouches(for: touch) ?? []
    sendTouchesToCartoonist(touches: coalescedTouches)
  }

  private func sendTouchesToCartoonist(touches: [UITouch]) {
    guard touches.isNotEmpty else { return }

    let points = lastSegmentEnd.asArray + touches.map { megaPoint($0.location(in: self)) }

    var segments: [Hatch.Segment] = zip(points, points.dropFirst()).map {
      .init(
        start: $0,
        end: $1
      )
    }

    if segments.isEmpty {
      segments = [.init(start: points[0], end: points[0])]
    }

    lastSegmentEnd = points.last

    cartoonist ! .addHatchSegments(segments, toShot: shot)
//    zip(touches, touches.dropFirst()).forEach {
//      cartoonist ! .addHatchSegment(
//        .line(
//          .init(
//            start: megaPoint($0.location(in: self)),
//            end: megaPoint($1.location(in: self))
//          )
//        ),
//        toShot: shot
//      )
//    }
  }

  private func megaPoint(_ initialCgPoint: CGPoint) -> Point {
    var cgPoint = initialCgPoint
    cgPoint.x += frame.origin.x
    cgPoint.y += frame.origin.y
    return pointConverter.point(from: cgPoint)
  }

  private func setupBasicDrawing() {
//    addGestureRecognizer(pan)
//    addGestureRecognizer(tap)
  }

  lazy var pan: UIPanGestureRecognizer = {
    let result = UIPanGestureRecognizer(target: self, action: #selector(processPan))
    result.minimumNumberOfTouches = 1
    result.maximumNumberOfTouches = 1
    return result
  }()

  lazy var tap: UITapGestureRecognizer = {
    let result = UITapGestureRecognizer(target: self, action: #selector(processTap))
    result.numberOfTapsRequired = 1
    result.numberOfTouchesRequired = 1
    return result
  }()

  private var previosPanLocation: Point? = nil
  private var currentHatch: Hatch? = nil

  private var panLocation: Point {
    var cgPoint = pan.location(in: self)
    cgPoint.x += frame.origin.x
    cgPoint.y += frame.origin.y

    return pointConverter.point(from: cgPoint)
  }

  private var tapLocation: Point {
    var cgPoint = tap.location(in: self)
    cgPoint.x += frame.origin.x
    cgPoint.y += frame.origin.y

    return pointConverter.point(from: cgPoint)
  }

  @objc 
  func processPan(_ pan: UIPanGestureRecognizer) {
    switch pan.state {
    case .possible:
      break
    case .began:
      appendHatchSegment()
      previosPanLocation = panLocation
    case .changed:
      appendHatchSegment()
      previosPanLocation = panLocation
    case .ended:
      appendHatchSegment()
      previosPanLocation = nil
      cartoonist ! .commitHatch
    case .cancelled:
      break
    case .failed:
      break
    case .recognized:
      break
    }
  }

  @objc
  func processTap(_ tap: UITapGestureRecognizer) {
    switch tap.state {
    case .possible:
      break
    case .began:
      break
    case .changed:
      break
    case .ended:
      cartoonist ! .addHatchSegment(
        .init(
          start: tapLocation,
          end: tapLocation
        ),
        toShot: shot
      )

      cartoonist ! .commitHatch
    case .cancelled:
      break
    case .failed:
      break
    case .recognized:
      break
    }
  }

  private func appendHatchSegment() {
    cartoonist ! .addHatchSegment(
      .init(
        start: previosPanLocation ?? panLocation,
        end: panLocation
      ),
      toShot: shot
    )
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)

    guard !rect.size.isDegenerated else { return }

//    print("canvas-view---shot-version-id---\(shot.versionId)")
//    print("canvas-view---hatches-count---\(shot.hatches.count)")
//    print("canvas-view---segments-count---\(shot.totalSegmentsCount)")

    guard let context = UIGraphicsGetCurrentContext() else { return }

    let drawer = ShotDrawer(
      shot: shot,
      context: frozenContext,
      frame: canvasFrame,
      cgFrame: rect,
      numberOfRasterizedHatches: previousVersionOfShot.hatches.count,
      rasterizedPartOfShot: 
        shot.isMoreRecentVersion(of: previousVersionOfShot) ? rasterizedShot : nil,
      newHatches: newHatches
    )

    rasterizedShot = drawer.draw()

    rasterizedShot?.draw(in: bounds)

    context.draw(rasterizedShot!.cgImage!, in: bounds)
  }

  override var bounds: CGRect {
    didSet {
      if bounds.size != oldValue.size {
        cgSizeListeners.forEach { $0(bounds.size) }
      }
    }
  }

  override var frame: CGRect {
    didSet {
      if bounds.size != oldValue.size {
        cgSizeListeners.forEach { $0(bounds.size) }
      }
    }
  }
}
