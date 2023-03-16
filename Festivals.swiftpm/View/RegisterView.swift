import SwiftUI

struct RegisterView: View {

    @ObservedObject var benevoleViewModel: BenevoleViewModel
    var intent: BenevoleIntent
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""
    @Binding var isRegistering: Bool

    var body: some View {
        VStack {
            Text("Formulaire d'enregistrement")
            Button("Retour") {
                isRegistering = false
            }
        }
    }
}