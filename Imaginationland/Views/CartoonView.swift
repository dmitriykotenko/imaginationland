// @ Dmitry Kotenko

import SnapKit
import UIKit


class CartoonView: View {

  let cartoonist: Cartoonist

  var table: Cartoonist.Table

  var rasterizedShots: [UIImage] = []

  var rasterizationCache: ShotsCache?
  

  private let titleLabel = UILabel.large
    .with(textColor: .buttonTintColor)
    .with(text: "Где Пирожок?")

  private let playbackView = UIImageView.imageView(
    image: .canvasBackground, 
    size: nil
  )
  .with(contentMode: .scaleAspectFit)

  private lazy var canvasView = CanvasView(cartoonist: cartoonist)

  private lazy var previousCanvasView = CanvasView(cartoonist: cartoonist)

  private let canvasBackgroundView = UIImageView.imageView(
    image: .canvasBackground,
    size: nil
  )
  .with(contentMode: .scaleAspectFill)

  private lazy var brushChooserView = BrushChooserView(cartoonist: cartoonist)

  private let buttons = (
    undo: UIButton.iconic(image: .undoIcon),
    redo: UIButton.iconic(image: .redoIcon),
    brush: UIButton.iconic(image: .brushIcon),
    eraser: UIButton.iconic(image: .eraserIcon),
    appendShot: UIButton.iconic(image: .pictureIcon),
    deleteShot: UIButton.iconic(image: .trashcanIcon),
    play: UIButton.iconic(
      images: [.normal: .playIcon, .selected: .stopIcon],
      tintColors: [.normal: .buttonTintColor]
    )
  )

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  init(cartoonist: Cartoonist) {
    self.cartoonist = cartoonist
    self.table = cartoonist.table

    super.init()

    addSubviews()
    bindToCartoonist()
  }

  private func addSubviews() {
    addTitleLabel()
    addCanvas()
    addPlaybackView()
    addButtons()
  }

  private func addTitleLabel() {
    addSubview(titleLabel)

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(70)
      $0.centerX.equalToSuperview()
      $0.left.greaterThanOrEqualToSuperview().offset(16)
    }
  }

  private func addCanvas() {
    addSubview(canvasView)
    canvasView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Paddings.medium)
      $0.leading.trailing.equalToSuperview()
    }

    canvasView.cgSizeListeners.append { [cartoonist] in
      cartoonist ! .changeCanvasViewSize($0)
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

    let pearlBackground = PearlView()
    insertSubview(pearlBackground, belowSubview: titleLabel)
    pearlBackground.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(canvasView.snp.top)
    }
  }

  private func addPlaybackView() {
    playbackView.isHidden = true
    addSubview(playbackView)
    playbackView.snp.makeConstraints {
      $0.edges.equalTo(canvasView)
    }

    playbackView.animationRepeatCount = .max
  }

  private func addButtons() {
    addSubview(brushChooserView)
    brushChooserView.snp.makeConstraints {
      $0.top.equalTo(canvasView.snp.bottom)
      $0.leading.trailing.equalTo(safeAreaLayoutGuide)
    }

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
      $0.top.equalTo(brushChooserView.snp.bottom)
      $0.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
    }

    let pearlBackground = PearlView()
    insertSubview(pearlBackground, belowSubview: brushChooserView)
    pearlBackground.snp.makeConstraints {
      $0.top.equalTo(brushChooserView)
      $0.bottom.leading.trailing.equalToSuperview()
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

  @objc private func undoHatch() {
    cartoonist ! .undoHatch
  }

  @objc private func redoHatch() {
    cartoonist ! .redoHatch
  }

  @objc private func enableBrush() {
    cartoonist ! .enableFilling(.color(cartoonist.table.choosedColor))
  }

  @objc private func enableEraser() {
    cartoonist ! .enableFilling(.eraser)
  }

  @objc private func appendShot() {
    cartoonist ! .appendShot
  }

  @objc private func deleteShot() {
    cartoonist ! .deleteLastShot
  }

  @objc private func play() {
    cartoonist ! (table.isPlaying ? .stopPlaying : .play)
  }

  private func bindToCartoonist() {
    cartoonist.listenForTable { [weak self] in self?.tableUpdated($0) }
  }

  private func tableUpdated(_ newTable: Cartoonist.Table) {
    print("Cartoon's view needs to update.")
    print("Cartoon hatches count: \(table.cartoon.hatches.count)")
    print("Cartoon segments count: \(table.cartoon.segments.count)")

    table = newTable

    updateRasterizationCache()
    updateCanvasViews()
    updatePlaybackView()
    updateBrushChooserView()
    updateButtons()
  }

  private func updateCanvasViews() {
    canvasView.isHidden = table.isPlaying
    previousCanvasView.isHidden = table.isPlaying

    canvasView.shot = table.cartoon.shots.last!
    previousCanvasView.shot = table.cartoon.shots.dropLast().last ?? .empty
    canvasView.setNeedsDisplay()
    previousCanvasView.setNeedsDisplay()
  }

  private func updatePlaybackView() {
    initRasterizationsForPlaybackView()
    addLastShotToPlaybackView()

    playbackView.isHidden = !table.isPlaying

    if table.isPlaying {
      playbackView.animationDuration = table.cartoon.duration
      playbackView.startAnimating()
    } else {
      playbackView.stopAnimating()
    }
  }

  private func initRasterizationsForPlaybackView() {
    guard let rasterizationCache else { return }

    if playbackView.animationImages == nil {
      playbackView.animationImages = 
        table.cartoon.shots.compactMap { rasterizationCache.rasterizedVersion(of: $0) }
    }
  }

  private func addLastShotToPlaybackView() {
    guard let rasterizedShot = rasterizedVersionOfLastShot else { return }

    if playbackView.animationImages?.count != table.cartoon.shots.count {
      playbackView.animationImages = (playbackView.animationImages ?? []) + [rasterizedShot]
    } else {
      playbackView.animationImages![playbackView.animationImages!.count - 1] = rasterizedShot
    }
  }

  private func updateBrushChooserView() {
    brushChooserView.alpha = (table.filling == .eraser) ? 0.25 : 1
    brushChooserView.isUserInteractionEnabled = (table.filling != .eraser)
  }

  private func updateButtons() {
    buttons.appendShot.isEnabled = table.canAppendShot
    buttons.deleteShot.isEnabled = table.canDeleteLastShot

    buttons.play.isEnabled = table.canPlayCartoon
    buttons.play.isSelected = table.isPlaying

    buttons.undo.isEnabled = table.canUndo
    buttons.redo.isEnabled = table.canRedo

    buttons.brush.isSelected = table.filling != .eraser
    buttons.eraser.isSelected = table.filling == .eraser
  }

  private func updateRasterizationCache() {
    guard !table.canvasViewSize.isDegenerated else { return }

    if !table.isCompatible(with: rasterizationCache) {
      rasterizationCache = try? .init(
        canvasSize: table.canvasFrame.size,
        cgSize: table.canvasViewSize
      )
    }

    if let lastShot = table.cartoon.lastShot {
      rasterizationCache?.add(shot: lastShot)
    }
  }

  private var rasterizedVersionOfLastShot: UIImage? {
    table.cartoon.lastShot.flatMap {
      rasterizationCache?.rasterizedVersion(of: $0)
    }
  }
}

