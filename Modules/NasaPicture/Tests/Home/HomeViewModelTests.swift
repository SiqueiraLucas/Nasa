import XCTest
import SwiftUI
import Combine
import PromiseKit
import NasaNetworkInterface
@testable import NasaPicture

final class HomeViewModelTests: XCTestCase {
    private var viewModel: HomeViewModel!
    private var dataProvider: HomeDataProviderSpy!
    private var coordinator: HomeCoordinatorSpy!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        dataProvider = HomeDataProviderSpy()
        coordinator = HomeCoordinatorSpy()
        viewModel = HomeViewModel(
            dataProvider: dataProvider,
            coordinator: coordinator
        )
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        dataProvider = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_build_callsFetchPictures() {
        // Given
        let pictures = [
            Home.Response(title: "Title1", explanation: "Exp1", date: "2025-10-01", imageURL: nil),
            Home.Response(title: "Title2", explanation: "Exp2", date: "2025-09-29", imageURL: nil)
        ]
        dataProvider.picturesResponse = pictures
        
        // When
        viewModel.build()
        
        // Then
        XCTAssertTrue(dataProvider.fetchPicturesCalled)
        if XCTWaiter.wait(for: [XCTestExpectation()], timeout: 1) == XCTWaiter.Result.timedOut {
            guard case .success(_) = viewModel.model.state else {
                XCTFail("Expected success state"); return
            }
        }
    }
    
