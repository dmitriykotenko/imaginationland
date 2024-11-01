// @ Dmitry Kotenko

import SnapKit
import UIKit


class CartoonView: View {

  let cartoonist: Cartoonist

  var cartoon: Cartoon { didSet { cartoonUpdated() } }
  var isPlaying: Bool { didSet { isPlayingUpdated() } }

  var rasterizedShots: [UIImage] = []

  private let titleLabel = UILabel.large
    .with(textColor: .systemPurple)
    .with(text: "Всё, что ниже — холст")

  private let buttons = (
    undo: UIButton.iconic(image: .undoIcon),
    redo: UIButton.iconic(image: .redoIcon),
    brush: UIButton.iconic(image: .brushIcon),
    eraser: UIButton.iconic(image: .eraserIcon),
    appendShot: UIButton.iconic(image: .pictureIcon),
    deleteShot: UIButton.iconic(image: .trashcanIcon),
    play: UIButton.iconic(
      images: [.normal: .playIcon, .selected: .stopIcon],
      tintColors: [.normal: .systemPurple]
    )
  )

  private let playbackView = UIImageView.imageView(
    image: .canvasBackground, 
    size: nil
  )
  .with(contentMode: .scaleAspectFill)

  private lazy var canvasView = CanvasView(userActionsListener: cartoonist)

  private lazy var previousCanvasView = CanvasView(userActionsListener: cartoonist)

  private let canvasBackgroundView = UIImageView.imageView(
    image: .canvasBackground,
    size: nil
  )
  .with(contentMode: .scaleAspectFill)

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(cartoonist: Cartoonist) {
    self.cartoonist = cartoonist
    self.cartoon = cartoonist.table.cartoon
    self.isPlaying = cartoonist.table.isPlaying

    super.init()

    backgroundColor = .yellowishTintColor

    addTitleLabel()
    setupCanvas()
    setupButtons()

    bindToCartoonist()
  }

  private func bindToCartoonist() {
    tableUpdated(cartoonist.table)

    Task { @MainActor in
      for await newTable in cartoonist.asyncTable {
        self.tableUpdated(newTable)
      }
    }
  }

  private func tableUpdated(_ newTable: Cartoonist.Table) {
    cartoon = newTable.cartoon
    isPlaying = newTable.isPlaying

    buttons.appendShot.isEnabled = newTable.canAppendShot
    buttons.deleteShot.isEnabled = newTable.canDeleteLastShot
    
    buttons.play.isEnabled = newTable.canPlayCartoon
    buttons.play.isSelected = newTable.isPlaying

    buttons.undo.isEnabled = newTable.canUndo
    buttons.redo.isEnabled = newTable.canRedo

    buttons.brush.isSelected = newTable.filling != .eraser
    buttons.eraser.isSelected = newTable.filling == .eraser
  }

