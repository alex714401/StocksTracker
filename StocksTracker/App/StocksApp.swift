import SwiftUI

@main
struct StocksApp: App {
    @StateObject private var webSocketManager = StockWebSocketManager(
        stockRepositories: StockRepository.allCases)
    @StateObject private var deepLinkManager = DeepLinkManager()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            StockDisplayView(viewModel: StockDisplayViewModel(webSocketManager: webSocketManager,
                                                              storageManager: StocksStorageManager.shared))
                .environmentObject(deepLinkManager)
                .onOpenURL { url in
                    deepLinkManager.handleURL(url)
                }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            handleScenePhaseChange(newPhase, webSocketManager: webSocketManager)
        }
    }
    
    private func handleScenePhaseChange(_ phase: ScenePhase, webSocketManager: StockWebSocketManager) {
        let isFeedEnabled = StocksStorageManager.shared.isFeedEnabled
        
        switch phase {
        case .active:
            if isFeedEnabled {
                webSocketManager.startFeed()
            }
        case .background, .inactive:
            webSocketManager.stopFeed()
        default:
            break
        }
    }
}
