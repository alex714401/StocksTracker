import SwiftUI

struct StockDisplayView: View {
    
    @StateObject private var viewModel: StockDisplayViewModel
    @EnvironmentObject var deepLinkManager: DeepLinkManager
    @Environment(\.scenePhase) private var scenePhase

    init(viewModel: StockDisplayViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                feedToggle()
                Spacer()
                stockList()
            }
            .navigationDestination(for: Stock.self) { stock in
                if let index = viewModel.stocks.firstIndex(where: { $0.id == stock.id }) {
                    StockDetailsView(stock: $viewModel.stocks[index])
                }
            }
            .navigationDestination(item: $deepLinkManager.selectedSymbol) { symbol in
                if let index = viewModel.stocks.firstIndex(where: { $0.symbol == symbol }) {
                    StockDetailsView(stock: $viewModel.stocks[index])
                }
            }
        }
        .onAppear {
            if viewModel.isFeedEnabled {
                viewModel.startFeed()
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                if viewModel.isFeedEnabled {
                    viewModel.startFeed()
                }
            case .background, .inactive:
                viewModel.stopFeed()
            @unknown default:
                break
            }
        }
        .onChange(of: deepLinkManager.selectedSymbol) { oldValue, newValue in
            if newValue != nil && !viewModel.isFeedEnabled {
                viewModel.toggleFeed(true)
            }
        }
    }
}

private extension StockDisplayView {
    func feedToggle() -> some View {
        HStack {
            HStack(spacing: 8) {
                Circle()
                    .fill(viewModel.isFeedEnabled ? Color.green : Color.red)
                    .frame(width: 12, height: 12)

                Text(viewModel.isFeedEnabled ? "Connected" : "Disconnected")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }.padding()

            Spacer()

            Toggle("", isOn: $viewModel.isFeedEnabled)
                .toggleStyle(.switch)
                .padding()
                .padding(.horizontal)
                .onChange(of: viewModel.isFeedEnabled) { oldValue, newValue in
                    viewModel.toggleFeed(newValue)
                }
        }
    }

    func stockList() -> some View {
        List {
            ForEach(viewModel.stocks) { stock in
                NavigationLink(value: stock) {
                    StockRowView(stock: stock)
                }
            }
        }
        .listStyle(.plain)
    }
}
