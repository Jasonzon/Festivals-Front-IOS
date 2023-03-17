import SwiftUI

struct ConnectionView: View {

    @Binding var isRegistering: Bool
    @Binding var isConnected: Bool

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