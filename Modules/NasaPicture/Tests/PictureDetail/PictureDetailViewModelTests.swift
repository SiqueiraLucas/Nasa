import XCTest
import Combine
@testable import NasaPicture
@testable import NasaNetworkInterface

final class PictureDetailViewModelTests: XCTestCase {
    private var viewModel: PictureDetailViewModel!
    private var dataProvider: PictureDetailDataProviderSpy!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        dataProvider = PictureDetailDataProviderSpy()
        let picture = HomeData.Picture(
            date: "2025-11-03",
            title: "Test Picture",
            description: "Test Description",
            imageUrl: URL(string: "https://example.com")!,
            favorite: false
        )
        viewModel = PictureDetailViewModel(
            dataProvider: dataProvider,
            picture: picture
        )
    }
    
    override func tearDown() {
        viewModel = nil
        dataProvider = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testFavoriteButton_WhenNotFavorite_ShouldCallSaveFavoriteAndToggleFavorite() {
        // Given
        let picture = viewModel.model.picture
        XCTAssertFalse(picture.favorite)
        
        // When
        viewModel.didTouchFavoriteButton(picture: picture)
        
        // Then
        XCTAssertTrue(dataProvider.saveFavoriteCalled, "Save favorite should be called")
        XCTAssertFalse(dataProvider.deleteFavoriteCalled, "Delete favorite should not be called")
        XCTAssertTrue(viewModel.model.picture.favorite, "Picture favorite should be toggled to true")
    }
    
    func testFavoriteButton_WhenAlreadyFavorite_ShouldCallDeleteFavoriteAndToggleFavorite() {
        // Given
        var picture = viewModel.model.picture
        picture.favorite = true
        
        // When
        viewModel.didTouchFavoriteButton(picture: picture)
        
        // Then
        XCTAssertTrue(dataProvider.deleteFavoriteCalled, "Delete favorite should be called")
        XCTAssertFalse(dataProvider.saveFavoriteCalled, "Save favorite should not be called")
    }
    
    func testPublishedModel_ShouldUpdateFavoriteStatus() {
        // Given
        let expectation = XCTestExpectation(description: "Model favorite status should update")
        var receivedValues: [Bool] = []
        
        viewModel.$model
            .sink { model in
                receivedValues.append(model.picture.favorite)
                if receivedValues.count == 2 { // initial + after toggle
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        let picture = viewModel.model.picture
        viewModel.didTouchFavoriteButton(picture: picture)
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertEqual(receivedValues, [false, true], "Published model should reflect favorite toggle")
    }
}
