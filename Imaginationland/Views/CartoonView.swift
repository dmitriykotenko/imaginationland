// @ Dmitry Kotenko

import SnapKit
import UIKit


class CartoonView: View {

  let cartoonist: Cartoonist

  var table: Cartoonist.Table

  var rasterizedShots: [UIImage] = []

  var rasterizationCache: ShotsCache?

  private let playbackView = UIImageView.imageView(
    image: .canvasBackground, 
    size: nil
  )
  .with(contentMode: .scaleAspectFit)

  private lazy var canvasView = CanvasView(cartoonist: cartoonist)

  private lazy var previousCanvasView = CanvasView(cartoonist: cartoonist)

  private lazy var animationGeneratorView = AnimationGeneratorView(cartoonist: cartoonist)

  private let canvasBackgroundView = UIImageView.imageView(
    image: .canvasBackground,
    size: nil
  )
  .with(contentMode: .scaleAspectFill)

  private lazy var brushChooserView = BrushChooserView(cartoonist: cartoonist)

  private lazy var topButtonsPanel: UIView = {
    let panel = View()

    let left = UIView.horizontalStack(
      distribution: .fillEqually,
      subviews: [buttons.undo, buttons.redo]
    )

    let right = UIView.horizontalStack(
      distribution: .fillEqually,
      subviews: [buttons.generateRandomAnimation, buttons.help]
    )

    panel.addSubview(left)
    left.snp.makeConstraints {
      $0.top.bottom.leading.equalToSuperview()
    }

    panel.addSubview(right)
    right.snp.makeConstraints {
      $0.top.bottom.trailing.equalToSuperview()
    }

    panel.addSubview(buttons.play)
    buttons.play.snp.makeConstraints {
      $0.top.bottom.centerX.equalToSuperview()
    }

    return panel
  }()

  private lazy var bottomButtonsPanel = UIView.horizontalStack(
    distribution: .fillEqually,
    subviews: [
      buttons.brush,
      buttons.eraser,
      buttons.appendShot,
      buttons.duplicateShot,
      buttons.deleteShot,
      buttons.deleteEverything,
    ]
  )

  private let buttons = (
    undo: UIButton.iconic(image: .undoIcon),
    redo: UIButton.iconic(image: .redoIcon),
    brush: UIButton.iconic(image: .brushIcon),
    eraser: UIButton.iconic(image: .eraserIcon),
    appendShot: UIButton.iconic(image: .plusIcon),
    duplicateShot: UIButton.iconic(image: .pictureIcon),
    deleteShot: UIButton.iconic(image: .trashcanIcon),
    deleteEverything: UIButton.iconic(image: .trashcansIcon),
    generateRandomAnimation: UIButton.iconic(image: .magicWand1icon),
    play: UIButton.iconic(
      images: [.normal: .playIcon, .selected: .stopIcon],
      tintColors: [.normal: .buttonTintColor]
    ),
    help: UIButton.iconic(image: .commandIcon)
  )

  private lazy var shotsRibbon = ShotsRibbon(cartoonist: cartoonist)

  private lazy var helpView = HelpView(cartoonist: cartoonist)

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  init(cartoonist: Cartoonist) {
    self.cartoonist = cartoonist
    self.table = cartoonist.table

    super.init()

    addSubviews()
    bindToCartoonist()
  }

  private func addSubviews() {
    addTopButtons()
    addCanvas()
    addPlaybackView()
    addBottomButtons()
    addShotsRibbon()

    animationGeneratorView.isHidden = true
    addSubview(animationGeneratorView)
    animationGeneratorView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    addSubview(helpView)
    helpView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private func addTopButtons() {
    addSubview(topButtonsPanel)

    topButtonsPanel.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
    }
  }

