import SwiftUI
import AlertToast

struct JoursView: View {

    @ObservedObject var joursViewModel : JoursViewModel = JoursViewModel(jours: [])
    @Binding var festivalId: Int
    @State private var searchText = ""
    @State private var createJour = false
    @State private var dataIsLoad = false
    private var searchResults: [Jour] {
        if searchText.isEmpty {
            return joursViewModel.jours
        } 
        else {
            return joursViewModel.jours.filter {
                $0.name.uppercased().contains(searchText.uppercased()) 
            }
        }
    }
    
    var body: some View {
        VStack{
            NavigationView {
                VStack {
                    if (UserSession.shared.user?.role == .Admin) {
                        NavigationLink(destination: JourCreateView(joursViewModel: joursViewModel), isActive: $createJour){}
                    }
                    List {
                        ForEach(searchResults, id: \.id) { element in
                            NavigationLink(destination: JourView(jour: element, joursViewModel: joursViewModel)) {
                                HStack {
                                    Text(element.name)
                                }
                            }
                        }  
                    }
                    .searchable(text: $searchText)
                    .onAppear() {
                        loadData()
                    }
                    .toolbar {
                        Button("+") {
                            createJour = true
                        }
                    }
                    .navigationTitle("Jours")
                }
            }
            .overlay(Group {
                ProgressView().opacity(dataIsLoad ? 0 : 1)
            })
            .toast(isPresenting: $joursViewModel.alert, alert: {
                AlertToast(displayMode: .hud, type: .complete(.green), title: joursViewModel.textAlert)
            }, completion: {
                joursViewModel.alert = false
            })
        }
    }
    
    func loadData(){
        Task{
            self.joursViewModel.jours = await API.jourDAO().getAll(url: "/festival/\(festivalId)")
            dataIsLoad = true
        }
    }
}