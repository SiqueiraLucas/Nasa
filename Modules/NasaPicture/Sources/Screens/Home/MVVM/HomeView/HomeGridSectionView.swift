import SwiftUI
import NasaUI

struct HomeGridSectionView: View {
    let data: HomeData.PictureList
    let horizontalPadding: CGFloat
    var onLoadMore: (_ date: String) -> Void
    var touchFavoriteButton: (_ picture: HomeData.Picture) -> Void
    var touchPicture: (_ picture: HomeData.Picture) -> Void
    
    private let imageHeight: CGFloat = 160
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerView
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                pictureGrid
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.bottom, 24)
        }
    }
    
    private var headerView: some View {
        Text(data.headerTitle)
            .font(.title2.weight(.semibold))
            .padding(.horizontal, horizontalPadding)
            .padding(.top, 8)
    }
    
    @ViewBuilder
    private var pictureGrid: some View {
        ForEach(Array(data.pictures.enumerated()), id: \.element.date) { index, item in
            let imageWidth = (UIScreen.main.bounds.width - (horizontalPadding * 2) - 12) / 2
            
            gridItemView(picture: item, imageWidth: imageWidth)
                .onAppear {
                    if index == data.pictures.count - 1 {
                        onLoadMore(item.date)
                    }
                }
        }
    }
    
    private func gridItemView(picture: HomeData.Picture, imageWidth: CGFloat) -> some View {
        ZStack(alignment: .topTrailing) {
            URLImage(url: picture.imageUrl, cornerRadius: 0)
                .onCustomTap {
                    touchPicture(picture)
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: imageWidth, height: imageHeight)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: 12))
            
            FavoriteButtonView(
                favorite: picture.favorite,
                action: {
                    touchFavoriteButton(picture)
                }
            )
            
            VStack {
                Spacer()
                HStack {
                    Text(picture.date)
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
    }
}

#Preview {
    HomeGridSectionView(
        data: HomeData.PictureList(
            headerTitle: "Outras fotos",
            buttonTitle: nil,
            pictures: (1...6).map { _ in
                HomeData.Picture(
                    date: "2025-01-0\(Int.random(in: 1...30))",
                    title: "Title",
                    description: "Description",
                    imageUrl: URL(string: "https://picsum.photos/seed/\(UUID().uuidString)/400/300")!,
                    favorite: false
                )
            }
        ),
        horizontalPadding: 24,
        onLoadMore: { date in
            print("Load more")
        },
        touchFavoriteButton: { picture in
            print("Touch favorite")
        },
        touchPicture: { picture in
            print("Touch picture")
        }
    )
}

