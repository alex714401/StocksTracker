import SwiftUI
import Combine

@MainActor
class DeepLinkManager: ObservableObject {
    @Published var selectedSymbol: String?
    @Published var shouldNavigateImmediately: Bool = false

    func handleURL(_ url: URL) {
        guard url.pathComponents.count > 1 else {
            print("Invalid URL")
            return
        }
        
        let symbol = url.pathComponents[1].uppercased()
        
        Task {
            selectedSymbol = symbol
        }
    }

    func clearSelection() {
        selectedSymbol = nil
    }
}
