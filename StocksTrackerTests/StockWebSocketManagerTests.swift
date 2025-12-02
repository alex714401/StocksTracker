import XCTest
import Combine
@testable import StocksTracker

final class StockWebSocketManagerTests: XCTestCase {
    var sut: StockWebSocketManager!
    var cancellables: Set<AnyCancellable>!
    var mockRepositories: [StockRepository]!

    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        mockRepositories = [.AAPL, .GOOGL, .MSFT]
        sut = StockWebSocketManager(stockRepositories: mockRepositories)
    }

    override func tearDown() {
        sut?.stopFeed()
        cancellables = nil
        sut = nil
        mockRepositories = nil
        super.tearDown()
    }

    func testInitialization() {
        XCTAssertEqual(sut.stocks.count, 3)
        XCTAssertEqual(sut.stocks[0].symbol, "AAPL")
        XCTAssertEqual(sut.stocks[1].symbol, "GOOGL")
        XCTAssertEqual(sut.stocks[2].symbol, "MSFT")

        sut.stocks.forEach { stock in
            XCTAssertTrue(stock.currentPrice >= 100 && stock.currentPrice <= 500)
        }
    }

    func testStockProperties() {
        let aapl = sut.stocks.first { $0.symbol == "AAPL" }
        XCTAssertNotNil(aapl)
        XCTAssertEqual(aapl?.fullName, StockRepository.AAPL.fullName)
        XCTAssertEqual(aapl?.description, StockRepository.AAPL.description)
    }

    func testStocksPublisher() {
        let expectation = expectation(description: "Stocks publisher emits")
        var receivedStocks: [Stock]?

        sut.stocksPublisher
            .sink { stocks in
                receivedStocks = stocks
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(receivedStocks?.count, 3)
    }

    func testStartFeedActivatesManager() {
        sut.startFeed()

        let initialStocksCount = sut.stocks.count
        sut.startFeed()

        XCTAssertEqual(sut.stocks.count, initialStocksCount)
    }

    func testStopFeedDeactivatesManager() {
        sut.startFeed()
        sut.stopFeed()

        sut.startFeed()
        XCTAssertNotNil(sut.stocks)
    }

    func testMultipleStartCallsDoNotCreateDuplicates() {
        sut.startFeed()
        sut.startFeed()
        sut.startFeed()

        XCTAssertEqual(sut.stocks.count, 3)
    }

    func testStopFeedWithoutStarting() {
        sut.stopFeed()
        XCTAssertEqual(sut.stocks.count, 3)
    }

    func testDeinitStopsFeed() {
        sut.startFeed()
        sut = nil

        XCTAssertNil(sut)
    }

    func testEmptyRepositoriesInitialization() {
        let emptyManager = StockWebSocketManager(stockRepositories: [])
        XCTAssertTrue(emptyManager.stocks.isEmpty)
    }
}
