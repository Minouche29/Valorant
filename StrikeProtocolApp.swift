import SwiftUI

@main
struct StrikeProtocolApp: App {
    @StateObject private var profile = PlayerProfile()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(profile)
                .preferredColorScheme(.dark)
        }
    }
}
