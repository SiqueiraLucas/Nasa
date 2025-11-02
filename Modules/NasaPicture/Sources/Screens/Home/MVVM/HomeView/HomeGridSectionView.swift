import SwiftUI

struct HomeGridSectionView: View {
    let data: HomeData.PictureList
    let horizontalPadding: CGFloat
    var onLoadMore: (_ date: String) -> Void
    
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
                    
                    ZStack(alignment: .bottomLeading) {
                        URLImage(url: item.imageUrl, cornerRadius: 0)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageWidth, height: imageHeight)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        
                        Text(item.date)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.black.opacity(0.6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(6)
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
            pictures: (1...6).map { _ in
                HomeData.PictureList.Picture(
                    date: "01/01/2025",
                    title: "Title",
                    description: "Description",
                    imageUrl: URL(string: "https://picsum.photos/seed/\(UUID().uuidString)/400/300")!
                )
            }
        ),
        horizontalPadding: 24, onLoadMore: { date in
            print("date")
        }
    )
}
