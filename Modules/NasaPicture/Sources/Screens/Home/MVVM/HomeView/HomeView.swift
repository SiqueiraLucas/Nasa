import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private let horizontalPadding: CGFloat = 24
    
    var body: some View {
        ZStack {
            switch viewModel.model.state {
            case .loading:
                LoadingView()
            case .error(let data):
                ErrorView(data: data)
            case .success(let data):
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HomeHeaderView(title: data.title, date: data.date, horizontalPadding: 24)
                        Divider().background(Color.gray).padding(.horizontal, 24)
                        HomeMainPictureView(horizontalPadding: 24)
                        HomeFavoritesSectionView(horizontalPadding: 24)
                        HomeGridSectionView(horizontalPadding: 24)
                    }
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
        func fetch() -> Promise<Home.Response> {
            return Promise.value(Home.Response(
                title: "Mock Title",
                date: "Mock Date",
                imageURL: URL(string: "https://via.placeholder.com/150")!
            ))
        }
    }
    
    static var previews: some View {
        let dataProvider = HomeDataProviderPreview()
        var viewModel = HomeViewModel(dataProvider: dataProvider)
        HomeView(viewModel: viewModel)
    }
}
#endif
