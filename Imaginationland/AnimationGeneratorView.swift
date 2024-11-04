// @ Dmitry Kotenko

import SnapKit
import UIKit


class AnimationGeneratorView: View, UITextFieldDelegate {

  let cartoonist: Cartoonist

  let activityIndicator = UIActivityIndicatorView(style: .large)

  let robotsAreWorkingLabel = UILabel.large
    .with(textColor: .mainTextColor)
    .with(textAlignment: .center)
    .with(text: "Не прикасаться! Работают роботы.")

  let titleLabel = UILabel.large
    .with(textColor: .mainTextColor)
    .with(text: "Количество случайных кадров:")

  let textFieldContainer = View()

  let textFieldBackground = View()
    .with(backgroundColor: .mainBackground.withAlphaComponent(0.5))
    .with(cornerRadius: 10)

  let textField = UITextField.standard

  let errorLabel = UILabel.standard
    .with(textColor: .systemRed)
    .with(text: "Слишком много кадров")

  let button = UIButton.standard.with(title: "Создать анимацию")

  let backgroundButton = UIButton(type: .custom)

  let backgroundView = PearlView()

  var textFieldText: String? {
    didSet { updateButtonAndErrorLabel() }
  }

  var shotsCount: Int? {
    textFieldText.flatMap { Int($0) }
  }

  var table: Cartoonist.Table

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  init(cartoonist: Cartoonist) {
    self.cartoonist = cartoonist
    self.table = cartoonist.table

    super.init()

    addSubviews()
    bindToCartoonist()
  }

  private func addSubviews() {
    backgroundColor = .black.withAlphaComponent(0.5)

    backgroundView.layer.cornerRadius = 20
    backgroundView.clipsToBounds = true
    addSubview(backgroundView)
    backgroundView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    addSubview(backgroundButton)
    backgroundButton.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    backgroundButton.addTarget(
      self, 
      action: #selector(hide),
      for: .touchUpInside
    )

    textFieldText = "50"
    textField.keyboardType = .numberPad
    textField.autocorrectionType = .no
    textField.text = textFieldText
    textField.delegate = self

    textFieldContainer.addSubview(textFieldBackground)
    textFieldBackground.snp.makeConstraints { $0.edges.equalToSuperview() }

    textFieldContainer.addSubview(textField)
    textField.snp.makeConstraints { $0.edges.equalToSuperview().inset(10) }

    button.addTarget(
      self,
      action: #selector(generate),
      for: .touchUpInside
    )

    robotsAreWorkingLabel.isHidden = true

    let foregroundView = UIView.verticalStack(spacing: 10, subviews: [
      titleLabel,
      textFieldContainer,
      errorLabel,
      button,
      activityIndicator,
      robotsAreWorkingLabel
    ])

    addSubview(foregroundView)
    foregroundView.snp.makeConstraints {
      $0.width.equalTo(290)
      $0.edges.equalTo(backgroundView).inset(20)
    }
  }

  private func bindToCartoonist() {
    cartoonist.listenForTable { [weak self] in self?.tableUpdated($0) }
  }

  private func tableUpdated(_ table: Cartoonist.Table) {
    isHidden = (table.randomAnimationGeneration == .hidden)

    switch table.randomAnimationGeneration {
    case .hidden:
      textField.resignFirstResponder()
    case .isPickingShotsCount(let userText):
      activityIndicator.stopAnimating()
      robotsAreWorkingLabel.isHidden = true

      titleLabel.isHidden = false
      textFieldContainer.isHidden = false
      button.isHidden = false

      textFieldText = userText
      if textField.text != userText { textField.text = userText }

      if self.table.randomAnimationGeneration == .hidden {
        textField.becomeFirstResponder()
      }
    case .isGenerating(let shotsCount):
      textField.resignFirstResponder()
      activityIndicator.startAnimating()
      robotsAreWorkingLabel.isHidden = false

      titleLabel.isHidden = true
      textFieldContainer.isHidden = true
      button.isHidden = true
    }

    self.table = table
  }

  func textField(_ textField: UITextField, 
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    textFieldText = textField.text?.replacingCharacters(
      in: Range(range, in: textField.text ?? "")!,
      with: string
    )
    return true
  }

  private func updateButtonAndErrorLabel() {
    if let errorText {
      errorLabel.isHidden = false
      errorLabel.text = errorText
    } else {
      errorLabel.isHidden = true
    }

    button.isEnabled = shotsCount.map { $0 > 0 } ?? false
  }

  private let digits = Set("0123456789")

  private var errorText: String? {
    switch textFieldText {
    case nil:
      nil
    case let someText?:
      if someText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        nil
      } else if someText.contains(where: { !digits.contains($0) }) {
        "Кривое число кадров"
      } else if shotsCount == nil {
        "Слишком много кадров"
      } else {
        nil
      }
    }
  }

  @objc private func generate() {
    if let shotsCount {
      cartoonist ! .generateRandomAnimation(shotsCount: shotsCount)
    }
  }

  @objc private func hide() {
    if table.randomAnimationGeneration.canBeHidden {
      cartoonist ! .hideAnimationGeneratorView
    }
  }
}

