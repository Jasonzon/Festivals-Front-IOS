import SwiftUI

struct ContentView: View {

    init() {
        Task {
            if let token = UserDefaults.standard.string(forKey: "token") {
                do {
                    let userDTO = try await API.userDAO().connect(token: token)
                    UserSession.shared.user = User(userDTO)
                } 
                catch {
                    print(error)
                }
            } 
            else {
                print("Aucun token trouvé")
            }
        }
    }

    var body: some View {
        TabView(selection: .constant(1)) {
            JeuxView().tabItem {
                Label("Jeux") 
            }.tag(1)
            ZonesView().tabItem {
                Label("Zones")
            }.tag(2)
            BenevolesView().tabItem { 
                Label("Bénévoles") 
            }.tag(3)
            CreneauxView().tabItem {
                Label("Créneaux")
            }.tag(4)
            UserView().tabItem {
                Label("Compte")
            }.tag(5)
        }
    }
}
