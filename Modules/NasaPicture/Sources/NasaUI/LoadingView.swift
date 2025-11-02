import SwiftUI

public struct LoadingView: View {
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.clear
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView()
}

