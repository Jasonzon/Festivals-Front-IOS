import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    init() {
        API.API = "https://festivals-back-production.up.railway.app"
    }
}
