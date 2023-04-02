import SwiftUI
import AlertToast

struct ZoneView: View {

    @ObservedObject var zoneViewModel: ZoneViewModel
    var intent: ZoneIntent
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""
    
    init(zone: Zone, zonesViewModel: ZonesViewModel) {
        self.zoneViewModel = ZoneViewModel(model: zone)
        self.intent = ZoneIntent()
        self.intent.addObserver(viewModel: zoneViewModel)
        self.intent.addListObserver(viewModel: zonesViewModel)
    }

    var body: some View {
        VStack {
            if (UserSession.shared.user?.role == .Admin) {
                Form {
                    TextField("Nom", text: $zoneViewModel.name)
                    TextField("Nombre de bénévoles", value: $zoneViewModel.benevoles, formatter: NumberFormatter(), keyboardType: .numberPad)
                    Section {
                        Button("Enregistrer") {
                            Task {
                                intent.intentTestValidation(zone: zoneViewModel.getZoneFromViewModel())
                                if zoneViewModel.error == .noError {
                                    let data = await intent.intentValidation(zone: zoneViewModel.copyModel)
                                    switch data {
                                        case .success(_):
                                            showingAlert = true
                                            textAlert = "Zone mise à jour"
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
                                let data = await intent.intentDeleteRequest(id: zoneViewModel.id)
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
                    .onChange(of: zoneViewModel.error) { error in
                        print(error)
                        if (error != .noError) {
                            textAlert = "\(error)"
                            errorAlert = true
                        }   
                    }
                }
            }
            else {
                Text("Nom : \(zoneViewModel.name)")
                Text("Nombre de bénévoles : \(zoneViewModel.benevoles)")
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
            zoneViewModel.error = .noError
            errorAlert = false
        })   
    }
}