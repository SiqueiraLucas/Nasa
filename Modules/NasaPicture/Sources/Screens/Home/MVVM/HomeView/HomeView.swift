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
                HomeHeaderView(title: viewModel.model.title, date: viewModel.model.date, horizontalPadding: horizontalPadding) {
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
                                HomeFavoritesSectionView(horizontalPadding: horizontalPadding)
                                HomeGridSectionView(horizontalPadding: horizontalPadding)
                            }
                        }
                    }
                }
            }
            
            if showDatePicker {
                DatePickerDialog(
                    minimumDate: Calendar.current.date(byAdding: .year, value: -1, to: Date())!,
                    maximumDate: Date(),
                    currentDate: viewModel.model.date.toDate(),
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
    }
    
    static var previews: some View {
        let dataProvider = HomeDataProviderPreview()
        var viewModel = HomeViewModel(dataProvider: dataProvider, date: "01/01/2025")
        HomeView(viewModel: viewModel)
    }
}
#endif