  private func addTitleLabel() {
    addSubview(titleLabel)

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(100)
      $0.centerX.equalToSuperview()
      $0.left.greaterThanOrEqualToSuperview().offset(16)
    }
  }

  private func setupCanvas() {
    addSubview(canvasView)
    canvasView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Paddings.medium)
      $0.leading.trailing.equalToSuperview()
    }

    insertSubview(canvasBackgroundView, belowSubview: canvasView)
    canvasBackgroundView.snp.makeConstraints {
      $0.edges.equalTo(canvasView)
    }

    previousCanvasView.alpha = 0.5
    insertSubview(previousCanvasView, aboveSubview: canvasBackgroundView)
    previousCanvasView.snp.makeConstraints {
      $0.edges.equalTo(canvasView)
    }

    playbackView.isHidden = true
    addSubview(playbackView)
    playbackView.snp.makeConstraints {
      $0.edges.equalTo(canvasView)
    }

    cartoon.shots.forEach {
      canvasView.shot = $0
      canvasView.draw(UIScreen.main.bounds)
      rasterizedShots += canvasView.rasterizedShot.asArray
    }

    canvasView.shot = cartoon.shots.last!
    previousCanvasView.shot = cartoon.shots.dropLast().last ?? .empty
  }

  private func setupButtons() {
    let buttonsPanel = UIView.horizontalStack(
      distribution: .fillEqually,
      subviews: [
        buttons.brush,
        buttons.eraser,
        buttons.undo,
        buttons.redo,
        buttons.appendShot,
        buttons.deleteShot,
        buttons.play
      ]
    )

    addSubview(buttonsPanel)
    buttonsPanel.snp.makeConstraints {
      $0.top.equalTo(canvasView.snp.bottom)
      $0.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
    }

    bind(button: buttons.undo, toAction: #selector(undoHatch))
    bind(button: buttons.redo, toAction: #selector(redoHatch))
    bind(button: buttons.brush, toAction: #selector(enableBrush))
    bind(button: buttons.eraser, toAction: #selector(enableEraser))
    bind(button: buttons.appendShot, toAction: #selector(appendShot))
    bind(button: buttons.deleteShot, toAction: #selector(deleteShot))
    bind(button: buttons.play, toAction: #selector(play))
  }

  private func bind(button: UIButton,
                    toAction action: Selector) {
    button.addTarget(
      self,
      action: action,
      for: .touchUpInside
    )
  }

  @objc
  private func undoHatch() {
    cartoonist ! .undoHatch
  }

  @objc
  private func redoHatch() {
    cartoonist ! .redoHatch
  }

  @objc
  private func enableBrush() {
    cartoonist ! .enableFilling(.color(.basic))
  }

  @objc
  private func enableEraser() { 
    cartoonist ! .enableFilling(.eraser)
  }

  private func cartoonUpdated() {
    canvasView.shot = cartoon.shots.last!
    previousCanvasView.shot = cartoon.shots.dropLast().last ?? .empty
    canvasView.setNeedsDisplay()
    previousCanvasView.setNeedsDisplay()
  }

  private func isPlayingUpdated() {
    if isPlaying {
      playbackView.isHidden = false
      canvasView.isHidden = true
      previousCanvasView.isHidden = true

      updateCartoonCache()

      playbackView.animationImages = rasterizedShots
      playbackView.animationDuration = cartoon.duration
      playbackView.animationRepeatCount = .max

      playbackView.startAnimating()
    } else {
      playbackView.stopAnimating()
      playbackView.isHidden = true
      canvasView.isHidden = false
      previousCanvasView.isHidden = false
    }
  }

  @objc
  private func appendShot() {
    cartoonist ! .appendShot
  }

  @objc
  private func deleteShot() {
    cartoonist ! .deleteLastShot
  }

  @objc
  private func play() {
    cartoonist ! (isPlaying ? .stopPlaying : .play)
  }

  override var frame: CGRect {
    didSet { updateCartoonCache() }
  }

  override var bounds: CGRect {
    didSet { updateCartoonCache() }
  }

  private func updateCartoonCache() {
    guard frame.width != 0 && frame.height != 0 else { return }

    print("Cartoon hatches count: \(cartoon.hatches.count)")
    print("Cartoon segments count: \(cartoon.segments.count)")

    let startMoment = Date()

    let canvasWidth = 1000

    let canvasFrame = Rect(
      origin: .zero,
      size: .init(
        width: canvasWidth,
        height: Int(CGFloat(canvasWidth) * (frame.height / frame.width))
      )
    )

    rasterizedShots = cartoon.shots.map {
      build(shot: $0, frame: canvasFrame, cgSize: bounds.size)
    }

    let rasterizationFinish = Date()

    let animationInitializationFinish = Date()

    print("Rasterization taken: \(rasterizationFinish.timeIntervalSince(startMoment))")
    print("Animation initialization taken: \(animationInitializationFinish.timeIntervalSince(rasterizationFinish))")
    print("!")
  }

  private func build(shot: Shot,
                     frame: Rect,
                     cgSize: CGSize) -> UIImage {
    let scale = UIScreen.main.scale

    UIGraphicsBeginImageContextWithOptions(cgSize, false, scale)

    UIGraphicsGetCurrentContext().map { cgContext in
      let builder = ShotImageBuilder(
        shot: shot,
        context: cgContext,
        frame: frame,
        cgFrame: .init(origin: .zero, size: cgSize)
      )

      builder.buildImage()
    }

    let image = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()

    return UIImage(cgImage: image!.cgImage!, scale: scale, orientation: .up)
  }
}

