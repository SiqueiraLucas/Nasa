import Foundation
import SwiftUI
import Combine
import NasaNetworkInterface

final class HomeViewModel: ObservableObject {
    @Published var model = HomeModel()
    
    private let dataProvider: HomeDataProviderProtocol
    private var lastRequestedDate: String?
    
    init(dataProvider: HomeDataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func build() {
        let currentDate = model.header.date
        lastRequestedDate = currentDate
        model.state = .loading
        dataProvider.fetchPictureDay(date: currentDate)
            .done { [weak self] response in
                self?.handleFetchPictureDaySuccess(with: response, date: currentDate)
            }.catch { [weak self] error in
                let networkError = error as? NetworkError ?? .init(type: .unknown)
                self?.handleFetchError(with: networkError, date: currentDate)
            }
    }
    
    private func handleFetchPictureDaySuccess(with response: Home.Response, date: String) {
        guard lastRequestedDate == date else {
            return
        }
        
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
    
    private func handleFetchError(with error: NetworkError, date: String) {
        guard lastRequestedDate == date else {
            return
        }
        
        model.state = .error(data: ErrorData(
            title: "Erro inesperado",
            description: error.localizedDescription,
            buttonTitle: "Tentar novamente",
            buttonAction: { [weak self] in
                self?.build()
            }))
    }
    
    func newDateSelected(_ date: String) {
        if model.header.date != date {
            model.header.date = date
            build()
        }
    }
}
