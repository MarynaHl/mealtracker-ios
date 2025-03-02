import SwiftUI

@main
struct DarkMealTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.dark) // насильно встановлюємо темний режим
        }
    }
}
