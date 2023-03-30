import SwiftUI

struct ContentView: View {

    @State private var selection = 1
    @State private var initialized = false

    var body: some View {
        Group {
            if initialized {
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
                .onAppear() {
                    Task {
                        do {
                            if let token = UserDefaults.standard.string(forKey: "token") {
                                let benevoleResult = try await API.benevoleDAO().auth(token: token)
                                switch benevoleResult {
                                    case .success(let id):
                                        let benevoleResult2 = try await API.benevoleDAO().getOne(id: id)
                                        switch benevoleResult2 {
                                        case .success(let benevole):
                                            UserSession.shared.user = benevole
                                            self.initialized = true
                                        case .failure(let error):
                                            print(error)
                                            self.initialized = true
                                        }
                                    case .failure(let error):
                                        print(error)
                                        self.initialized = true
                                }
                            } 
                            else {
                                print("Aucun token trouvé")
                                self.initialized = true
                            }
                        } 
                        catch {
                            print(error)
                            self.initialized = true
                        }
                    }
                }
            }
        }
    }
}
