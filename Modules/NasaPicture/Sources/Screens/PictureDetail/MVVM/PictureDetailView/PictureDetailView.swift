import SwiftUI

struct PictureDetailView: View {
    @StateObject var viewModel: PictureDetailViewModel
    @State private var showDatePicker = false
    
    private let horizontalPadding: CGFloat = 24
    
    init(viewModel: PictureDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            mainContent()
        }
        .background(Color(.systemBackground))
        .navigationBarHidden(false)
    }
    
    private func mainContent() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.model.picture.title)
                .font(.title.weight(.semibold))
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 8)
            
            Divider().background(Color.gray)
                .padding(.horizontal, horizontalPadding)
            
            contentView()
        }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                pictureView(viewModel.model.picture)
                
                infoView(viewModel.model.picture)
            }
        }
    }
    
    private func pictureView(_ picture: PictureDetailModel.Picture) -> some View {
        ZStack {
            URLImage(url: picture.imageUrl, cornerRadius: 12)
                .onFullScreenTap(true)
                .aspectRatio(16/9, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack {
                HStack {
                    Spacer()
                    FavoriteButtonView(
                        favorite: picture.favorite,
                        action: {
                            viewModel.didTouchFavoriteButton(picture: picture)
                        }
                    )
                    .padding(8)
                }
                Spacer()
            }
        }
        .padding(.horizontal, horizontalPadding)
    }
    
    private func infoView(_ picture: PictureDetailModel.Picture) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(picture.date)
                .font(.subheadline.weight(.semibold))
            
            Text(picture.description)
                .font(.caption)
        }
        .padding(horizontalPadding)
    }
}


#if DEBUG
import SwiftUI
import NasaNetworkInterface
import PromiseKit

struct PictureDetailView_Previews: PreviewProvider {
    class PictureDetailDataProviderPreview: PictureDetailDataProviderProtocol {
        func fetchFavorites() -> [Home.Response] { return [] }
        func saveFavorite(response: Home.Response) {}
        func deleteFavorite(date: String) {}
    }
    
    static var previews: some View {
        let dataProvider = PictureDetailDataProviderPreview()
        let viewModel = PictureDetailViewModel(
            dataProvider: dataProvider,
            picture: PictureDetailModel.Picture(
                date: "2025-01-01",
                title: "Title",
                description: "Description",
                imageUrl: URL(string: "https://picsum.photos/seed/\(UUID().uuidString)/400/300")!,
                favorite: false
            )
        )
        PictureDetailView(viewModel: viewModel)
    }
}
#endif
