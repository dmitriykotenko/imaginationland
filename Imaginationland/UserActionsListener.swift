// @ Dmitry Kotenko

import Foundation


protocol UserActionsListener: AnyObject {

  func process(userAction: UserAction)
}
