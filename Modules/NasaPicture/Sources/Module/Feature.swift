import UIKit

public final class Feature {
    private let dependencies: Dependencies

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    public func initialViewController() -> UIViewController? {
        return Home.Initializer.createViewController(dependencies: dependencies)
    }
}
