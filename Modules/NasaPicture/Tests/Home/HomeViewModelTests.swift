import XCTest
import SwiftUI
import Combine
import PromiseKit
import NasaNetworkInterface
@testable import NasaPicture

final class HomeViewModelTests: XCTestCase {
    private var viewModel: HomeViewModel!
    private var dataProvider: HomeDataProviderSpy!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        dataProvider = HomeDataProviderSpy()
        viewModel = HomeViewModel(dataProvider: dataProvider)
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
}
