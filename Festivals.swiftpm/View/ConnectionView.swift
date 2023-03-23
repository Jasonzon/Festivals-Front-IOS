import SwiftUI
import AlertToast

struct ConnectionView: View {

    @Binding var isRegistering: Bool
    @Binding var isConnected: Bool

    @State private var mail: String = ""
    @State private var password: String = ""
    @State private var textAlert = ""
    @State private var errorAlert = false

    var body: some View {
        VStack {
            Form {
                TextField("Mail", text: $mail)
                SecureField("Mot de passe", text: $password)
                Section {
                    Button("Se connecter") {
                        Task {
                            let data = await API.benevoleDAO().connect(mail: mail, password: password)
                            switch data{
                                case .success(let ben):
                                    UserDefaults.standard.set(ben.token, forKey: "token")
                                    UserSession.shared.user = Benevole(benevoleDTO: ben.benevole)
                                    isConnected = true
                                case .failure(let err):
                                    errorAlert = true
                                    textAlert = "Erreur \(err)"     
                            }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    Button("Pas de compte ? S'inscrire") {
                        isRegistering = true
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
            }
        }
        .toast(isPresenting: $errorAlert, alert: {
            AlertToast(displayMode: .hud, type: .error(.red), title: textAlert)
        }, completion: {
            errorAlert = false
        })
    }
}