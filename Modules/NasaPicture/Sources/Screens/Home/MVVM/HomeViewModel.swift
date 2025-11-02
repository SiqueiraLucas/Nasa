import Foundation
import SwiftUI
import Combine
import NasaNetworkInterface

final class HomeViewModel: ObservableObject {
    @Published var model: HomeModel
    
    private let dataProvider: HomeDataProviderProtocol
    
    init(dataProvider: HomeDataProviderProtocol, date: String) {
        self.dataProvider = dataProvider
        self.model = HomeModel(date: date)
    }
    
    func build() {
        model.state = .loading
        dataProvider.fetchPictureDay(date: model.date)
            .done { [weak self] response in
                self?.handleFetchPictureDaySuccess(with: response)
            }.catch { [weak self] error in
                let networkError = error as? NetworkError ?? .init(type: .unknown)
                self?.handleFetchError(with: networkError)
            }
    }
    
    private func handleFetchPictureDaySuccess(with response: Home.Response) {
        let data = HomeData(
            mainPicture: HomeData.MainPicture(
                headerTitle: "Foto do dia",
                title: response.title,
                description: response.explanation,
                imageUrl: response.imageURL
            )
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
    
    func newDateSelected(_ date: String) {
        if model.date != date {
            model.date = date
            build()
        }
    }
}
