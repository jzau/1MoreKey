import Foundation
import ReactiveSwift

class PreferenceManager {
    // User preference
    private static let autoCheckUpdateKey = "autoCheckUpdateKey"
    private static let autostartKey = "autostartKey"

    static func setUp() {
        let defaults = UserDefaults.standard

        if defaults.object(forKey: autoCheckUpdateKey) != nil {
            UpdateManager.autoCheck.swap(defaults.bool(forKey: autoCheckUpdateKey))
        }else {
            defaults.set(true, forKey: autoCheckUpdateKey)
            UpdateManager.autoCheck.swap(true)
        }

        AutostartManager.autostartAtLogin.swap(defaults.bool(forKey: autostartKey))
        AutostartManager.autostartAtLogin.signal.skipRepeats(==).observeValues {
            defaults.set($0, forKey: autostartKey)
        }

        UpdateManager.autoCheck.signal.skipRepeats(==).observeValues {
            defaults.set($0, forKey: autoCheckUpdateKey)
        }
    }
}
