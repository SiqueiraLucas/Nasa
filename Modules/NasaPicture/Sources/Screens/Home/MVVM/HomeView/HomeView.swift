import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var showDatePicker = false
    
    private let horizontalPadding: CGFloat = 24
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            mainContent()
            
            if showDatePicker {
                datePickerView()
            }
        }
        .background(Color(.systemBackground))
        .onAppear {
            viewModel.build()
        }
    }
    
    private func mainContent() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            headerView()
            
            Divider().background(Color.gray)
                .padding(.horizontal, horizontalPadding)
            
            contentView()
        }
    }
    
    private func headerView() -> some View {
        HomeHeaderView(header: viewModel.model.header, horizontalPadding: horizontalPadding) {
            showDatePicker = true
        }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        switch viewModel.model.state {
        case .loading:
            LoadingView()
        case .error(let data):
            ErrorView(data: data)
        case .success(let data):
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    mainPictureView(data.mainPicture)
                    
                    if let favorites = data.favorites {
                        favoritesSectionView(favorites)
                    }
                    
                    gridSectionView(data.gridPicture)
                }
            }
        }
    }
    
    private func mainPictureView(_ data: HomeData.MainPicture) -> some View {
        HomeMainPictureView(
            data: data,
            horizontalPadding: horizontalPadding,
            touchFavoriteButton: { picture in
                viewModel.didTouchFavoriteButton(picture: picture)
            }
        )
    }
    
    private func favoritesSectionView(_ data: HomeData.PictureList) -> some View {
        HomeFavoritesSectionView(
            data: data,
            horizontalPadding: horizontalPadding,
            touchFavoriteButton: { picture in
                viewModel.didTouchFavoriteButton(picture: picture)
            }
        )
    }
    
    private func gridSectionView(_ data: HomeData.PictureList) -> some View {
        HomeGridSectionView(
            data: data,
            horizontalPadding: horizontalPadding,
            onLoadMore: { date in
                viewModel.loadMore(date: date)
            },
            touchFavoriteButton: { picture in
                viewModel.didTouchFavoriteButton(picture: picture)
            }
        )
    }
    
    private func datePickerView() -> some View {
        DatePickerDialog(
            minimumDate: viewModel.model.datePicker.minimumDate,
            maximumDate: viewModel.model.datePicker.maximumDate,
            currentDate: viewModel.model.header.date.toDate(),
            isPresented: $showDatePicker
        ) { newDate in
            viewModel.newDateSelected(newDate.toString())
        }
    }
}


#if DEBUG
import SwiftUI
import NasaNetworkInterface
import PromiseKit

struct HomeView_Previews: PreviewProvider {
    class HomeDataProviderPreview: HomeDataProviderProtocol {
        let mockResponse = Home.Response(
            title: "Mock Title",
            explanation: "Mocke Explanation",
            date: "Mock Date",
            imageURL: URL(string: "https://fastly.picsum.photos/id/10/2500/1667.jpg?hmac=J04WWC_ebchx3WwzbM-Z4_KC_LeLBWr5LZMaAkWkF68")!
        )
        
        func fetchPictures(startDate: String, endDate: String) -> PromiseKit.Promise<[Home.Response]> {
            return Promise.value(Array(repeating: mockResponse, count: 10))
        }
        
        func fetchPictureDay(date: String) -> Promise<Home.Response> {
            return Promise.value(mockResponse)
        }
        
        func fetchFavorites() -> [Home.Response] { return [] }
        func saveFavorite(response: Home.Response) {}
        func deleteFavorite(date: String) {}
    }
    
    static var previews: some View {
        let dataProvider = HomeDataProviderPreview()
        let viewModel = HomeViewModel(dataProvider: dataProvider)
        HomeView(viewModel: viewModel)
    }
}
#endif
