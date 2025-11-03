import Foundation
import SwiftUI
import Combine
import NasaNetworkInterface

final class HomeViewModel: ObservableObject {
    @Published var model = HomeModel()
    
    private let dataProvider: HomeDataProviderProtocol
    private let coordinator: HomeCoordinatorProtocol
    
    private var lastRequestedDate: String?
    
    init(
        dataProvider: HomeDataProviderProtocol,
        coordinator: HomeCoordinatorProtocol
    ) {
        self.dataProvider = dataProvider
        self.coordinator  = coordinator
    }
    
    func build() {
        let currentDate = model.header.date
        let startDate = getDateAgo(from: currentDate, days: 10)
        lastRequestedDate = currentDate
        model.state = .loading
        dataProvider.fetchPictures(startDate: startDate, endDate: currentDate)
            .done { [weak self] response in
                self?.handleFetchPicturesSuccess(with: response, date: currentDate)
            }.catch { [weak self] error in
                let networkError = error as? NetworkError ?? .init(type: .unknown)
                self?.handleFetchError(with: networkError, date: currentDate)
            }
    }
    
    private func getDateAgo(from currentDate: String, days: Int) -> String {
        if let newDate = Calendar.current.date(byAdding: .day, value: -days, to: currentDate.toDate()) {
            return newDate.toString()
        } else {
            return currentDate
        }
    }
    
    private func handleFetchPicturesSuccess(with responses: [Home.Response], date: String) {
        guard lastRequestedDate == date else { return }
        
        let favorites = dataProvider.fetchFavorites()
        let favoriteDates: Set<String> = Set(favorites.map { $0.date })

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
                picture: HomeData.Picture(
                    date: mainResponse.date,
                    title: mainResponse.title,
                    description: mainResponse.explanation,
                    imageUrl: mainResponse.imageURL ?? URL(string: "https://picsum.photos/300/200")!,
                    favorite: favoriteDates.contains(mainResponse.date)
                )
            ),
            favorites: getFavoritesData(from: favorites),
            gridPicture: HomeData.PictureList(
                headerTitle: "Outras fotos",
                buttonTitle: nil,
                pictures: otherResponses.map {
                    HomeData.Picture(
                        date: $0.date,
                        title: $0.title,
                        description: $0.explanation,
                        imageUrl: $0.imageURL ?? URL(string: "https://picsum.photos/300/200")!,
                        favorite: favoriteDates.contains($0.date)
                    )
                }
            )
        )

        model.state = .success(data)
    }
    
    private func getFavoritesData(from favorites: [Home.Response]) -> HomeData.PictureList? {
        if favorites.isEmpty {
            return nil
        }
        
        return HomeData.PictureList(
            headerTitle: "Favoritos",
            buttonTitle: "Ver todos",
            pictures: favorites.prefix(5).map {
                HomeData.Picture(
                    date: $0.date,
                    title: $0.date,
                    description: $0.explanation,
                    imageUrl: $0.imageURL ?? URL(string: "https://picsum.photos/300/200")!,
                    favorite: true
                )
            }
        )
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
    
    func loadMore(date: String) {
        let currentDate = getDateAgo(from: date, days: 1)
        let startDate = getDateAgo(from: currentDate, days: 9)
        lastRequestedDate = currentDate
        dataProvider.fetchPictures(startDate: startDate, endDate: currentDate)
            .done { [weak self] response in
                self?.handleFetchMorePicturesSuccess(with: response, date: currentDate)
            }.catch { _ in }
    }
    
    private func handleFetchMorePicturesSuccess(with responses: [Home.Response], date: String) {
        guard lastRequestedDate == date else { return }
        
        let favorites = dataProvider.fetchFavorites()
        let favoriteDates: Set<String> = Set(favorites.map { $0.date })
        
        let responsesSorted = responses
            .sorted { lhs, rhs in
                return lhs.date.toDate() > rhs.date.toDate()
            }

        let newPictures = responsesSorted.map {
            HomeData.Picture(
                date: $0.date,
                title: $0.title,
                description: $0.explanation,
                imageUrl: $0.imageURL ?? URL(string: "https://picsum.photos/300/200")!,
                favorite: favoriteDates.contains($0.date)
            )
        }

        if case .success(var currentData) = model.state {
            currentData.gridPicture.pictures.append(contentsOf: newPictures)
            model.state = .success(currentData)
        }
    }
    
    func didTouchFavoriteButton(picture: HomeData.Picture) {
        guard case .success(var currentData) = model.state else { return }

        var updatedMain = currentData.mainPicture
        var updatedGrid = currentData.gridPicture

        if picture.favorite {
            dataProvider.deleteFavorite(date: picture.date)
        } else {
            dataProvider.saveFavorite(response: Home.Response(
                title: picture.title,
                explanation: picture.description,
                date: picture.date,
                imageURL: picture.imageUrl
            ))
        }

        if updatedMain.picture.date == picture.date {
            updatedMain.picture.favorite.toggle()
        }

        if let index = updatedGrid.pictures.firstIndex(where: { $0.date == picture.date }) {
            updatedGrid.pictures[index].favorite.toggle()
        }

        let favorites = dataProvider.fetchFavorites()
        let newFavoritesList = getFavoritesData(from: favorites)

        currentData = HomeData(
            mainPicture: updatedMain,
            favorites: newFavoritesList,
            gridPicture: updatedGrid
        )

        model.state = .success(currentData)
    }
    
    func didTouchPicture(picture: HomeData.Picture) {
        coordinator.navigateToPictureDetail(picture: picture)
    }
}