    func test_build_handlesError() {
        // Given
        dataProvider.picturesResponse = nil
        
        let expectation = expectation(description: "State changes to error")
        
        viewModel.$model
            .dropFirst()
            .sink { model in
                if case .error(let data) = model.state {
                    XCTAssertEqual((data as? ErrorData)?.title, NetworkError(type: .internalError).displayInfo.title)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.build()
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(dataProvider.fetchPicturesCalled)
    }
    
    func test_didTouchFavoriteButton_addsFavorite() {
        // Given
        dataProvider.picturesResponse = [
            Home.Response(title: "Title1", explanation: "Exp1", date: "2025-10-01", imageURL: nil),
            Home.Response(title: "Title2", explanation: "Exp2", date: "2025-09-29", imageURL: nil)
        ]
        viewModel.build()
        
        // Wait for build to finish
        let buildExpectation = expectation(description: "Build finished")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { buildExpectation.fulfill() }
        wait(for: [buildExpectation], timeout: 1)
        
        guard case .success(let data) = viewModel.model.state else {
            XCTFail("Expected success state"); return
        }
        
        let picture = data.mainPicture.picture
        XCTAssertFalse(picture.favorite)
        
        // When
        viewModel.didTouchFavoriteButton(picture: picture)
        
        // Then
        XCTAssertTrue(dataProvider.saveFavoriteCalled)
        guard case .success(let updatedData) = viewModel.model.state else {
            XCTFail("Expected success state after favorite"); return
        }
        XCTAssertTrue(updatedData.mainPicture.picture.favorite)
    }
    
    func test_didTouchFavoriteButton_removesFavorite() {
        // Given
        dataProvider.picturesResponse = [
            Home.Response(title: "Title1", explanation: "Exp1", date: "2025-10-01", imageURL: nil),
            Home.Response(title: "Title2", explanation: "Exp2", date: "2025-09-29", imageURL: nil)
        ]
        dataProvider.favoritesResponse = [
            Home.Response(title: "Title1", explanation: "Exp1", date: "2025-10-01", imageURL: nil)
        ]
        viewModel.build()
        
        let buildExpectation = expectation(description: "Build finished")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { buildExpectation.fulfill() }
        wait(for: [buildExpectation], timeout: 1)
        
        guard case .success(let data) = viewModel.model.state else {
            XCTFail("Expected success state"); return
        }
        
        let picture = data.mainPicture.picture
        XCTAssertTrue(picture.favorite)
        
        // When
        viewModel.didTouchFavoriteButton(picture: picture)
        
        // Then
        XCTAssertTrue(dataProvider.deleteFavoriteCalled)
        guard case .success(let updatedData) = viewModel.model.state else {
            XCTFail("Expected success state after delete favorite"); return
        }
        XCTAssertFalse(updatedData.mainPicture.picture.favorite)
    }
    
    func test_didTouchPicture() {
        // Given
        let picture = HomeData.Picture(date: "", title: "", description: "", imageUrl: URL(string: "https://example.com")!, favorite: false)
        
        // When
        viewModel.didTouchPicture(picture: picture)
        
        // Then
        XCTAssertTrue(coordinator.navigateToPictureDetailCalled)
    }
    
    func test_didTouchAllFavorite() {
        // When
        viewModel.didTouchAllFavorite()
        
        // Then
        XCTAssertTrue(coordinator.navigateToAllFavoriteCalled)
    }
    
    func test_loadMore_appendsNewPicturesToGrid() {
        // Given
        let initialResponses = [
            Home.Response(title: "Title1", explanation: "Exp1", date: "2025-10-01", imageURL: nil),
            Home.Response(title: "Title2", explanation: "Exp2", date: "2025-09-30", imageURL: nil)
        ]
        dataProvider.picturesResponse = initialResponses
        
        // Inicializa o estado com duas fotos
        viewModel.build()
        
        let buildExpectation = expectation(description: "Build finished")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { buildExpectation.fulfill() }
        wait(for: [buildExpectation], timeout: 1)
        
        guard case .success(let initialData) = viewModel.model.state else {
            XCTFail("Expected success state"); return
        }
        XCTAssertEqual(initialData.gridPicture.pictures.count, 1)
        
        // When
        let newResponses = [
            Home.Response(title: "Title3", explanation: "Exp3", date: "2025-09-29", imageURL: nil),
            Home.Response(title: "Title4", explanation: "Exp4", date: "2025-09-28", imageURL: nil)
        ]
        dataProvider.picturesResponse = newResponses
        
        viewModel.loadMore(date: "2025-09-30")
        
        // Then
        let loadMoreExpectation = expectation(description: "Load more finished")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { loadMoreExpectation.fulfill() }
        wait(for: [loadMoreExpectation], timeout: 1)
        
        guard case .success(let updatedData) = viewModel.model.state else {
            XCTFail("Expected success state after loadMore"); return
        }
        
        XCTAssertTrue(dataProvider.fetchPicturesCalled)
        XCTAssertEqual(updatedData.gridPicture.pictures.count, 3) // 1 anterior + 2 novos
        XCTAssertEqual(updatedData.gridPicture.pictures.last?.title, "Title4")
    }
        
    func test_loadMore_doesNotAppendIfPromiseFails() {
        // Given
        let initialResponses = [
            Home.Response(title: "Title1", explanation: "Exp1", date: "2025-10-01", imageURL: nil)
        ]
        dataProvider.picturesResponse = initialResponses
        
        viewModel.build()
        let buildExpectation = expectation(description: "Build finished")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { buildExpectation.fulfill() }
        wait(for: [buildExpectation], timeout: 1)
        
        guard case .success(let initialData) = viewModel.model.state else {
            XCTFail("Expected success state"); return
        }
        XCTAssertEqual(initialData.gridPicture.pictures.count, 0)
        
        // When — simula erro na chamada
        dataProvider.shouldFailFetch = true
        
        viewModel.loadMore(date: "2025-09-30")
        
        // Then
        let loadMoreExpectation = expectation(description: "Load more finished")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { loadMoreExpectation.fulfill() }
        wait(for: [loadMoreExpectation], timeout: 1)
        
        guard case .success(let updatedData) = viewModel.model.state else {
            XCTFail("Expected success state to remain"); return
        }
        
        XCTAssertEqual(updatedData.gridPicture.pictures.count, 0)
    }
    
    func test_newDateSelected_callsBuildWhenDateChanges() {
        // Given
        dataProvider.picturesResponse = [
            Home.Response(title: "Title1", explanation: "Exp1", date: "2025-10-01", imageURL: nil)
        ]
        viewModel.model.header.date = "2025-10-01"
        
        // Spy para saber se build foi chamado (via fetchPictures)
        XCTAssertFalse(dataProvider.fetchPicturesCalled)
        
        // When
        viewModel.newDateSelected("2025-10-02")
        
        // Then
        XCTAssertTrue(dataProvider.fetchPicturesCalled)
        XCTAssertEqual(viewModel.model.header.date, "2025-10-02")
    }
    
    func test_newDateSelected_doesNotCallBuildWhenDateIsSame() {
        // Given
        viewModel.model.header.date = "2025-10-01"
        
        // When
        viewModel.newDateSelected("2025-10-01")
        
        // Then
        XCTAssertFalse(dataProvider.fetchPicturesCalled)
        XCTAssertEqual(viewModel.model.header.date, "2025-10-01")
    }
}
