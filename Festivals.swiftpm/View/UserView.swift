import SwiftUI

struct UserView: View {

    @State private var isRegistering = false
    @State private var isConnected: Bool = UserSession.shared.user != nil
    @ObservedObject var userViewModel: UserViewModel
    var intent: UserIntent
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""

    init(user: User) {
        self.userViewModel = UserViewModel(model: user)
        self.intent = UserIntent()
        self.intent.addObserver(viewModel: userViewModel)
    }

    var body: some View {
        VStack {
            if isConnected {
                Text(UserSession.shared.user.prenom + "  " + UserSession.shared.user.nom)
            } 
            else if isRegistering {
                RegisterView(isRegistering: $isRegistering)
            } 
            else {
                ConnectionView(isConnected: $isConnected, isRegistering: $isRegistering)
            }
        }
    }
}
