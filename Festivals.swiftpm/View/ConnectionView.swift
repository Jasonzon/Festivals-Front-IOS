import SwiftUI

struct ConnectionView: View {

    @Binding var isRegistering: Bool
    @Binding var isConnected: Bool

    private var mail: String = ""
    private var password: String = ""

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
                                    UserSession.shared.user = ben.benevole
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
    }
}