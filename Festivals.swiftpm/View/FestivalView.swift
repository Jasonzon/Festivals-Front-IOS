import SwiftUI
import AlertToast

struct FestivalView: View {

    @ObservedObject var festivalViewModel: FestivalViewModel
    var intent : FestivalIntent
    @State var festivalId: Int
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""
    
    init(festival: Festival, festivalsViewModel: FestivalsViewModel){
        self.festivalViewModel = FestivalViewModel(model: festival)
        self.intent = FestivalIntent()
        self.festivalId = festival.id
        self.intent.addObserver(viewModel: festivalViewModel)
        self.intent.addListObserver(viewModel: festivalsViewModel)
    }

    var body: some View {
        VStack {
            if (UserSession.shared.user?.role == .Admin) {
                Form {
                    TextField("Nom", text: $festivalViewModel.name)
                    TextField("Année", text: $festivalViewModel.year)
                    Picker(selection: $festivalViewModel.opened, label: Text("Statut")) {
                        Text("Ouvert").tag(true)
                        Text("Fermé").tag(false)
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
            }
            else {
                Text("Nom : \(festivalViewModel.name)")
                Text("Année : \(festivalViewModel.year)")
                Text("Statut : \(festivalViewModel.opened ? "Ouvert" : "Fermé")")
            }
            JoursView(festival: $festivalViewModel.copyModel)
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