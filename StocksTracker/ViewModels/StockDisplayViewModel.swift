import Foundation
import Combine

@MainActor
class StockDisplayViewModel: ObservableObject {
    @Published var isFeedEnabled: Bool {
         didSet {
             StorageManager.shared.isFeedEnabled = isFeedEnabled
         }
     }
     
    @Published var stocks: [Stock] = []
    
    let webSocketManager: any WebSocketManager
    private var cancellables = Set<AnyCancellable>()
    
    init(webSocketManager: any WebSocketManager) {
        self.webSocketManager = webSocketManager
        self.isFeedEnabled = StorageManager.shared.isFeedEnabled
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
