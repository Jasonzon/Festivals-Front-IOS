import SwiftUI

struct UserView: View {

    @State var isRegistering: Bool = false
    @State var isConnected: Bool = false
    @ObservedObject var benevoleViewModel: BenevoleViewModel
    var intent: BenevoleIntent
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""

    init() {
        self.benevoleViewModel = BenevoleViewModel(model: UserSession.shared.user ?? Benevole(mail: "", nom: "", prenom: "", id: 0, role: .Basic, password: ""))
        self.intent = BenevoleIntent()
        self.intent.addObserver(viewModel: benevoleViewModel)
    }

    var body: some View {
        VStack {
            if isConnected {
                Text(UserSession.shared.user!.prenom + "  " + UserSession.shared.user!.nom)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                Spacer()
                Button(action: {
                    UserDefaults.standard.removeObject(forKey: "myKey")
                    UserSession.shared.user = nil
                    isConnected = false
                    isRegistering = false
                }) {
                    Text("Se déconnecter")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
                .padding(.bottom, 30)
                Spacer()
            }
            else if isRegistering {
                RegisterView(isRegistering: $isRegistering)
            }
            else {
                ConnectionView(isRegistering: $isRegistering, isConnected: $isConnected)
            }
        }
        .onAppear() {
            if (UserSession.shared.user != nil) {
                isConnected = true
            }
        }
    }
}
