import SwiftUI

struct HomeGridSectionView: View {
    let data: HomeData.PictureList
    let horizontalPadding: CGFloat
    
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
                ForEach(data.pictures, id: \.imageUrl) { item in
                    let imageWidth = (UIScreen.main.bounds.width - (horizontalPadding * 2) - 12) / 2

                    URLImage(url: item.imageUrl, cornerRadius: 0)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imageWidth, height: imageHeight)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
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
