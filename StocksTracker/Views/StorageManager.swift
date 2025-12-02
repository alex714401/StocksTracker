import Foundation

final class StorageManager {
    static let shared = StorageManager()

    private let userDefaults = UserDefaults.standard

    private enum Keys {
        static let isFeedEnabled = "isFeedEnabled"
    }

    private init() {}

    var isFeedEnabled: Bool {
        get {
            // If the key doesn't exist, return true (first launch default)
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
