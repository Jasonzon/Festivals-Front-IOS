import SwiftUI
import AlertToast

struct BenevoleCreateView: View {
    
    @ObservedObject var benevoleViewModel: BenevoleViewModel
    @Environment(\.presentationMode) var presentationMode
    var intent : BenevoleIntent
    @State private var textAlert = ""
    @State private var errorAlert = false
    
    init(benevolesViewModel: BenevolesViewModel) {
        self.benevoleViewModel = BenevoleViewModel(model: Benevole(mail: "", nom: "", prenom: "", id: 0, role: UserRole.Basic, password: "")
        self.intent = BenevoleIntent()
        self.intent.addObserver(viewModel: benevoleViewModel)
        self.intent.addListObserver(viewModel: benevolesViewModel)
    }

    var body: some View {
        VStack {
            Form {
                TextField("Prenom", text: $benevoleViewModel.prenom)
                TextField("Nom", text: $benevoleViewModel.nom)
                TextField("Mail", text: $benevoleViewModel.mail)
                Section {
                    Button("Créer") {
                        Task {
                            intent.intentTestValidation(benevole: benevoleViewModel.getBenevoleFromViewModel())
                            if benevoleViewModel.error == .noError {
                                let data = await API.benevoleDAO().create(benevole: benevoleViewModel.copyModel)
                                switch data{
                                    case .success(let id):
                                        benevoleViewModel.copyModel.id = id
                                        intent.intentCreateRequest(element: benevoleViewModel.copyModel)
                                        self.presentationMode.wrappedValue.dismiss()
                                    case .failure(let err):
                                        errorAlert = true
                                        textAlert = "Erreur \(err)"     
                                }
                            }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
            }
            .onChange(of: benevoleViewModel.error) { error in
                print(error)
                if (error != .noError) {
                    textAlert = "\(error)"
                    errorAlert = true
                } 
            }
        }
        .toast(isPresenting: $errorAlert, alert: {
            AlertToast(displayMode: .hud, type: .error(.red), title: textAlert)
        }, completion: {
            benevoleViewModel.error = .noError
            errorAlert = false
        })
    }      
}