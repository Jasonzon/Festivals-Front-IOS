import SwiftUI

struct UserView: View {

    @State private var isRegistering = false
    @State private var isConnected: Bool = UserSession.shared.benevole != nil
    @ObservedObject var benevoleViewModel: BenevoleViewModel
    var intent: BenevoleIntent
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""

    init() {
        self.benevoleViewModel = BenevoleViewModel(model: UserSession.shared.benevole ?? Benevole(mail: "", nom: "", prenom: "", id: 0, role: .Basic, password: ""))
        self.intent = BenevoleIntent()
        self.intent.addObserver(viewModel: benevoleViewModel)
    }

    var body: some View {
        VStack {
            if isConnected {
                Text(UserSession.shared.user!.prenom + "  " + UserSession.shared.user!.nom)
            } 
            else if isRegistering {
                RegisterView(isRegistering: $isRegistering)
            } 
            else {
                ConnectionView(isRegistering: $isRegistering, isConnected: $isConnected)
            }
        }
    }
}
