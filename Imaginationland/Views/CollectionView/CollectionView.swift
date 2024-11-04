// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


class CollectionView<CellSubview: UIView>: UICollectionView {

  var isTransparentForGestures: Bool
  var customAlignmentRectInsets: UIEdgeInsets

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  init(isTransparentForGestures: Bool = false,
       alignmentRectInsets: UIEdgeInsets = .zero,
       isPagingEnabled: Bool,
       cellSubviewType: CellSubview.Type) {
    self.isTransparentForGestures = isTransparentForGestures
    self.customAlignmentRectInsets = alignmentRectInsets

    super.init(
      frame: .zero,
      collectionViewLayout: .horizontal(
        minimumLineSpacing: 0,
        minimumInteritemSpacing: 2,
        sectionInset: .init(top: 0, left: 100, bottom: 0, right: 100))
    )
    
    self.isPagingEnabled = isPagingEnabled

    translatesAutoresizingMaskIntoConstraints = false
    contentInsetAdjustmentBehavior = .never
    showsHorizontalScrollIndicator = false

    register(
      CollectionViewCell<CellSubview>.self,
      forCellWithReuseIdentifier: CollectionViewCell<CellSubview>.staticReuseIdentifier
    )
  }

  override var alignmentRectInsets: UIEdgeInsets {
    customAlignmentRectInsets
  }

  override open func hitTest(_ point: CGPoint,
                             with event: UIEvent?) -> UIView? {
    let hit = super.hitTest(point, with: event)

    switch hit {
    case self: return isTransparentForGestures ? nil : self
    default: return hit
    }
  }
}


extension UICollectionView {

  func dequeue<Cell: UICollectionViewCell>(_ cellType: Cell.Type,
                                           indexPath: IndexPath) -> Cell {
    dequeueReusableCell(withReuseIdentifier: cellIdentifier(cellType), for: indexPath) as! Cell
  }

  private func cellIdentifier<Cell: UICollectionViewCell>(_ type: Cell.Type) -> String {
    String(describing: Cell.self)
  }
}
