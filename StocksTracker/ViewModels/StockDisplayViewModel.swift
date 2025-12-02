import Foundation
import Combine

@MainActor
class StockDisplayViewModel: ObservableObject {
    @Published var isFeedEnabled: Bool {
         didSet {
             storageManager.isFeedEnabled = isFeedEnabled
         }
     }

    @Published var stocks: [Stock] = []

    let webSocketManager: any WebSocketManager
    private var storageManager: StorageManager
    private var cancellables = Set<AnyCancellable>()

    init(webSocketManager: any WebSocketManager,
         storageManager: StorageManager) {
        self.webSocketManager = webSocketManager
        self.storageManager = storageManager
        self.isFeedEnabled = storageManager.isFeedEnabled
        setupBindings()
    }

    func toggleFeed(_ isEnabled: Bool) {
        isFeedEnabled = isEnabled
        isEnabled ? startFeed() : stopFeed()
    }

    func startFeed() {
        webSocketManager.startFeed()
    }

    func stopFeed() {
        webSocketManager.stopFeed()
    }

    private func setupBindings() {
        webSocketManager.stocksPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$stocks)
    }
}
