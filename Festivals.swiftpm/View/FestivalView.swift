import SwiftUI
import AlertToast

struct FestivalView: View {

    @ObservedObject var festivalViewModel: FestivalViewModel
    var intent : FestivalIntent
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""
    
    init(festival: Festival, festivalsViewModel: FestivalsViewModel){
        self.festivalViewModel = FestivalViewModel(model: festival)
        self.intent = FestivalIntent()
        self.intent.addObserver(viewModel: festivalViewModel)
        self.intent.addListObserver(viewModel: festivalsViewModel)
    }

    var body: some View {
        VStack{
            Form {
                TextField("Nom", text: $festivalViewModel.name)
                TextField("Année", text: $festivalViewModel.year)
                Picker(selection: $festivalViewModel.opened, label: Text("Statut")) {
                    Text("Ouvert").tag(0)
                    Text("Fermé").tag(1)
                }
                Section {
                    Button("Enregistrer") {
                        Task {
                            intent.intentTestValidation(festival: festivalViewModel.getFestivalFromViewModel())
                            if festivalViewModel.error == .noError {
                                let data = await intent.intentValidation(festival: festivalViewModel.copyModel)
                                switch data {
                                    case .success(_):
                                        showingAlert = true
                                        textAlert = "Festival mis à jour"
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
                            let data = await intent.intentDeleteRequest(id: festivalViewModel.id)
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
                .onChange(of: festivalViewModel.error) { error in
                    print(error)
                    if (error != .noError) {
                        textAlert = "\(error)"
                        errorAlert = true
                    }   
                }
            }
            JoursView(festival: festivalViewModel.id)
        }
        .toast(isPresenting: $showingAlert, alert: {
            AlertToast(displayMode: .hud, type: .complete(.green), title: textAlert)
        }, completion: {
            showingAlert = false
        })
        .toast(isPresenting: $errorAlert, alert: {
            AlertToast(displayMode: .hud, type: .error(.red), title: textAlert)
        }, completion: {
            festivalViewModel.error = .noError
            errorAlert = false
        })   
    }
}