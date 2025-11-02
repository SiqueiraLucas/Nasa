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
            VStack(alignment: .leading, spacing: 16) {
                HomeHeaderView(header: viewModel.model.header, horizontalPadding: horizontalPadding) {
                    showDatePicker = true
                }
                
                Divider().background(Color.gray).padding(.horizontal, horizontalPadding)
                
                ZStack {
                    switch viewModel.model.state {
                    case .loading:
                        LoadingView()
                    case .error(let data):
                        ErrorView(data: data)
                    case .success(let data):
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                HomeMainPictureView(data: data.mainPicture, horizontalPadding: horizontalPadding)
                                
                                if let favorites = data.favorites {
                                    HomeFavoritesSectionView(data: favorites, horizontalPadding: horizontalPadding)
                                }
                                
                                HomeGridSectionView(
                                    data: data.gridPicture,
                                    horizontalPadding: horizontalPadding,
                                    onLoadMore: { date in
                                        viewModel.loadMore(date: date)
                                    }
                                )
                            }
                        }
                    }
                }
            }
            
            if showDatePicker {
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
        .background(Color(.systemBackground))
        .onAppear {
            Task {
                await viewModel.build()
            }
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
            imageHDUrl: URL(string: "https://fastly.picsum.photos/id/10/2500/1667.jpg?hmac=J04WWC_ebchx3WwzbM-Z4_KC_LeLBWr5LZMaAkWkF68")!,
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
        func fetchFavorites() {}
    }
    
    static var previews: some View {
        let dataProvider = HomeDataProviderPreview()
        var viewModel = HomeViewModel(dataProvider: dataProvider)
        HomeView(viewModel: viewModel)
    }
}
#endif
