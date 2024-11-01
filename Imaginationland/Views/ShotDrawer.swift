// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


struct ShotDrawer {

  var shot: Shot
  var context: CGContext
  var frame: Rect
  var cgFrame: CGRect

  @discardableResult func draw() -> UIImage {
    let image = buildImage()
    image.draw(in: cgFrame)
    return image
  }

  private func buildImage() -> UIImage {
    let scale = UIScreen.main.scale

    UIGraphicsBeginImageContextWithOptions(cgFrame.size, false, scale)

    UIGraphicsGetCurrentContext().map { cgContext in
      let builder = ShotImageBuilder(
        shot: shot,
        context: cgContext,
        frame: frame,
        cgFrame: cgFrame
      )

      builder.buildImage()
    }

    let image = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()

    return UIImage(cgImage: image!.cgImage!, scale: scale, orientation: .up)
  }
}
