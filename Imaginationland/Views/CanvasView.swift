// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


class CanvasView: View {

  var shot: Shot = .empty { didSet { setNeedsDisplay() } }

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

  private let cartoonist: Cartoonist

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  init(cartoonist: Cartoonist) {
    self.cartoonist = cartoonist

    super.init()
    isOpaque = false
    setupBasicDrawing()
  }

  private func setupBasicDrawing() {
    addGestureRecognizer(pan)
    addGestureRecognizer(tap)
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
        .line(
          .init(
            start: tapLocation,
            end: tapLocation
          )
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
      .line(
        .init(start: previosPanLocation ?? panLocation, end: panLocation)
      ),
      toShot: shot
    )
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)

    print("canvas-view---shot-version-id---\(shot.versionId)")
    print("canvas-view---hatches-count---\(shot.hatches.count)")
    print("canvas-view---segments-count---\(shot.totalSegmentsCount)")

    guard let context = UIGraphicsGetCurrentContext() else { return }

    let drawer = ShotDrawer(
      shot: shot,
      context: context,
      frame: canvasFrame,
      cgFrame: rect
    )

    rasterizedShot = drawer.draw()
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
