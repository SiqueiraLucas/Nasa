import SwiftUI

struct HomeFavoritesSectionView: View {
    let data: HomeData.PictureList
    let horizontalPadding: CGFloat
    private let favoriteCount = 5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Text("Favoritos")
                    .font(.title2.weight(.semibold))
                
                Spacer()
                
                Button(action: {
                    print("Ver todos pressionado")
                }) {
                    Text("Ver todos")
                        .font(.footnote.bold())
                }
            }
            .padding(.horizontal, horizontalPadding)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<favoriteCount, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 120, height: 120)
                    }
                }
                .padding(.horizontal, horizontalPadding)
            }
        }
        .padding(.top, 16)
    }
}

#Preview {
    HomeFavoritesSectionView(
        data: HomeData.PictureList(
            headerTitle: "Outras fotos",
            pictures: (1...6).map { _ in
                HomeData.PictureList.Picture(
                    title: "Title",
                    description: "Description",
                    imageUrl: URL(string: "https://picsum.photos/seed/\(UUID().uuidString)/400/300")!
                )
            }
        ),
        horizontalPadding: 24
    )
}
