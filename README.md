# StocksTracker

A real-time iOS stock tracking application built with SwiftUI that displays live stock prices and updates via WebSocket connections.

## Features

- **Real-time Stock Updates** - Live price updates via WebSocket connection
- **Stock List View** - Browse multiple stocks with current prices and price changes
- **Detailed Stock View** - View comprehensive stock information including:
  - Current price with visual flash indicators (green for increase, red for decrease)
  - Price change amount and percentage
  - Stock symbol, full name, and description
  - Last updated timestamp
- **Connection Toggle** - Manual control to connect/disconnect from live feed (state persists locally on device)
- **Connection Status Indicator** - Visual indicator showing connected (green) or disconnected (red) state
- **Deep Linking Support** - Navigate directly to specific stocks via URL scheme (`alex.StocksApp://symbol/`)
- **Persistent Settings** - Feed state persists across app launches
- **Automatic Feed Management** - Feed pauses when app is in background and resumes when active

## Requirements

- iOS 26.1
- Xcode 26.1
- Swift 5

## Installation

1. Clone the repository: git clone [git@github.com:alex714401/StocksTracker.git]
2. Open the project in Xcode: cd StocksTracker then open StocksTracker.xcodeproj
3. Build and run the project in Xcode (⌘R)

## Architecture

The project follows the **MVVM (Model-View-ViewModel)** pattern:

- **Models** - `Stock` data structure with symbol, price, and metadata
- **ViewModels** - `StockDisplayViewModel` manages business logic and state
- **Views** - SwiftUI views for displaying stocks and details
- **Managers**:
  - `WebSocketManager` - Handles real-time WebSocket data connections
  - `StorageManager` - Manages persistent data storage using UserDefaults
  - `DeepLinkManager` - Handles URL-based navigation to specific stocks

  <img width="274" height="587" alt="StocksTracker-DeepLinking" src="https://github.com/user-attachments/assets/cec594d6-c7fa-46ec-8bd7-c9a19e266e9f" />

  <img width="309" height="490" alt="StocksTracker-Lifecycle" src="https://github.com/user-attachments/assets/fd8ac481-a703-47ce-a080-26c220425b6f" />

<img width="344" height="731" alt="StocksTracker-Diagram" src="https://github.com/user-attachments/assets/adfdd86e-1cfe-4ca8-a7a4-f6481d220aba" />


## Usage

### Viewing Stocks

1. Launch the app to see the list of tracked stocks
2. Toggle the feed switch to enable/disable live updates
3. Tap any stock to view detailed information

### Deep Linking

Open a specific stock directly using the URL scheme: alex.StocksApp://symbol/AAPL or alex.StocksApp://symbol/GOOGL

The app will automatically enable the feed if it's disabled when navigating via deep link.

## Contact

- Developer: alex44013

