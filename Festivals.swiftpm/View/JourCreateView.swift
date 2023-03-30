import SwiftUI
import AlertToast

struct JourCreateView: View {
    
    @ObservedObject var jourViewModel: JourViewModel
    @Environment(\.presentationMode) var presentationMode
    var intent : JourIntent
    @State private var textAlert = ""
    @State private var errorAlert = false

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    init(joursViewModel: JoursViewModel, festival: Int) {
        self.jourViewModel = JourViewModel(model: Jour(name: "", debut: "", fin: "", date: "", id: 0, festival: festival))
        self.intent = JourIntent()
        self.intent.addObserver(viewModel: jourViewModel)
        self.intent.addListObserver(viewModel: joursViewModel)
    }

    var body: some View {
        VStack {
            Form {
                TextField("Nom", text: $jourViewModel.name)
                DatePicker("Date", selection: $jourViewModel.date, displayedComponents: .date)
                .datePickerStyle(.compact)
                .environment(\.locale, Locale(identifier: "fr"))
                
                DatePicker("Heure de début", selection: $jourViewModel.debut, displayedComponents: .hourAndMinute)
                .datePickerStyle(.compact)
                .environment(\.locale, Locale(identifier: "fr"))
                
                DatePicker("Heure de fin", selection: $jourViewModel.fin, displayedComponents: .hourAndMinute)
                .datePickerStyle(.compact)
                .environment(\.locale, Locale(identifier: "fr"))
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
            .onReceive(jourViewModel.$date) { date in
                jourViewModel.dateString = dateFormatter.string(from: date)
            }
            .onReceive(jourViewModel.$debut) { debut in
                jourViewModel.debutString = timeFormatter.string(from: debut)
            }
            .onReceive(jourViewModel.$fin) { fin in
                jourViewModel.finString = timeFormatter.string(from: fin)
            }
            .onReceive(jourViewModel.$error) { error in
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