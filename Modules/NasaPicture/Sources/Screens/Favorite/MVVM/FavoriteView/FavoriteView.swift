import SwiftUI

struct FavoriteView: View {
    @StateObject var viewModel: FavoriteViewModel
    @State private var showDatePicker = false
    
    private let horizontalPadding: CGFloat = 24
    private let cardSpacing: CGFloat = 16
    private let cardHeight: CGFloat = 200
    
    init(viewModel: FavoriteViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            headerView()
            picturesScrollView()
        }
        .navigationBarHidden(false)
        .onAppear {
            viewModel.build()
        }
    }
    
    // MARK: - Header
    private func headerView() -> some View {
        HStack {
            Text("Favoritos")
                .font(.title.weight(.bold))
            
            Spacer()
        }
        .padding(.horizontal, horizontalPadding)
    }
    
    // MARK: - ScrollView
    private func picturesScrollView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: cardSpacing) {
                ForEach(viewModel.model.pictures, id: \.date) { picture in
                    pictureCardView(picture)
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, 8)
        }
    }
    
    // MARK: - Picture Card
    private func pictureCardView(_ picture: HomeData.Picture) -> some View {
        ZStack(alignment: .topTrailing) {
            URLImage(url: picture.imageUrl, cornerRadius: 12)
                .onCustomTap {
                    viewModel.didTouchPicture(picture)
                }
                .aspectRatio(contentMode: .fill)
                .frame(height: cardHeight)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(radius: 4, y: 2)
                .contentShape(RoundedRectangle(cornerRadius: 12))
            
            FavoriteButtonView(
                favorite: picture.favorite,
                action: {
                    viewModel.didTouchFavoriteButton(picture: picture)
                }
            )
            .padding(8)
            
            VStack {
                Spacer()
                HStack {
                    Text(picture.date)
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.black.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding([.leading, .bottom], 8)
                    Spacer()
                }
            }
        }
    }
}

#if DEBUG
import SwiftUI
import NasaNetworkInterface
import PromiseKit

struct FavoriteView_Previews: PreviewProvider {
    class FavoriteDataProviderPreview: FavoriteDataProviderProtocol {
        func fetchFavorites() -> [Home.Response] {
            return (1...6).map { _ in
                Home.Response(
                    title: "Mock Title",
                    explanation: "Mocke Explanation",
                    date: "Mock Date",
                    imageURL: URL(string: "https://fastly.picsum.photos/id/10/2500/1667.jpg?hmac=J04WWC_ebchx3WwzbM-Z4_KC_LeLBWr5LZMaAkWkF68")!
                )
            }
        }
        
        func saveFavorite(response: Home.Response) {}
        func deleteFavorite(date: String) {}
    }
    
    class FavoriteCoordinatorPreview: FavoriteCoordinatorProtocol {
        func navigateToPictureDetail(picture: HomeData.Picture) {}
    }
    
    static var previews: some View {
        let dataProvider = FavoriteDataProviderPreview()
        let coordinator = FavoriteCoordinatorPreview()
        let viewModel = FavoriteViewModel(
            dataProvider: dataProvider,
            coordinator: coordinator
        )
        FavoriteView(viewModel: viewModel)
    }
}
#endif
