import SwiftUI
import AlertToast

struct CreneauView: View {

    @ObservedObject var creneauViewModel: CreneauViewModel
    var intent : CreneauIntent
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""
    @Binding var festival: Int
    @Binding var opened: Bool
    
    init(creneau: Creneau, creneauxViewModel: CreneauxViewModel, festival: Binding<Int>, opened: Binding<Bool>) {
        _festival = festival
        _opened = opened
        self.creneauViewModel = CreneauViewModel(model: creneau)
        self.intent = CreneauIntent()
        self.intent.addObserver(viewModel: creneauViewModel)
        self.intent.addListObserver(viewModel: creneauxViewModel)
    }

    var body: some View {
        VStack {
            Text("Debut : \(creneauViewModel.debut)")
            Text("Fin : \(creneauViewModel.fin)")
            ZonesView(festival: $festival, creneau: $creneauViewModel.copyModel.id, opened: $opened)
        }
        .toast(isPresenting: $showingAlert, alert: {
            AlertToast(displayMode: .hud, type: .complete(.green), title: textAlert)
        }, completion: {
            showingAlert = false
        })
        .toast(isPresenting: $errorAlert, alert: {
            AlertToast(displayMode: .hud, type: .error(.red), title: textAlert)
        }, completion: {
            creneauViewModel.error = .noError
            errorAlert = false
        })   
    }
}