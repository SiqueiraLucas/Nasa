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
        let startDate = getStartDate(from: currentDate)
        lastRequestedDate = currentDate
        model.state = .loading
        dataProvider.fetchPictures(startDate: startDate, endDate: currentDate)
            .done { [weak self] response in
                self?.handleFetchPictureDaySuccess(with: response, date: currentDate)
            }.catch { [weak self] error in
                let networkError = error as? NetworkError ?? .init(type: .unknown)
                self?.handleFetchError(with: networkError, date: currentDate)
            }
    }
    
    private func getStartDate(from currentDate: String) -> String {
        if let tenDaysAgo = Calendar.current.date(byAdding: .day, value: -10, to: currentDate.toDate()) {
            let startDate = tenDaysAgo.toString()
            return startDate
        } else {
            return currentDate
        }
    }
    
    private func handleFetchPictureDaySuccess(with responses: [Home.Response], date: String) {
        guard lastRequestedDate == date else { return }

        guard let mainResponse = responses.first(where: { $0.date == date }) else {
            return
        }

        let otherResponses = responses
            .filter { $0.date != date }
            .sorted { lhs, rhs in
                return lhs.date.toDate() > rhs.date.toDate()
            }

        let data = HomeData(
            mainPicture: HomeData.MainPicture(
                headerTitle: "Foto do dia",
                title: mainResponse.title,
                description: mainResponse.explanation,
                imageUrl: mainResponse.imageURL ?? URL(string: "https://picsum.photos/300/200")!
            ),
            favorites: nil,
            gridPicture: HomeData.PictureList(
                headerTitle: "Outras fotos",
                pictures: otherResponses.map {
                    HomeData.PictureList.Picture(
                        title: $0.title,
                        description: $0.explanation,
                        imageUrl: $0.imageURL ?? URL(string: "https://picsum.photos/300/200")!
                    )
                }
            )
        )

        model.state = .success(data)
    }

    
    private func handleFetchError(with error: NetworkError, date: String) {
        guard lastRequestedDate == date else {
            return
        }
        
        let errorDisplayInfo = error.displayInfo
        
        model.state = .error(data: ErrorData(
            title: errorDisplayInfo.title,
            description: errorDisplayInfo.description,
            buttonTitle: errorDisplayInfo.buttonTitle,
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
