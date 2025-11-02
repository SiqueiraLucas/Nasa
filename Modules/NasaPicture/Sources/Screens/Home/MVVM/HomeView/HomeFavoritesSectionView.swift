import SwiftUI

struct HomeFavoritesSectionView: View {
    let data: HomeData.PictureList
    let horizontalPadding: CGFloat
    var touchFavoriteButton: (_ picture: HomeData.Picture) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(data.headerTitle)
                    .font(.title2.weight(.semibold))
                
                Spacer()
                
                Button(action: {
                    print("Ver todos pressionado")
                }) {
                    Text(data.buttonTitle ?? "")
                        .font(.footnote.bold())
                }
            }
            .padding(.horizontal, horizontalPadding)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(data.pictures.enumerated()), id: \.offset) { index, item in
                        ZStack(alignment: .topTrailing) {
                            URLImage(url: item.imageUrl, cornerRadius: 0)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 160, height: 160)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            
                            Button(action: {
                                touchFavoriteButton(item)
                            }) {
                                Image(systemName: item.favorite ? "heart.fill" : "heart")
                                    .foregroundColor(item.favorite ? .red : .white)
                                    .padding(6)
                                    .background(Color.black.opacity(0.3))
                                    .clipShape(Circle())
                                    .padding(6)
                            }
                            
                            VStack {
                                Spacer()
                                HStack {
                                    Text(item.date)
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .padding(6)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .padding(6)
                                    Spacer()
                                }
                            }
                        }
                        .frame(width: 160, height: 160)
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
            headerTitle: "Favoritos",
            buttonTitle: "Ver todos",
            pictures: (1...6).map { _ in
                HomeData.Picture(
                    date: "2025-01-01",
                    title: "Title",
                    description: "Description",
                    imageUrl: URL(string: "https://picsum.photos/seed/\(UUID().uuidString)/400/300")!,
                    favorite: false
                )
            }
        ),
        horizontalPadding: 24,
        touchFavoriteButton: { picture in
            print(picture)
        }
    )
}
