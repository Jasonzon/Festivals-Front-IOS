import SwiftUI
import AlertToast

struct BenevoleView: View {

    @ObservedObject var benevoleViewModel: BenevoleViewModel
    var intent : BenevoleIntent
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""
    
    init(benevole: Benevole, benevolesViewModel: BenevolesViewModel){
        self.benevoleViewModel = BenevoleViewModel(model: benevole)
        self.intent = BenevoleIntent()
        self.intent.addObserver(viewModel: benevoleViewModel)
        self.intent.addListObserver(viewModel: benevolesViewModel)
    }

    var body: some View {
        VStack{
            Form {
                TextField("Prenom", text: $benevoleViewModel.prenom)
                TextField("Nom", text: $benevoleViewModel.nom)
                TextField("Mail", text: $benevoleViewModel.mail)
                Section {
                    Button("Enregistrer") {
                        Task {
                            intent.intentTestValidation(benevole: benevoleViewModel.getBenevoleFromViewModel())
                            if benevoleViewModel.error == .noError {
                                let data = await intent.intentValidation(benevole: benevoleViewModel.copyModel)
                                switch data {
                                    case .success(_):
                                        showingAlert = true
                                        textAlert = "Benevole mis à jour"
                                    case .failure(let err):
                                        errorAlert = true
                                        textAlert = "Erreur \(err)"
                                }
                            }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    Button("Supprimer") {
                        Task {
                            let data = await intent.intentDeleteRequest(id: benevoleViewModel.id)
                            switch data {
                                case .success(_):
                                    break
                                case .failure(let err):
                                    errorAlert = true
                                    textAlert = "Erreur \(err)" 
                            }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).foregroundColor(.red)
                }
                .onChange(of: benevoleViewModel.error) { error in
                    print(error)
                    if (error != .noError) {
                        textAlert = "\(error)"
                        errorAlert = true
                    }   
                }
            }
        }
        .toast(isPresenting: $showingAlert, alert: {
            AlertToast(displayMode: .hud, type: .complete(.green), title: textAlert)
        }, completion: {
            showingAlert = false
        })
        .toast(isPresenting: $errorAlert, alert: {
            AlertToast(displayMode: .hud, type: .error(.red), title: textAlert)
        }, completion: {
            benevoleViewModel.error = .noError
            errorAlert = false
        })   
    }
}