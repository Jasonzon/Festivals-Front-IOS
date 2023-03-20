import SwiftUI
import AlertToast

struct FestivalCreateView: View {
    
    @ObservedObject var festivalViewModel: FestivalViewModel
    @Environment(\.presentationMode) var presentationMode
    var intent : FestivalIntent
    @State private var textAlert = ""
    @State private var errorAlert = false
    
    init(festivalsViewModel: FestivalsViewModel) {
        self.festivalViewModel = FestivalViewModel(model: Festival(name: "", year: "", opened: true, id: 0))
        self.intent = FestivalIntent()
        self.intent.addObserver(viewModel: festivalViewModel)
        self.intent.addListObserver(viewModel: festivalsViewModel)
    }

    var body: some View {
        VStack {
            Form {
                TextField("Nom", text: $festivalViewModel.name)
                TextField("Année", text: $festivalViewModel.year)
                Picker(selection: $festivalViewModel.opened, label: Text("Statut")) {
                    Text("Ouvert").tag(0)
                    Text("Fermé").tag(1)
                }
                Section {
                    Button("Créer") {
                        Task {
                            intent.intentTestValidation(festival: festivalViewModel.getFestivalFromViewModel())
                            if festivalViewModel.error == .noError {
                                let data = await API.festivalDAO().create(festival: festivalViewModel.copyModel)
                                switch data{
                                    case .success(let id):
                                        festivalViewModel.copyModel.id = id
                                        intent.intentCreateRequest(element: festivalViewModel.copyModel)
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
            .onChange(of: festivalViewModel.error) { error in
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
            festivalViewModel.error = .noError
            errorAlert = false
        })
    }      
}