import SwiftUI
import AlertToast

struct JourCreateView: View {
    
    @ObservedObject var jourViewModel: JourViewModel
    @Environment(\.presentationMode) var presentationMode
    var intent : JourIntent
    @State private var textAlert = ""
    @State private var errorAlert = false
    
    init(joursViewModel: JoursViewModel) {
        self.jourViewModel = JourViewModel(model: Jour(name: "", debut: "", fin: "", date: "", id: 0))
        self.intent = JourIntent()
        self.intent.addObserver(viewModel: jourViewModel)
        self.intent.addListObserver(viewModel: joursViewModel)
    }

    var body: some View {
        VStack {
            Form {
                TextField("Nom", text: $jourViewModel.name)
                TextField("Début", text: $jourViewModel.debut)
                TextField("Fin", text: $jourViewModel.fin)
                TextField("Date", text: $jourViewModel.date)
                Section {
                    Button("Créer") {
                        Task {
                            intent.intentTestValidation(jour: jourViewModel.getJourFromViewModel())
                            if jourViewModel.error == .noError {
                                let data = await API.jourDAO().create(jour: jourViewModel.copyModel)
                                switch data{
                                    case .success(let id):
                                        jourViewModel.copyModel.id = id
                                        intent.intentCreateRequest(element: jourViewModel.copyModel)
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
            .onChange(of: jourViewModel.error) { error in
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
            jourViewModel.error = .noError
            errorAlert = false
        })
    }      
}