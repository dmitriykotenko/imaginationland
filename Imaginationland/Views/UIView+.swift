// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


extension UIView {

  static func horizontalStack(alignment: UIStackView.Alignment = .fill,
                              distribution: UIStackView.Distribution = .fill,
                              spacing: CGFloat = 0,
                              subviews: [UIView]) -> UIStackView {
    stack(
      axis: .horizontal,
      alignment: alignment,
      distribution: distribution,
      spacing: spacing,
      subviews: subviews
    )
  }
  
  static func verticalStack(alignment: UIStackView.Alignment = .fill,
                            distribution: UIStackView.Distribution = .fill,
                            spacing: CGFloat = 0,
                            subviews: [UIView]) -> UIStackView {
    stack(
      axis: .vertical,
      alignment: alignment,
      distribution: distribution,
      spacing: spacing,
      subviews: subviews
    )
  }
  
  static func stack(axis: NSLayoutConstraint.Axis,
                    alignment: UIStackView.Alignment = .fill,
                    distribution: UIStackView.Distribution = .fill,
                    spacing: CGFloat = 0,
                    subviews: [UIView]) -> UIStackView {
    let stack = UIStackView().preparedForAutoLayout()
    
    stack.axis = axis
    stack.alignment = alignment
    stack.distribution = distribution
    stack.spacing = spacing

    subviews.forEach { stack.addArrangedSubview($0) }

    return stack
  }

  func preparedForAutoLayout() -> Self {
    translatesAutoresizingMaskIntoConstraints = false
    return self
  }

  func addVerticalStack(ofChildViews childViews: [UIView],
                        insets: UIEdgeInsets = .zero,
                        spacing: CGFloat = 0) {
    childViews.enumerated().forEach { index, childView in
      let previousChildView = (index == 0) ? nil : childViews[index - 1]

      add(
        childView: childView,
        toTheBottomOf: previousChildView,
        isLast: index == childViews.count - 1,
        globalInsets: insets,
        spacing: spacing
      )
    }
  }

  private func add(childView: UIView,
                   after previousChildView: UIView?,
                   isLast: Bool,
                   globalInsets: UIEdgeInsets,
                   spacing: CGFloat) {
    addSubview(childView)
    childView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(globalInsets.left)
      $0.trailing.equalToSuperview().offset(-globalInsets.right)

      if let previousChildView {
        $0.top.equalTo(previousChildView.snp.bottom).offset(spacing)
      } else {
        $0.top.equalToSuperview().offset(globalInsets.top)
      }

      if isLast {
        $0.bottom.equalToSuperview().offset(-globalInsets.bottom)
      }
    }
  }

  private func add(childView: UIView,
                   toTheBottomOf previousChildView: UIView?,
                   isLast: Bool,
                   globalInsets: UIEdgeInsets,
                   spacing: CGFloat) {
    addSubview(childView)
    childView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(globalInsets.left)
      $0.trailing.equalToSuperview().offset(-globalInsets.right)

      if let previousChildView {
        $0.top.equalTo(previousChildView.snp.bottom).offset(spacing)
      } else {
        $0.top.equalToSuperview().offset(globalInsets.top)
      }

      if isLast {
        $0.bottom.equalToSuperview().offset(-globalInsets.bottom)
      }
    }
  }

  func addHorizontalStack(ofChildViews childViews: [UIView],
                          insets: UIEdgeInsets = .zero,
                          spacing: CGFloat = 0) {
    childViews.enumerated().forEach { index, childView in
      let previousChildView = (index == 0) ? nil : childViews[index - 1]

      add(
        childView: childView,
        toTheRightFrom: previousChildView,
        isLast: index == childViews.count - 1,
        globalInsets: insets,
        spacing: spacing
      )
    }
  }

  private func add(childView: UIView,
                   toTheRightFrom previousChildView: UIView?,
                   isLast: Bool,
                   globalInsets: UIEdgeInsets,
                   spacing: CGFloat) {
    addSubview(childView)
    childView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(globalInsets.top)
      $0.bottom.equalToSuperview().offset(-globalInsets.bottom)

      if let previousChildView {
        $0.leading.equalTo(previousChildView.snp.trailing).offset(spacing)
      } else {
        $0.leading.equalToSuperview().offset(globalInsets.left)
      }

      if isLast {
        $0.trailing.equalToSuperview().offset(-globalInsets.right)
      }
    }
  }
}
