// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


class CollectionViewCell<Subview: UIView>: UICollectionViewCell {

  let subview = Subview()

  static var staticReuseIdentifier: String { "\(Self.self)" }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview()
  }

  private func addSubview() {
    let backgroundView = UIImageView.imageView(image: .canvasBackground, size: nil)
    backgroundView.contentMode = .scaleToFill
    backgroundView.clipsToBounds = true

    contentView.addSubview(backgroundView)
    backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }

    contentView.addSubview(subview)
    subview.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
}
