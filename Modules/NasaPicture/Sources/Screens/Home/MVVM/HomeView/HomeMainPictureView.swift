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
            
            ZStack {
                URLImage(url: data.imageUrl, cornerRadius: 12)
                    .aspectRatio(16/9, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(data.title)
                            .font(.footnote.bold())
                            .foregroundColor(.white)
                            .lineLimit(2)
                        
                        Text(data.description)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                            .lineLimit(2)
                    }
                    .padding(16)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            print("Favoritar: \(data.title)")
                        }) {
                            Image(systemName: "heart")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                        .padding(8)
                    }
                    Spacer()
                }
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
