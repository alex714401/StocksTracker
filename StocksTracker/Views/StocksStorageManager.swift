import Foundation

protocol StorageManager {
    var isFeedEnabled: Bool { get set }
}


final class StocksStorageManager: StorageManager {
    static let shared = StocksStorageManager()

    private let userDefaults = UserDefaults.standard

    private enum Keys {
        static let isFeedEnabled = "isFeedEnabled"
    }

    private init() {}

    var isFeedEnabled: Bool {
        get {
            if userDefaults.object(forKey: Keys.isFeedEnabled) == nil {
                return true
            }
            return userDefaults.bool(forKey: Keys.isFeedEnabled)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.isFeedEnabled)
        }
    }
}
