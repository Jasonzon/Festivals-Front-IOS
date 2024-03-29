import SwiftUI
import AlertToast

struct JourView: View {

    @ObservedObject var jourViewModel: JourViewModel
    var intent : JourIntent
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""
    private var startDate: Date
    private var endDate: Date
    @Binding var festival: Int
    @Binding var year: String
    @Binding var opened: Bool
    
    init(jour: Jour, joursViewModel: JoursViewModel, festival: Binding<Int>, year: Binding<String>, opened: Binding<Bool>) {
        _festival = festival
        _year = year
        _opened = opened
        self.jourViewModel = JourViewModel(model: jour)
        self.startDate = Calendar.current.date(from: DateComponents(year: Int(year.wrappedValue)!, month: 1, day: 1))!
        self.endDate = Calendar.current.date(from: DateComponents(year: Int(year.wrappedValue)!, month: 12, day: 31))!
        self.intent = JourIntent()
        self.intent.addObserver(viewModel: jourViewModel)
        self.intent.addListObserver(viewModel: joursViewModel)
    }

    var body: some View {
        VStack {
            if (UserSession.shared.user?.role == .Admin) {
                Form {
                    TextField("Nom", text: $jourViewModel.name)
                    DatePicker("Date", selection: $jourViewModel.date, in: startDate...endDate, displayedComponents: [.date])
                    HStack {
                        Text("Début")
                        DatePicker("", selection: $jourViewModel.debut, displayedComponents: [.hourAndMinute])
                    }
                    HStack {
                        Text("Fin")
                        DatePicker("", selection: $jourViewModel.fin, displayedComponents: [.hourAndMinute])
                    }
                    Section {
                        Button("Enregistrer") {
                            Task {
                                intent.intentTestValidation(jour: jourViewModel.getJourFromViewModel())
                                if jourViewModel.error == .noError {
                                    let data = await intent.intentValidation(jour: jourViewModel.copyModel)
                                    switch data {
                                        case .success(_):
                                            showingAlert = true
                                            textAlert = "Jour mis à jour"
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
                                let data = await intent.intentDeleteRequest(id: jourViewModel.id)
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
                    .onChange(of: jourViewModel.error) { error in
                        print(error)
                        if (error != .noError) {
                            textAlert = "\(error)"
                            errorAlert = true
                        }   
                    }
                }
            }
            else {
                Text("Nom : \(jourViewModel.name)")
                Text("Début : \(jourViewModel.debut)")
                Text("Fin : \(jourViewModel.fin)")
            }
            CreneauxView(jour: $jourViewModel.copyModel, festival: $festival, opened: $opened)
        }
        .toast(isPresenting: $showingAlert, alert: {
            AlertToast(displayMode: .hud, type: .complete(.green), title: textAlert)
        }, completion: {
            showingAlert = false
        })
        .toast(isPresenting: $errorAlert, alert: {
            AlertToast(displayMode: .hud, type: .error(.red), title: textAlert)
        }, completion: {
            jourViewModel.error = .noError
            errorAlert = false
        })   
    }
}