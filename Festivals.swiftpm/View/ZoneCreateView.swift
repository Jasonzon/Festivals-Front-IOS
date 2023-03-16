import SwiftUI
import AlertToast

struct ZoneCreateView: View {
    
    @ObservedObject var zoneViewModel: ZoneViewModel
    @Environment(\.presentationMode) var presentationMode
    var intent : ZoneIntent
    @State private var textAlert = ""
    @State private var errorAlert = false
    
    init(zonesViewModel: ZonesViewModel) {
        self.zoneViewModel = ZoneViewModel(model: Zone(name: "", id: 0))
        self.intent = ZoneIntent()
        self.intent.addObserver(viewModel: zoneViewModel)
        self.intent.addListObserver(viewModel: zonesViewModel)
    }

    var body: some View {
        VStack {
            Form {
                TextField("Nom", text: $zoneViewModel.name)
                Section {
                    Button("Créer") {
                        Task {
                            intent.intentTestValidation(zone: zoneViewModel.getZoneFromViewModel())
                            if zoneViewModel.error == .noError {
                                let data = await API.zoneDAO().create(zone: ZoneDTO(zone: zoneViewModel.copyModel))
                                switch data{
                                    case .success(let id):
                                        zoneViewModel.copyModel.id = id
                                        intent.intentCreateRequest(element: zoneViewModel.copyModel)
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
            .onChange(of: zoneViewModel.error) { error in
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
            zoneViewModel.error = .noError
            errorAlert = false
        })
    }      
}