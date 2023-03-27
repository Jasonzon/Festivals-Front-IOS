import SwiftUI

struct ContentView: View {

    @State private var selection = 1
    @State private var isInitialized = false

    init() {
        Task {
            if let token = UserDefaults.standard.string(forKey: "token") {
                do {
                    let benevoleResult = try await API.benevoleDAO().auth(token: token)
                    switch benevoleResult {
                        case .success(let id):
                            let benevoleResult2 = try await API.benevoleDAO().getOne(id: id)
                            switch benevoleResult2 {
                                case .success(let benevole):
                                    UserSession.shared.user = benevole
                                case .failure(let error):
                                    print(error)
                            }
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
            isInitialized = true
        }
    }
    

    var body: some View {
        Group {
            if isInitialized {
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
            else {
                Text("Chargement...")
            }
        }
    }
}
