import SwiftUI

struct StockDetailsView: View {
    @Binding var stock: Stock
    @State private var flashColor: Color?
    @State private var previousPrice: Double?
    @EnvironmentObject var deepLinkManager: DeepLinkManager
    
    init(stock: Binding<Stock>) {
        _stock = stock
    }
    
    private var formatter: StockFormatter {
        StockFormatter(stock: stock)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("$\(formatter.formattedCurrentPrice)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(flashColor ?? .primary)
                        .animation(.spring(duration: 0.05), value: flashColor)
                    
                    HStack(spacing: 8) {
                        Text(formatter.formattedPriceChange)
                            .font(.title3)
                        Text("(\(formatter.formattedPriceChangePercentage))")
                            .font(.title3)
                    }
                    .foregroundColor(formatter.priceChangeColor)
                    
                    Text("Last updated: \(stock.lastUpdated, style: .time)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 16) {
                    DetailRow(title: "Symbol", value: stock.symbol)
                    DetailRow(title: "Stock Name", value: stock.fullName)
                    DetailRow(title: "Current Price", value: "$\(formatter.formattedCurrentPrice)")
                    DetailRow(title: "Change", value: formatter.formattedPriceChange)
                    Text(stock.description)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(stock.symbol)
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: stock.currentPrice) { oldValue, newValue in
            if let previous = previousPrice, previous != newValue {
                if newValue > previous {
                    flashColor = .green
                } else if newValue < previous {
                    flashColor = .red
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    flashColor = nil
                }
            }
            previousPrice = newValue
        }
        .onAppear {
            previousPrice = stock.currentPrice
        }
        .onDisappear {
            deepLinkManager.clearSelection()
        }
    }
}

struct StockFormatter {
    let stock: Stock
    
    var priceChange: Double {
        stock.currentPrice - stock.previousPrice
    }
    
    var priceChangePercentage: Double {
        guard stock.previousPrice != 0 else { return 0 }
        return ((stock.currentPrice - stock.previousPrice) / stock.previousPrice) * 100
    }
    
    var priceChangeColor: Color {
        priceChange >= 0 ? .green : .red
    }
    
    var formattedCurrentPrice: String {
        String(format: "%.2f", stock.currentPrice)
    }
    
    var formattedPriceChange: String {
        "\(priceChange >= 0 ? "+" : "")\(String(format: "%.2f", priceChange))"
    }
    
    var formattedPriceChangePercentage: String {
        "\(priceChange >= 0 ? "+" : "")\(String(format: "%.2f", priceChangePercentage))%"
    }
}
