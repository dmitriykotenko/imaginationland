// @ Dmitry Kotenko

import SnapKit
import UIKit


class ShotsRibbon: View {

  let cartoonist: Cartoonist

  var oldShotsCount: Int = 0
  var table: Cartoonist.Table

  var shots: [Shot] { table.cartoon.shots }

  var currentShotIndex: Int = 0

  var rasterizationCache: ShotsCache?

  var visibleIndices: Set<Int> = []

  private let collectionView = CollectionView(
    isPagingEnabled: false,
    cellSubviewType: UIImageView.self
  )

  private let buttons = (
    rewind: UIButton.iconic(image: .rewindIcon),
    fastForward: UIButton.iconic(image: .fastForwardIcon)
  )

  private let unselectedShotScale: CGFloat = 0.7

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  init(cartoonist: Cartoonist) {
    self.cartoonist = cartoonist
    self.table = cartoonist.table

    super.init()

    addSubviews()
    bindToCartoonist()
  }

  private func addSubviews() {
//    backgroundColor = .systemOrange

    snp.makeConstraints {
      $0.height.equalTo(60 + 8)
    }

    collectionView.dataSource = self
    collectionView.delegate = self

    addSubview(buttons.rewind)
    buttons.rewind.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
    }

    addSubview(buttons.fastForward)
    buttons.fastForward.snp.makeConstraints {
      $0.top.trailing.bottom.equalToSuperview()
    }

    buttons.rewind.addTarget(
      self,
      action: #selector(rewind),
      for: .touchUpInside
    )

    buttons.fastForward.addTarget(
      self,
      action: #selector(fastForward),
      for: .touchUpInside
    )

    collectionView.backgroundColor = .clear
    addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(4)
      $0.leading.equalTo(buttons.rewind.snp.trailing).inset(4)
      $0.trailing.equalTo(buttons.fastForward.snp.leading).inset(4)
    }
  }

  private func bindToCartoonist() {
    cartoonist.listenForTable { [weak self] in self?.tableUpdated($0) }
  }

  private func tableUpdated(_ newTable: Cartoonist.Table) {
//    print("Shots ribbon needs to update.")

    table = newTable
    currentShotIndex = newTable.currentShotIndex

    updateRasterizationCache()

    isUserInteractionEnabled = !table.isPlaying
    collectionView.alpha = table.isPlaying ? 0.5 : 1

    buttons.rewind.isEnabled = !table.isPlaying
    buttons.fastForward.isEnabled = !table.isPlaying

    // TODO: reload only updated shots
    collectionView.reloadData()

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      // TODO: do not scroll if selected shot is the same.
      self.collectionView.scrollToItem(
        at: .init(row: self.currentShotIndex, section: 0),
        at: .centeredHorizontally,
        animated: self.oldShotsCount != 0
      )

      self.oldShotsCount = self.table.cartoon.shots.count
    }
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

  @objc private func rewind() {
    cartoonist ! .go(
      fromShotId: table.currentShotId, 
      toShotId: 
        (visibleIndices.min() ?? 0) <= currentShotIndex - 1 ?
          table.cartoon.shots[0].id :
          table.currentShotId
    )
  }

  @objc private func fastForward() {
    cartoonist ! .go(
      fromShotId: table.currentShotId,
      toShotId:
        (visibleIndices.max() ?? (table.cartoon.shots.count - 1)) >= currentShotIndex + 1 ?
          table.cartoon.shots.last!.id :
          table.currentShotId
    )
  }
}


extension ShotsRibbon: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    shots.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height: CGFloat = 66
    var width: CGFloat = 66 * table.canvasViewSize.widthPerHeight

    if indexPath.row != currentShotIndex { width *= unselectedShotScale }

    return .init(
      width: width,
      height: height
    )
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(
      CollectionViewCell<UIImageView>.self,
      indexPath: indexPath
    )

    cell.subview.translatesAutoresizingMaskIntoConstraints = false
    cell.subview.contentMode = .scaleAspectFit
    cell.subview.image =
      rasterizationCache?.rasterizedVersion(of: shots[indexPath.row]).flippedVertically

    cell.contentView.subviews.forEach {
      $0.transform = 
      if indexPath.row == currentShotIndex {
        .identity
      } else {
        .init(scaleX: unselectedShotScale, y: unselectedShotScale)
      }
    }

    return cell
  }

  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    cartoonist ! .go(
      fromShotId: table.currentShotId, 
      toShotId: shots[indexPath.row].id
    )
  }

  func collectionView(_ collectionView: UICollectionView, 
                      willDisplay cell: UICollectionViewCell,
                      forItemAt indexPath: IndexPath) {
    visibleIndices.insert(indexPath.row)
  }

  func collectionView(_ collectionView: UICollectionView, 
                      didEndDisplaying cell: UICollectionViewCell,
                      forItemAt indexPath: IndexPath) {
    visibleIndices.remove(indexPath.row)
  }
}
