// @ Dmitry Kotenko

import SnapKit
import UIKit


class PearlView: View {

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  init() {
    super.init()

    let imageViewToBlur = UIImageView.imageView(
      image: .tranclucentBackgroundBase,
      size: nil
    ).with(contentMode: .scaleToFill)

    imageViewToBlur.clipsToBounds = true
    addSubview(imageViewToBlur)
    imageViewToBlur.snp.makeConstraints { $0.edges.equalToSuperview() }

    let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
    let blurredEffectView = UIVisualEffectView(effect: blurEffect)
    
    addSubview(blurredEffectView)
    blurredEffectView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
}

