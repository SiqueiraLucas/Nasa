import XCTest
import Combine
@testable import NasaPicture
@testable import NasaNetworkInterface

final class FavoriteViewModelTests: XCTestCase {
    private var viewModel: FavoriteViewModel!
    private var dataProvider: FavoriteDataProviderSpy!
    private var coordinator: FavoriteCoordinatorSpy!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        dataProvider = FavoriteDataProviderSpy()
        coordinator = FavoriteCoordinatorSpy()
        viewModel = FavoriteViewModel(
            dataProvider: dataProvider,
            coordinator: coordinator
        )
    }
    
    override func tearDown() {
        viewModel = nil
        dataProvider = nil
        coordinator = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func test_build_shouldFetchFavoritesAndPopulateModel() {
        // Given
        let mockFavorites = [
            Home.Response(
                title: "Title 1",
                explanation: "Explanation 1",
                date: "2023-01-01",
                imageURL: URL(string: "https://example.com/1.jpg")!
            ),
            Home.Response(
                title: "Title 2",
                explanation: "Explanation 2",
                date: "2023-01-02",
                imageURL: URL(string: "https://example.com/2.jpg")!
            )
        ]
        dataProvider.favoritesToReturn = mockFavorites
        
        // When
        viewModel.build()
        
        // Then
        XCTAssertEqual(viewModel.model.pictures.count, 2)
        XCTAssertEqual(viewModel.model.pictures.first?.title, "2023-01-01")
        XCTAssertTrue(viewModel.model.pictures.first?.favorite ?? false)
        XCTAssertTrue(dataProvider.fetchFavoritesCalled)
    }
    
    func test_didTouchFavoriteButton_whenAlreadyFavorite_shouldDeleteAndReload() {
        // Given
        let picture = HomeData.Picture(
            date: "2023-01-01",
            title: "Title 1",
            description: "Description 1",
            imageUrl: URL(string: "https://example.com/1.jpg")!,
            favorite: true
        )
        
        dataProvider.favoritesToReturn = [
            Home.Response(title: "Title 1", explanation: "Description 1", date: "2023-01-01", imageURL: URL(string: "https://example.com/1.jpg"))
        ]
        
        // When
        viewModel.didTouchFavoriteButton(picture: picture)
        
        // Then
        XCTAssertTrue(dataProvider.deleteFavoriteCalled)
        XCTAssertEqual(dataProvider.deletedDate, "2023-01-01")
        XCTAssertTrue(dataProvider.fetchFavoritesCalled)
    }
    
    func test_didTouchFavoriteButton_whenNotFavorite_shouldSaveAndReload() {
        // Given
        let picture = HomeData.Picture(
            date: "2023-01-01",
            title: "Title 1",
            description: "Description 1",
            imageUrl: URL(string: "https://example.com/1.jpg")!,
            favorite: false
        )
        
        dataProvider.favoritesToReturn = [
            Home.Response(title: "Title 1", explanation: "Description 1", date: "2023-01-01", imageURL: URL(string: "https://example.com/1.jpg"))
        ]
        
        // When
        viewModel.didTouchFavoriteButton(picture: picture)
        
        // Then
        XCTAssertTrue(dataProvider.saveFavoriteCalled)
        XCTAssertEqual(dataProvider.savedResponse?.date, "2023-01-01")
        XCTAssertTrue(dataProvider.fetchFavoritesCalled)
    }
    
    func test_didTouchPicture_shouldTriggerNavigation() {
        // Given
        let picture = HomeData.Picture(
            date: "2023-01-01",
            title: "Title 1",
            description: "Description 1",
            imageUrl: URL(string: "https://example.com/1.jpg")!,
            favorite: true
        )
        
        // When
        viewModel.didTouchPicture(picture)
        
        // Then
        XCTAssertTrue(coordinator.navigateToDetailCalled)
        XCTAssertEqual(coordinator.lastPicture?.date, "2023-01-01")
    }
}
