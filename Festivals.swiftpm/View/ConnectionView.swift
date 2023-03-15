import SwiftUI

struct ConnectionView: View {

    @ObservedObject var userViewModel: UserViewModel
    var intent: UserIntent
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""
    var isConnected: Bool
    var isRegistering: Bool

    var body: some View {
        VStack {
            Text("Connectez-vous")
            Button("Se connecter") {
                isConnected = true
            }
            Button("S'inscrire") {
                isRegistering = true
            }
        }
    }
}