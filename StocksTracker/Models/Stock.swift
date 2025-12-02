import Foundation

struct Stock: Identifiable, Hashable {
    let id = UUID()
    let symbol: String
    let fullName: String
    var currentPrice: Double
    var previousPrice: Double
    var lastUpdated: Date
    let description: String

    init(symbol: String, fullName: String, description: String, currentPrice: Double) {
        self.symbol = symbol
        self.fullName = fullName
        self.description = description
        self.currentPrice = currentPrice
        self.previousPrice = currentPrice
        self.lastUpdated = Date()
    }
}
