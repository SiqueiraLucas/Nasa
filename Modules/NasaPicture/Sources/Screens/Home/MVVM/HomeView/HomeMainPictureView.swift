import SwiftUI

struct HomeMainPictureView: View {
    let data: HomeData.MainPicture
    let horizontalPadding: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(data.headerTitle)
                .font(.title.weight(.semibold))
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 8)
            
            ZStack(alignment: .bottomLeading) {
                URLImage(url: data.imageUrl, cornerRadius: 12)
                    .aspectRatio(16/9, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(data.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    Text(data.description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                }
                .frame(height: 100, alignment: .bottom)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .padding(.horizontal, horizontalPadding)
        }
    }
}

#Preview {
    HomeMainPictureView(
        data: HomeData.MainPicture(
            headerTitle: "Header title",
            title: "Title",
            description: "Description",
            imageUrl: URL(string: "https://fastly.picsum.photos/id/10/2500/1667.jpg?hmac=J04WWC_ebchx3WwzbM-Z4_KC_LeLBWr5LZMaAkWkF68")!),
        horizontalPadding: 24
    )
}
