import SwiftUI

struct HomeGridSectionView: View {
    let data: HomeData.PictureList
    let horizontalPadding: CGFloat
    var onLoadMore: (_ date: String) -> Void
    var touchFavoriteButton: (_ picture: HomeData.Picture) -> Void
    
    private let imageHeight: CGFloat = 160
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(data.headerTitle)
                .font(.title2.weight(.semibold))
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 8)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(Array(data.pictures.enumerated()), id: \.offset) { index, item in
                    let imageWidth = (UIScreen.main.bounds.width - (horizontalPadding * 2) - 12) / 2
                    
                    ZStack(alignment: .topTrailing) {
                        URLImage(url: item.imageUrl, cornerRadius: 0)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageWidth, height: imageHeight)
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
                    .onAppear {
                        if index == data.pictures.count - 1 {
                            onLoadMore(item.date)
                        }
                    }

                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.bottom, 24)
        }
    }
}


#Preview {
    HomeGridSectionView(
        data: HomeData.PictureList(
            headerTitle: "Outras fotos",
            buttonTitle: nil,
            pictures: (1...6).map { _ in
                HomeData.Picture(
                    date: "01/01/2025",
                    title: "Title",
                    description: "Description",
                    imageUrl: URL(string: "https://picsum.photos/seed/\(UUID().uuidString)/400/300")!,
                    favorite: false
                )
            }
        ),
        horizontalPadding: 24,
        onLoadMore: { date in
            print(date)
        },
        touchFavoriteButton: { picture in
            print(picture)
        }
    )
}
