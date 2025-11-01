import Foundation
import SwiftUI
import Combine
import NasaNetworkInterface

protocol HomeViewModelProtocol where Self: ObservableObject {
    var model: HomeModel { get set }
    func build()
}

final class HomeViewModel: HomeViewModelProtocol {
    @Published var model = HomeModel()
    
    private let dataProvider: HomeDataProviderProtocol
    
    init(dataProvider: HomeDataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func build() {
        model.state = .loading
        dataProvider.fetch()
            .done { [weak self] response in
                self?.handleFetchSuccess(with: response)
            }.catch { [weak self] error in
                let networkError = error as? NetworkError ?? .init(type: .unknown)
                self?.handleFetchError(with: networkError)
            }
    }
    
    private func handleFetchSuccess(with response: Home.Response) {
        let data = HomeData(
            title: response.title,
            date: response.date,
            mainPhotoUrl: response.imageURL
        )
        
        model.state = .success(data)
    }
    
    private func handleFetchError(with error: NetworkError) {
        model.state = .error(data: ErrorData(
            title: "Erro inesperado",
            description: error.localizedDescription,
            buttonTitle: "Tentar novamente",
            buttonAction: { [weak self] in
                self?.build()
            }))
    }
}
