import SwiftUI

struct FavoriteButtonView: View {
    let favorite: Bool
    var action: () -> Void

    var body: some View {
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
