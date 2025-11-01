import SwiftUI

public struct LoadingView: View {
    public var body: some View {
        VStack() {
            Spacer()
            
            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height)
    }
}

#Preview {
    LoadingView()
}

