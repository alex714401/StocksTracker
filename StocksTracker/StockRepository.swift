import Foundation

enum StockRepository: String, CaseIterable {
    case AAPL
    case GOOGL
    case MSFT
    case AMZN
    case TSLA
    case META
    case NVDA
    case NFLX
    case JPM
    case V
    case JNJ
    case WMT
    case PG
    case MA
    case UNH
    case HD
    case DIS
    case PYPL
    case VZ
    case ADBE
    case CMCSA
    case INTC
    case CSCO
    case PFE
    case KO
    
    var fullName: String {
        switch self {
        case .AAPL: return "Apple Inc."
        case .GOOGL: return "Alphabet Inc."
        case .MSFT: return "Microsoft Corporation"
        case .AMZN: return "Amazon.com Inc."
        case .TSLA: return "Tesla Inc."
        case .META: return "Meta Platforms Inc."
        case .NVDA: return "NVIDIA Corporation"
        case .NFLX: return "Netflix Inc."
        case .JPM: return "JPMorgan Chase & Co."
        case .V: return "Visa Inc."
        case .JNJ: return "Johnson & Johnson"
        case .WMT: return "Walmart Inc."
        case .PG: return "Procter & Gamble Co."
        case .MA: return "Mastercard Inc."
        case .UNH: return "UnitedHealth Group Inc."
        case .HD: return "The Home Depot Inc."
        case .DIS: return "The Walt Disney Company"
        case .PYPL: return "PayPal Holdings Inc."
        case .VZ: return "Verizon Communications Inc."
        case .ADBE: return "Adobe Inc."
        case .CMCSA: return "Comcast Corporation"
        case .INTC: return "Intel Corporation"
        case .CSCO: return "Cisco Systems Inc."
        case .PFE: return "Pfizer Inc."
        case .KO: return "The Coca-Cola Company"
        }
    }
    
    var description: String {
        switch self {
        case .AAPL: return "Technology company specializing in consumer electronics, software, and online services"
        case .GOOGL: return "Multinational technology company specializing in Internet-related services and products"
        case .MSFT: return "Technology corporation producing computer software, consumer electronics, and personal computers"
        case .AMZN: return "E-commerce, cloud computing, digital streaming, and artificial intelligence company"
        case .TSLA: return "Electric vehicle and clean energy company"
        case .META: return "Social media and technology company operating Facebook, Instagram, and WhatsApp"
        case .NVDA: return "Technology company specializing in graphics processing units and artificial intelligence"
        case .NFLX: return "Streaming entertainment service offering films and television series"
        case .JPM: return "Multinational investment bank and financial services company"
        case .V: return "Multinational financial services corporation facilitating electronic funds transfers"
        case .JNJ: return "Multinational pharmaceutical, biotechnology, and medical technologies corporation"
        case .WMT: return "Multinational retail corporation operating hypermarkets and grocery stores"
        case .PG: return "Multinational consumer goods corporation"
        case .MA: return "Multinational financial services corporation operating payment processing network"
        case .UNH: return "Diversified health care company offering health insurance and care services"
        case .HD: return "Home improvement retailer selling tools, construction products, and services"
        case .DIS: return "Diversified multinational mass media and entertainment conglomerate"
        case .PYPL: return "Online payments system supporting online money transfers"
        case .VZ: return "Telecommunications conglomerate offering wireless and wireline communications services"
        case .ADBE: return "Computer software company focused on content creation and digital marketing"
        case .CMCSA: return "Telecommunications conglomerate providing cable television, internet, and telephone services"
        case .INTC: return "Technology company designing and manufacturing semiconductor chips"
        case .CSCO: return "Technology conglomerate specializing in networking hardware and telecommunications equipment"
        case .PFE: return "Pharmaceutical and biotechnology corporation"
        case .KO: return "Beverage corporation manufacturing and marketing nonalcoholic beverage concentrates and syrups"
        }
    }
}
