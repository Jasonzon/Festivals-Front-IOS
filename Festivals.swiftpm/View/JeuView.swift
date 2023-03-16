import SwiftUI
import AlertToast

struct JeuView: View {

    @ObservedObject var jeuViewModel: JeuViewModel
    var intent : JeuIntent
    var types: [String] = ["enfant","famille","initie","avance","expert"]
    @State private var selectedType: Int
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""
    
    init(jeu: Jeu, jeuxViewModel: JeuxViewModel){
        self.jeuViewModel = JeuViewModel(model: jeu)
        self.intent = JeuIntent()
        self.selectedType = types.firstIndex(of: jeu.type.rawValue)
        self.intent.addObserver(viewModel: jeuViewModel)
        self.intent.addListObserver(viewModel: jeuxViewModel)
    }

    var body: some View {
        VStack{
            Form {
                TextField("Nom", text: $jeuViewModel.name)
                Picker(selection: $selectedType, label: Text("Type")) {
                    ForEach(types, id:\.self) { type in
                        Text(type).tag(types.firstIndex(of: type))
                    }
                }
                .onChange(of: self.selectedType, perform: { _ in
                    print("Value \(selectedType)")
                    let newValue = types[selectedType]
                    jeuViewModel.type = JeuType(rawValue: newValue)
                })
                Section {
                    Button("Enregistrer") {
                        Task {
                            intent.intentTestValidation(jeu: jeuViewModel.getJeuFromViewModel())
                            if jeuViewModel.error == .noError {
                                let data = await intent.intentValidation(jeu: jeuViewModel.copyModel)
                                switch data {
                                    case .success(_):
                                        showingAlert = true
                                        textAlert = "Jeu mis à jour"
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
                            let data = await intent.intentDeleteRequest(id: jeuViewModel.id)
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
                .onChange(of: jeuViewModel.error) { error in
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
            jeuViewModel.error = .noError
            errorAlert = false
        })   
    }
}