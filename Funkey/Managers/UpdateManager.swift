import Foundation
import Sparkle
import ReactiveSwift

class UpdateManager {
    static let autoCheck: MutableProperty<Bool> = MutableProperty(true)

    static func setUp() {
        let updater = SUUpdater.shared()!
        updater.updateCheckInterval = 86400
        updater.feedURL = URL(string: "https://jackymelb.github.io/1MoreKey/update.xml")

        autoCheck.producer.startWithValues {
            updater.automaticallyChecksForUpdates = $0
        }
    }
}
