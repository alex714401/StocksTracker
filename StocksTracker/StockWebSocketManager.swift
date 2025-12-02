import Foundation
import Combine

protocol WebSocketManager: AnyObject, ObservableObject {
    var stocks: [Stock] { get }
    var stocksPublisher: Published<[Stock]>.Publisher { get }
    func startFeed()
    func stopFeed()
}

class StockWebSocketManager: NSObject, WebSocketManager {
    @Published var stocks: [Stock] = []
    
    var stocksPublisher: Published<[Stock]>.Publisher { $stocks }
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var cancellables = Set<AnyCancellable>()
    private var timer: AnyCancellable?
    private let stockRepositories: [StockRepository]
    private var isActive = false
    
    init(stockRepositories: [StockRepository]) {
        self.stockRepositories = stockRepositories
        super.init()
        initializeStocks()
    }
    
    func startFeed() {
        guard !isActive else { return }
        isActive = true
        connect()
        startPriceUpdates()
    }
    
    func stopFeed() {
        guard isActive else { return }
        isActive = false
        timer?.cancel()
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }
    
    private func initializeStocks() {
        stocks = stockRepositories.map {
            Stock(
                symbol: $0.rawValue,
                fullName: $0.fullName,
                description: $0.description,
                currentPrice: Double.random(in: 100...500)
            )
        }
    }
    
    private func connect() {
        guard let url = URL(string: "wss://ws.postman-echo.com/raw") else { return }
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    private func startPriceUpdates() {
        timer = Timer.publish(every: 2.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.sendPriceUpdatesForAllStocks()
            }
    }
    
    private func sendPriceUpdatesForAllStocks() {
        stocks.forEach { stock in
            let newPrice = stock.currentPrice * Double.random(in: 0.95...1.05)
            let message = "\(stock.symbol):\(String(format: "%.2f", newPrice))"
            
            let wsMessage = URLSessionWebSocketTask.Message.string(message)
            webSocketTask?.send(wsMessage) { error in
                if let error = error {
                    print("WebSocket send error for \(stock.symbol): \(error)")
                }
            }
        }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleReceivedMessage(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self?.handleReceivedMessage(text)
                    }
                @unknown default:
                    break
                }
                self?.receiveMessage()
            case .failure(let error):
                print("WebSocket receive error: \(error)")
            }
        }
    }
    
    private func handleReceivedMessage(_ message: String) {
        let components = message.split(separator: ":")
        guard components.count == 2,
              let symbol = components.first,
              let priceString = components.last,
              let newPrice = Double(priceString) else { return }
        
        if let index = stocks.firstIndex(where: { $0.symbol == String(symbol) }) {
            DispatchQueue.main.async {
                self.stocks[index].currentPrice = newPrice
                self.stocks[index].lastUpdated = Date()
            }
        }
    }
    
    deinit {
        stopFeed()
    }
}
