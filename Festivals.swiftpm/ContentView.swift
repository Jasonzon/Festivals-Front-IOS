import SwiftUI

struct ContentView: View {

    init() {
        async {
            if let token = UserDefaults.standard.string(forKey: "token") {
                do {
                    let benevoleResult = try await API.benevoleDAO().auth(token: token)
                    switch benevoleResult {
                        case .success(let benevole):
                            UserSession.shared.user = benevole
                        case .failure(let error):
                            print(error)
                    }
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
