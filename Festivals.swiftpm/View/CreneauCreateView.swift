import SwiftUI
import AlertToast

struct CreneauCreateView: View {
    
    @ObservedObject var creneauViewModel: CreneauViewModel
    @Environment(\.presentationMode) var presentationMode
    var intent : CreneauIntent
    @State private var textAlert = ""
    @State private var errorAlert = false
    
    init(creneauxViewModel: CreneauxViewModel) {
        self.creneauViewModel = CreneauViewModel(model: Creneau(id: 0, debut: "", fin: ""))
        self.intent = CreneauIntent()
        self.intent.addObserver(viewModel: creneauViewModel)
        self.intent.addListObserver(viewModel: creneauxViewModel)
    }

    var body: some View {
        VStack {
            Form {
                FloatingTextField("Debut", text: $creneauViewModel.debut)
                FloatingTextField("Fin", text: $creneauViewModel.fin)
                Section {
                    Button("Créer") {
                        Task {
                            intent.intentTestValidation(creneau: creneauViewModel.getCreneauFromViewModel())
                            if creneauViewModel.error == .noError {
                                let data = await API.creneauDAO().create(creneau: CreneauDTO(creneauViewModel.copyModel))
                                switch data{
                                    case .success(let id):
                                        creneauViewModel.copyModel.id = id
                                        intent.intentCreateRequest(element: creneauViewModel.copyModel)
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
            .onChange(of: creneauViewModel.error) { error in
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
            creneauViewModel.error = .noError
            errorAlert = false
        })
    }      
}