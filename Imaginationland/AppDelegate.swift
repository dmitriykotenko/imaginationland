// @ Dmitry Kotenko

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  let factory = Factory()

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)

    window.rootViewController = factory.viewController
    window.makeKeyAndVisible()

    self.window = window

    return true
  }
}

