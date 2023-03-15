import SwiftUI
import AlertToast

struct JeuCreateView: View {
    
    @ObservedObject var jeuViewModel: JeuViewModel
    @Environment(\.presentationMode) var presentationMode
    var intent : JeuIntent
    var types: [String] = ["enfant","famille","initie","avance","expert"]
    @State private var selectedType: Int = 0
    @State private var textAlert = ""
    @State private var errorAlert = false
    
    init(jeuxViewModel: JeuxViewModel) {
        self.jeuViewModel = JeuViewModel(model: Jeu(id: 0, name: "", type: "enfant"))
        self.intent = JeuIntent()
        self.intent.addObserver(viewModel: jeuViewModel)
        self.intent.addListObserver(viewModel: jeuxViewModel)
    }

    var body: some View {
        VStack {
            Form {
                FloatingTextField("Nom", text: $jeuxViewModel.name)
                Picker(selection: $selectedType, label: Text("Type")) {
                    ForEach(types, id: \.self) { type in
                        Text(type).tag(types.firstIndex(of: type))
                    }
                }
                .onChange(of: self.selectedType, perform: { _ in
                    print("Value \(selectedType)")
                    let newValue = types[selectedType]
                    jeuViewModel.type = newValue
                })
                Section {
                    Button("Créer") {
                        Task {
                            intent.intentTestValidation(jeu: jeuViewModel.getJeuFromViewModel())
                            if jeuViewModel.error == .noError {
                                let data = await API.jeuDAO().create(jeu: JeuDTO(jeuViewModel.copyModel))
                                switch data{
                                    case .success(let id):
                                        jeuViewModel.copyModel.id = id
                                        intent.intentCreateRequest(element: jeuViewModel.copyModel)
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
            .onChange(of: jeuViewModel.error) { error in
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
            jeuViewModel.error = .noError
            errorAlert = false
        })
    }      
}