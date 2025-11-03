import SwiftUI

public struct FavoriteButtonView: View {
    public let favorite: Bool
    public var action: () -> Void
    
    public init(
        favorite: Bool,
        action: @escaping () -> Void
    ) {
        self.favorite = favorite
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: favorite ? "heart.fill" : "heart")
                .foregroundColor(favorite ? .red : .white)
                .padding(6)
                .background(Color.black.opacity(0.3))
                .clipShape(Circle())
                .padding(6)
        }
    }
}


#Preview {
    FavoriteButtonView(
        favorite: false,
        action: {
            print("Touch favorite")
        }
    )
}
