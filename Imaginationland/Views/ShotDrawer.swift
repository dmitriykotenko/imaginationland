// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


struct ShotDrawer {

  var shot: Shot
  var context: CGContext
  var frame: Rect
  var cgFrame: CGRect

  var numberOfRasterizedHatches: Int
  var rasterizedPartOfShot: UIImage?
  var newHatches: [Hatch]

  @discardableResult func draw() -> UIImage {
    buildImage()
  }

  private func buildImage() -> UIImage {
    let builder = ShotImageBuilder(
      shot: shot,
      context: context,
      frame: frame,
      cgFrame: cgFrame,
      numberOfRasterizedHatches: numberOfRasterizedHatches,
      rasterizedPartOfShot: rasterizedPartOfShot,
      newHatches: newHatches
    )

    builder.buildImage()
    
    let cgImage = context.makeImage()

    return UIImage(cgImage: cgImage!, scale: UIScreen.main.scale, orientation: .downMirrored)
  }

  private func buildImage2() -> UIImage {
    let scale = UIScreen.main.scale

    UIGraphicsBeginImageContextWithOptions(cgFrame.size, false, scale)

    UIGraphicsGetCurrentContext().map { cgContext in
      let builder = ShotImageBuilder(
        shot: shot,
        context: cgContext,
        frame: frame,
        cgFrame: cgFrame,
        numberOfRasterizedHatches: numberOfRasterizedHatches,
        rasterizedPartOfShot: rasterizedPartOfShot,
        newHatches: newHatches
      )

      builder.buildImage()
    }

    let image = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()

//    return image!
    return UIImage(cgImage: image!.cgImage!, scale: scale, orientation: .up)
  }
}


extension UIImage {

  var flippedVertically: UIImage {
    cgImage
      .map { UIImage(cgImage: $0, scale: scale, orientation: .downMirrored) }
      ?? self
  }
}
