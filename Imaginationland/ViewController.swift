// @ Dmitry Kotenko

import SnapKit
import UIKit


class ViewController: UIViewController {

  private let label = UILabel.large
    .with(textColor: .systemPurple)
    .with(text: "Всё, что ниже — холст")

  private lazy var cartoonView = CartoonView(cartoonist: cartoonist)

  private let cartoonist: Cartoonist

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  init(cartoonist: Cartoonist) {
    self.cartoonist = cartoonist

    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(cartoonView)
    cartoonView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
}

