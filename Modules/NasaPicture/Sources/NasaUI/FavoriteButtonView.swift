import SwiftUI

struct FavoriteButtonView: View {
    let action: () -> Void
    @State private var isFavorite: Bool

    init(favorite: Bool, action: @escaping () -> Void) {
        self._isFavorite = State(initialValue: favorite)
        self.action = action
    }

    var body: some View {
        Button {
            isFavorite.toggle()
            action()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .red : .white)
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
