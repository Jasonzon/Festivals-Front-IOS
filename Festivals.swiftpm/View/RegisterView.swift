import SwiftUI

struct RegisterView: View {

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