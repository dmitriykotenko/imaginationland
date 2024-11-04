// @ Dmitry Kotenko

import SnapKit
import UIKit


class BrushChooserView: View {

  let cartoonist: Cartoonist

  private var table: Cartoonist.Table

  private lazy var buttons = (
    white: button(color: .white),
    red: button(color: .red),
    black: button(color: .black),
    blue: button(color: .blue)
  )

  private var buttonsAndColors: [UIButton: Color] {
    [
      buttons.white: .white,
      buttons.red: .red,
      buttons.black: .black,
      buttons.blue: .blue
    ]
  }

  private func button(color: Color) -> UIButton {
    .iconic(image: nil)
      .with(cornerRadius: 10)
      .with(backgroundColor: color.asUiColor)
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  init(cartoonist: Cartoonist) {
    self.cartoonist = cartoonist
    self.table = cartoonist.table

    super.init()

    setupButtons()
    bindToCartoonist()
  }

  private func bindToCartoonist() {
    cartoonist.listenForTable { [weak self] in self?.tableUpdated($0) }
  }

  private func tableUpdated(_ newTable: Cartoonist.Table) {
    let currentColor: Color? = switch newTable.filling {
    case .color(let color):
      color
    case .eraser:
      nil
    }

    buttonsAndColors.forEach { button, color in
      button.layer.borderWidth = 3

      button.layer.borderColor = (currentColor == color) ?
        UIColor.greenishTintColor.cgColor :
        UIColor.clear.cgColor
    }

    table = newTable
  }

  private func setupButtons() {
    buttons.white.layer.maskedCorners = [.topLeft, .bottomLeft]
    buttons.red.layer.maskedCorners = []
    buttons.black.layer.maskedCorners = []
    buttons.blue.layer.maskedCorners = [.topRight, .bottomRight]

    let buttonsPanel = UIView.horizontalStack(
      distribution: .fillEqually,
      spacing: 3,
      subviews: [
        buttons.white,
        buttons.red,
        buttons.black,
        buttons.blue
      ]
    )

    addSubview(buttonsPanel)
    buttonsPanel.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(3)
      $0.bottom.equalToSuperview()
    }

    bind(button: buttons.white, toAction: #selector(selectColor))
    bind(button: buttons.red, toAction: #selector(selectColor))
    bind(button: buttons.black, toAction: #selector(selectColor))
    bind(button: buttons.blue, toAction: #selector(selectColor))
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
  private func selectColor(via tappedButton: UIButton) {
    let color = buttonsAndColors
      .first { button, color in button == tappedButton }?.value
      ?? .black

    cartoonist ! .updateFilling(
      old: table.filling,
      new: .color(color)
    )
  }
}

