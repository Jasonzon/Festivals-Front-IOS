import SwiftUI
import AlertToast

struct CreneauView: View {

    @ObservedObject var creneauViewModel: CreneauViewModel
    var intent : CreneauIntent
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""
    @Binding var festival: Int
    
    init(creneau: Creneau, creneauxViewModel: CreneauxViewModel, festival: Binding<Int>) {
        _festival = festival
        self.creneauViewModel = CreneauViewModel(model: creneau)
        self.intent = CreneauIntent()
        self.intent.addObserver(viewModel: creneauViewModel)
        self.intent.addListObserver(viewModel: creneauxViewModel)
    }

    var body: some View {
        VStack {
            if (UserSession.shared.user?.role == .Admin) {
                Form {
                    TextField("Debut", text: $creneauViewModel.debut)
                    TextField("Fin", text: $creneauViewModel.fin)
                    Section {
                        Button("Enregistrer") {
                            Task {
                                intent.intentTestValidation(creneau: creneauViewModel.getCreneauFromViewModel())
                                if creneauViewModel.error == .noError {
                                    let data = await intent.intentValidation(creneau: creneauViewModel.copyModel)
                                    switch data {
                                        case .success(_):
                                            showingAlert = true
                                            textAlert = "Creneau mis à jour"
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
                                let data = await intent.intentDeleteRequest(id: creneauViewModel.id)
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
                    .onChange(of: creneauViewModel.error) { error in
                        print(error)
                        if (error != .noError) {
                            textAlert = "\(error)"
                            errorAlert = true
                        }   
                    }
                }
            }
            else {
                Text("Debut : \(creneauViewModel.debut)")
                Text("Fin : \(creneauViewModel.fin)")
            }
            ZonesView(creneau: $creneauViewModel.copyModel, festival: $festival)
        }
        .toast(isPresenting: $showingAlert, alert: {
            AlertToast(displayMode: .hud, type: .complete(.green), title: textAlert)
        }, completion: {
            showingAlert = false
        })
        .toast(isPresenting: $errorAlert, alert: {
            AlertToast(displayMode: .hud, type: .error(.red), title: textAlert)
        }, completion: {
            creneauViewModel.error = .noError
            errorAlert = false
        })   
    }
}