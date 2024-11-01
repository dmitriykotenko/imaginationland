// @ Dmitry Kotenko

import Foundation


class Factory {

  let cartoonist = Cartoonist()

  private(set) lazy var viewController = ViewController(cartoonist: cartoonist)
}
