import SwiftUI

struct StockRowView: View {
    let stock: Stock
    @State private var flashColor: Color?
    @State private var previousPrice: Double?
    
    private var formatter: StockFormatter {
        StockFormatter(stock: stock)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(stock.symbol)
                    .font(.headline)
                Text(stock.fullName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(formatter.formattedCurrentPrice)")
                    .font(.headline)
                    .foregroundColor(flashColor ?? .primary)
                    .animation(.spring(duration: 0.05), value: flashColor)
                
                Text(formatter.formattedPriceChange)
                    .font(.caption)
                    .foregroundColor(formatter.priceChangeColor)
            }
        }
        .padding(.vertical, 4)
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
    }
}
