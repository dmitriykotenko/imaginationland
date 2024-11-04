// @ Dmitry Kotenko

import SnapKit
import UIKit


class HelpView: View, UITextFieldDelegate {

  let cartoonist: Cartoonist

  let backgroundView = PearlView()

  let closeButton = Button.iconic(image: .closeIcon)

  let titleLabel = UILabel.giant
    .with(textColor: .mainTextColor)
    .with(text: "Справка")

  let contentLabel = UILabel.standard
    .with(textColor: .mainTextColor)
    .with(
      text: """
      В приложении (по надежде автора) бесконечный Undo.

      В Undo-стэк попадают, в том числе, переход к другому кадру, \
      генерация случайной анимации, \
      переключение с кисточки на ластик \
      и изменение цвета кисточки.

      Портретик дублирует текущий кадр.

      Волшебная палочка спрашивает количество кадров \
      и генерирует случайную анимацию, заменяющую все предыдущие кадры. \
      Если кадров больше нескольких сотен, генерацию придётся подождать.

      Стрелки прокручивают раскадровку или к выделенному кадру, или к границам анимации \
      (при этом граничный кадр становится выделенным).

      Скорость анимации — 10 кадров в секунду.
      """
    )

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  init(cartoonist: Cartoonist) {
    self.cartoonist = cartoonist

    super.init()

    addSubviews()
    bindToCartoonist()
  }

  private func addSubviews() {
    addSubview(backgroundView)
    backgroundView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    addSubview(closeButton)
    closeButton.snp.makeConstraints {
      $0.top.trailing.equalTo(safeAreaLayoutGuide)
    }

    closeButton.addTarget(
      self, 
      action: #selector(close), 
      for: .touchUpInside
    )

    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(safeAreaLayoutGuide)
    }

    addSubview(contentLabel)
    contentLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
    }
  }

  private func bindToCartoonist() {
    cartoonist.listenForTable { [weak self] in self?.tableUpdated($0) }
  }

  private func tableUpdated(_ table: Cartoonist.Table) {
    isHidden = !table.isHelpShown
    alpha = 1
    transform = .identity
  }

  @objc private func close() {

    UIView.animate(
      withDuration: 
        UserDefaults.standard.isHelpShown ? 0.25 : 0.5,
      animations: {
        self.transform = .init(scaleX: 0.2, y: 0.2)
          .concatenating(
            .init(
              translationX: UIScreen.main.bounds.width / 2 - 22,
              y: -UIScreen.main.bounds.height / 2 + 50
            )
          )
        self.alpha = 0
      },
      completion: { _ in
        self.cartoonist ! .hideHelp
      }
    )
  }
}



extension UserDefaults {

  var isHelpShown: Bool {
    get {
      self.bool(forKey: "is-help-shown-3")
    }
    set {
      self.setValue(newValue, forKey: "is-help-shown-3")
      self.synchronize()
    }
  }
}
