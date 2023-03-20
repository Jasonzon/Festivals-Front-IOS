import SwiftUI

struct ContentView: View {

    init() {
        Task {
            if let token = UserDefaults.standard.string(forKey: "token") {
                do {
                    //let benevoleDTO = try await API.benevoleDAO().connect(token: token)
                    //UserSession.shared.user = Benevole(benevoleDTO: benevoleDTO)
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
            FestivalsView().tabItem {
                Label("Festivals", systemImage: "gamecontroller") 
            }.tag(1)
            BenevolesView().tabItem { 
                Label("Bénévoles", systemImage: "person.3.fill") 
            }.tag(2)
            UserView().tabItem {
                Label("Compte", systemImage: "person.circle")
            }.tag(3)
        }
    }
}
