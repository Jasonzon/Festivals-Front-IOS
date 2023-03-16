import SwiftUI

struct UserView: View {

    @State private var isRegistering = false
    @State private var isConnected: Bool = UserSession.shared.user != nil
    }
    @ObservedObject var userViewModel: UserViewModel
    var intent: UserIntent
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""

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
