import SwiftUI

struct ConnectionView: View {

    @ObservedObject var benevoleViewModel: BenevoleViewModel
    var intent: BenevoleIntent
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""
    @Binding var isConnected: Bool
    @Binding var isRegistering: Bool

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