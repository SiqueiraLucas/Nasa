import SwiftUI

public final class Feature {
    private let dependencies: Dependencies

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    public func initialView() -> some View {
        return Home.Initializer.createView(dependencies: dependencies)
    }
}
