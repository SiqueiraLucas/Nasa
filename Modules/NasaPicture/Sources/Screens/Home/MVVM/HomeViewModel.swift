import Foundation
import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    @Published var model: HomeModel = .empty
    
    private let dataProvider: HomeDataProviderProtocol
    
    init(dataProvider: HomeDataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func fetch() {
//        setLoading(true)
        dataProvider.fetch()
            .done { [weak self] response in
                self?.handleFetchSuccess(with: response)
            }.ensure { [weak self] in
//                self?.setLoading(false)
            }.catch { [weak self] error in
                self?.handleFetchError(with: error)
            }
    }
    
    private func handleFetchSuccess(with response: Home.Response) {
        model = HomeModel(
            title: response.title,
            date: response.date,
            mainPhotoUrl: response.imageURL
        )
    }
    
    private func handleFetchError(with error: Error) {
//        presentError()
    }
}
