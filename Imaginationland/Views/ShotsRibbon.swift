// @ Dmitry Kotenko

import SnapKit
import UIKit


class ShotsRibbon: View {

  let cartoonist: Cartoonist

  var table: Cartoonist.Table

  var shots: [Shot] { table.cartoon.shots }

  var rasterizationCache: ShotsCache?

  private let collectionView = CollectionView(
    isPagingEnabled: false,
    cellSubviewType: UIImageView.self
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
    backgroundColor = .systemOrange

    snp.makeConstraints {
      $0.height.equalTo(60 + 8)
    }

    collectionView.backgroundColor = .orange
    addSubview(collectionView)
    collectionView.snp.makeConstraints { $0.edges.equalToSuperview().inset(4) }

    collectionView.dataSource = self
    collectionView.delegate = self
  }

  private func bindToCartoonist() {
    cartoonist.listenForTable { [weak self] in self?.tableUpdated($0) }
  }

  private func tableUpdated(_ newTable: Cartoonist.Table) {
//    print("Shots ribbon needs to update.")

    table = newTable

    updateRasterizationCache()

    isUserInteractionEnabled = !table.isPlaying

    collectionView.reloadData()

    collectionView.selectItem(
      at: .init(row: table.currentShotIndex, section: 0),
      animated: true,
      scrollPosition: .centeredHorizontally
    )
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
}


extension ShotsRibbon: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    shots.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    .init(
      height: 66,
      widthPerHeight: table.canvasViewSize.widthPerHeight
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

    return cell
  }

  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    cartoonist ! .startEditingOfShot(
      id: shots[indexPath.row].id
    )
  }
}
