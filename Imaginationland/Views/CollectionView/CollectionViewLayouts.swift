// @ Dmitry Kotenko

import AVFoundation
import SnapKit
import UIKit


extension UICollectionViewLayout {

  static func horizontal(minimumLineSpacing: CGFloat,
                         minimumInteritemSpacing: CGFloat,
                         sectionInset: UIEdgeInsets) -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()

    layout.scrollDirection = .horizontal

    //Spacing here is not necessary, but adds a better inset for horizontal scrolling.
    // Gives you a tiny peek of the background. Probably not great for vertical
    layout.minimumLineSpacing = minimumLineSpacing

    layout.minimumInteritemSpacing = minimumInteritemSpacing
    
    layout.sectionInset = sectionInset

    return layout
  }
}
