import UIKit

extension Home {
    enum Initializer {
        static func createViewController(dependencies: Dependencies) -> UIViewController {
            let viewController = HomeViewController()
            return viewController
        }
    }
}
