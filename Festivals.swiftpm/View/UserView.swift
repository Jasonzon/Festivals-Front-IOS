import SwiftUI

struct UserView: View {

    @State var isRegistering: Bool = false
    @State var isConnected: Bool = false
    @ObservedObject var benevoleViewModel: BenevoleViewModel
    var intent: BenevoleIntent
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""

    init() {
        self.benevoleViewModel = BenevoleViewModel(model: UserSession.shared.user ?? Benevole(mail: "", nom: "", prenom: "", id: 0, role: .Basic, password: ""))
        self.intent = BenevoleIntent()
        self.intent.addObserver(viewModel: benevoleViewModel)
    }

    var body: some View {
        VStack {
            if isConnected {
                Text(UserSession.shared.user!.prenom + "  " + UserSession.shared.user!.nom)
                Button("Se déconnecter") {
                    UserDefaults.standard.removeObject(forKey: "myKey")
                    UserSession.shared.user = nil
                    isConnected = false
                    isRegistering = false
                }
            } 
            else if isRegistering {
                RegisterView(isRegistering: $isRegistering)
            } 
            else {
                ConnectionView(isRegistering: $isRegistering, isConnected: $isConnected)
            }
        }
        .onAppear() {
            if (UserSession.shared.user != nil) {
                isConnected = true
            }
        }
    }
}
