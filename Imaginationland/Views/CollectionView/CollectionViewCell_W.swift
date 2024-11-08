//// @ Dmitry Kotenko
//
//import AVFoundation
//import SnapKit
//import UIKit
//
//
///// Wraps any UIView, so it can be used inside UITableView.
//open class WrapperCell<MainSubview: UIView>: UICollectionViewCell {
//
//  open var initMainSubview: () -> MainSubview = { MainSubview() }
//  open var mainSubviewInsets: UIEdgeInsets = .zero
//
//  private var mainSubview: MainSubview?
//
//  public var bottomShadow: UIView?
//
//  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//
//  ini
//
//  override init(style: UITableViewCell.CellStyle,
//                reuseIdentifier: String?) {
//    super.init(style: style, reuseIdentifier: reuseIdentifier)
//  }
//
//  private func initIfNeeded() {
//    guard mainSubview == nil else { return }
//
//    addMainSubview()
//
//    backgroundColor = .clear
//    contentView.backgroundColor = .clear
//    selectionStyle = .none
//
//    setupBottomShadow()
//  }
//
//  private func addMainSubview() {
//    mainSubview = initMainSubview()
//
//    mainSubview.map(contentView.addSubview)
//  }
//
//  open func displayValue(_ value: Value?) {
//    initIfNeeded()
//
//    mainSubview?.value.onNext(value)
//
//    layoutIfNeeded()
//  }
//
//  private func setupBottomShadow() {
//    bottomShadow.map(setupBottomShadow)
//  }
//
//  private func setupBottomShadow(_ bottomShadow: UIView) {
//    contentView.addSubview(bottomShadow)
//
//    disposeBag {
//      bottomShadow.rx.isVisible <== _relativePosition.map { $0.isLastRow && !$0.isLastSection }
//    }
//  }
//
//  override open func sizeThatFits(_ size: CGSize) -> CGSize {
//    initIfNeeded()
//
//    var fixedSize = size
//    // If the table view uses .automaticDimension constant for its cells height, size.height becomes zero.
//    // This means that we must manually determine most preferred height.
//    if size.height <= 0 { fixedSize.height = .greatestFiniteMagnitude }
//
//    return mainSubview?
//      .sizeThatFits(fixedSize.insetBy(mainSubviewInsets))
//      .insetBy(mainSubviewInsets.negated)
//    ?? frame.size
//  }
//
//  override open func layoutSubviews() {
//    initIfNeeded()
//
//    super.layoutSubviews()
//
//    mainSubview?.frame = contentView.bounds.inset(by: mainSubviewInsets)
//
//    bottomShadow.map {
//      $0.frame = .init(
//        x: 0,
//        y: contentView.frame.height,
//        width: contentView.frame.width,
//        height: $0.frame.height
//      )
//    }
//
//    mainSubview?.setNeedsLayout()
//    mainSubview?.layoutIfNeeded()
//  }
//}
//
//
//extension WrapperCell: MarkableView where MainSubview: MarkableView {
//
//  public var textToMark: AnyObserver<String?> {
//    mainSubview?.textToMark ?? .empty
//  }
//}
//
//
//extension WrapperCell: TemporalView where MainSubview: TemporalView {
//
//  public var clock: AnyObserver<Clock?> {
//    mainSubview?.clock ?? .empty
//  }
//}