  private func addCanvas() {
    addSubview(canvasView)
    canvasView.snp.makeConstraints {
      $0.top.equalTo(topButtonsPanel.snp.bottom).offset(Paddings.medium)
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
    insertSubview(pearlBackground, belowSubview: topButtonsPanel)
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

  private func addBottomButtons() {
    addSubview(brushChooserView)
    brushChooserView.snp.makeConstraints {
      $0.top.equalTo(canvasView.snp.bottom)
      $0.leading.trailing.equalTo(safeAreaLayoutGuide)
    }

    addSubview(bottomButtonsPanel)
    bottomButtonsPanel.snp.makeConstraints {
      $0.top.equalTo(brushChooserView.snp.bottom)
      $0.leading.trailing.equalTo(safeAreaLayoutGuide)
//      $0.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
    }

    let pearlBackground = PearlView()
    insertSubview(pearlBackground, belowSubview: brushChooserView)
    pearlBackground.snp.makeConstraints {
      $0.top.equalTo(brushChooserView)
      $0.bottom.leading.trailing.equalToSuperview()
    }

    bind(button: buttons.undo, toAction: #selector(undoHatch))
    bind(button: buttons.redo, toAction: #selector(redoHatch))
    bind(button: buttons.help, toAction: #selector(help))

    bind(button: buttons.brush, toAction: #selector(enableBrush))
    bind(button: buttons.eraser, toAction: #selector(enableEraser))
    bind(button: buttons.appendShot, toAction: #selector(appendShot))
    bind(button: buttons.duplicateShot, toAction: #selector(duplicateShot))
    bind(button: buttons.generateRandomAnimation, toAction: #selector(generateRandomAnimation))
    bind(button: buttons.deleteShot, toAction: #selector(deleteShot))
    bind(button: buttons.deleteEverything, toAction: #selector(deleteEverything))
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

  private func addShotsRibbon() {
    addSubview(shotsRibbon)
    shotsRibbon.snp.makeConstraints {
      $0.top.equalTo(bottomButtonsPanel.snp.bottom)
      $0.bottom.leading.trailing.equalTo(safeAreaLayoutGuide)
    }
  }

  @objc private func undoHatch() {
    cartoonist ! .undo
//    cartoonist ! .undoHatch
  }

  @objc private func redoHatch() {
    cartoonist ! .redo
//    cartoonist ! .redoHatch
  }

  @objc private func enableBrush() {
    cartoonist ! .updateFilling(
      old: table.filling,
      new: .color(table.choosedColor)
    )
  }

  @objc private func enableEraser() {
    cartoonist ! .updateFilling(
      old: table.filling,
      new: .eraser
    )
  }

  @objc private func appendShot() {
    cartoonist ! .insertShot(
      .empty, 
      atIndex: table.currentShotIndex + 1
    )
  }

  @objc private func duplicateShot() {
    cartoonist ! .insertShot(
      table.currentShot.duplicated,
      atIndex: table.currentShotIndex + 1
    )
  }

  @objc private func deleteShot() {
    switch table.cartoon.shots.count {
    case 1:
      cartoonist ! .clearTheOnlyShot(shot: table.currentShot)
    default:
      cartoonist ! .deleteShot(
        shot: table.currentShot,
        atIndex: table.currentShotIndex
      )
    }
  }

  @objc private func deleteEverything() {
    cartoonist ! .deleteShots(
      shots: table.cartoon.shots,
      currentShotId: table.currentShotId
    )
  }

  @objc private func generateRandomAnimation() {
    cartoonist ! .showAnimationGeneratorView
  }

  @objc private func play() {
    cartoonist ! (table.isPlaying ? .stopPlaying : .play)
  }

  @objc private func help() {
    cartoonist ! .showHelp
  }

  private func bindToCartoonist() {
    cartoonist.listenForTable { [weak self] in self?.tableUpdated($0) }
  }

  private func tableUpdated(_ newTable: Cartoonist.Table) {
//    print("Cartoon's view needs to update.")
//    print("Cartoon hatches count: \(table.cartoon.hatches.count)")
//    print("Cartoon segments count: \(table.cartoon.segments.count)")

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

//    print("Current shot index: \(table.currentShotIndex)")
    canvasView.shot = table.currentShot

    previousCanvasView.shot = 
      table.cartoon.shots.prefix { $0.id != table.currentShotId }.last ?? .empty

    canvasView.setNeedsDisplay()
    previousCanvasView.setNeedsDisplay()
  }

  private func updatePlaybackView() {
    updatePlaybackImages()

    playbackView.isHidden = !table.isPlaying

    if table.isPlaying {
      playbackView.animationDuration = table.cartoon.duration
      playbackView.startAnimating()
    } else {
      playbackView.stopAnimating()
    }
  }

  private func updatePlaybackImages() {
    guard let rasterizationCache else { return }

    playbackView.animationImages =
      table.cartoon.shots.compactMap { rasterizationCache.rasterizedVersion(of: $0) }

    playbackView.transform = .init(scaleX: 1, y: -1)
  }

  private func updateBrushChooserView() {
    let shouldBeEnabled = (table.filling != .eraser) && !table.isPlaying
    brushChooserView.isUserInteractionEnabled = shouldBeEnabled
    brushChooserView.alpha = shouldBeEnabled ? 1 : 0.25
  }

  private func updateButtons() {
    buttons.brush.isEnabled = !table.isPlaying
    buttons.eraser.isEnabled = !table.isPlaying

    buttons.appendShot.isEnabled = table.canAppendShot
    buttons.duplicateShot.isEnabled = table.canDuplicateShot
    buttons.generateRandomAnimation.isEnabled = table.canGenerateRandomAnimation

    buttons.deleteShot.isEnabled = table.canDeleteCurrentShot
    buttons.deleteEverything.isEnabled = table.canDeleteEverything

    buttons.play.isEnabled = table.canPlayCartoon
    buttons.play.setImage(table.isPlaying ? .stopIcon : .playIcon, for: .normal)

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

    rasterizationCache?.add(shot: table.currentShot)
  }

  private var rasterizedVersionOfCurrentShot: UIImage? {
    rasterizationCache?.rasterizedVersion(of: table.currentShot)
  }
}

