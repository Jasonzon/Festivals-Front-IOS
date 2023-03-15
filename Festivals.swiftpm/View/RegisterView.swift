import SwiftUI

struct RegisterView: View {

    @ObservedObject var userViewModel: UserViewModel
    var intent: UserIntent
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""
    var isRegistering: Bool

    var body: some View {
        VStack {
            Text("Formulaire d'enregistrement")
            Button("Retour") {
                isRegistering = false
            }
        }
    }
}