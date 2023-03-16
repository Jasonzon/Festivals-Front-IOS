import SwiftUI

struct ContentView: View {

    init() {
        Task {
            if let token = UserDefaults.standard.string(forKey: "token") {
                do {
                    //let userDTO = try await API.userDAO().connect(token: token)
                    //UserSession.shared.user = User(userDTO)
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

    @State private var selection = 1

    var body: some View {
        TabView(selection: $selection) {
            JeuxView().tabItem {
                Label("Jeux", systemImage: "gamecontroller") 
            }.tag(1)
            ZonesView().tabItem {
                Label("Zones", systemImage: "map.fill")
            }.tag(2)
            BenevolesView().tabItem { 
                Label("Bénévoles", systemImage: "person.3.fill") 
            }.tag(3)
            CreneauxView().tabItem {
                Label("Créneaux", systemImage: "calendar")
            }.tag(4)
            UserView().tabItem {
                Label("Compte", systemImage: "person.circle")
            }.tag(5)
        }
    }
}
