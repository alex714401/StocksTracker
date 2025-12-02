import XCTest
import Combine
@testable import StocksTracker

final class StockDisplayViewModelTests: XCTestCase {
    var sut: StockDisplayViewModel!
    var mockWebSocketManager: MockWebSocketManager!
    var mockStorageManager: MockStorageManager!
    var cancellables: Set<AnyCancellable>!
    
    @MainActor
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        mockWebSocketManager = MockWebSocketManager()
        mockStorageManager = MockStorageManager()
        
        sut = StockDisplayViewModel(
            webSocketManager: mockWebSocketManager,
            storageManager: mockStorageManager
        )
    }

    @MainActor
    override func tearDown() {
        cancellables = nil
        sut = nil
        mockWebSocketManager = nil
        mockStorageManager = nil
        super.tearDown()
    }

    @MainActor
    func testFeedStateChangesPersistToStorage() {
        sut.isFeedEnabled = true
        XCTAssertTrue(mockStorageManager.isFeedEnabled)
        
        sut.isFeedEnabled = false
        XCTAssertFalse(mockStorageManager.isFeedEnabled)
    }
    
    @MainActor
    func testCompleteToggleFeedWorkflow() {
        XCTAssertFalse(sut.isFeedEnabled)
        
        sut.toggleFeed(true)
        XCTAssertTrue(sut.isFeedEnabled)
        XCTAssertTrue(mockWebSocketManager.startFeedCalled)
        XCTAssertTrue(mockStorageManager.isFeedEnabled)
        
        sut.toggleFeed(false)
        XCTAssertFalse(sut.isFeedEnabled)
        XCTAssertTrue(mockWebSocketManager.stopFeedCalled)
        XCTAssertFalse(mockStorageManager.isFeedEnabled)
    }
}

class MockStorageManager: StorageManager {
    var isFeedEnabled: Bool = false
}

class MockWebSocketManager: WebSocketManager {
    @Published var stocks: [Stock] = []
    
    var stocksPublisher: Published<[Stock]>.Publisher { $stocks }
    
    var startFeedCalled = false
    var stopFeedCalled = false
    var startFeedCallCount = 0
    var stopFeedCallCount = 0
    
    func startFeed() {
        startFeedCalled = true
        startFeedCallCount += 1
    }
    
    func stopFeed() {
        stopFeedCalled = true
        stopFeedCallCount += 1
    }
    
    func publishStocks(_ newStocks: [Stock]) {
        stocks = newStocks
    }
}

extension Stock {
    static func mock(
        symbol: String,
        fullName: String = "Test Company",
        description: String = "Test Description",
        currentPrice: Double
    ) -> Stock {
        Stock(
            symbol: symbol,
            fullName: fullName,
            description: description,
            currentPrice: currentPrice
        )
    }
}
