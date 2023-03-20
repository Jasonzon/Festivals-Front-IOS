import SwiftUI
import AlertToast

struct CreneauxView: View {

    @ObservedObject var creneauxViewModel : CreneauxViewModel = CreneauxViewModel(creneaux: [])
    @State private var searchText = ""
    @State private var createCreneau = false
    @State private var dataIsLoad = false
    private var searchResults: [Creneau] {
        if searchText.isEmpty {
            return creneauxViewModel.creneaux
        } 
        else {
            return creneauxViewModel.creneaux.filter {
                $0.debut.uppercased().contains(searchText.uppercased()) || $0.fin.uppercased().contains(searchText.uppercased()) 
            }
        }
    }
    
    var body: some View {
        VStack{
            NavigationView {
                VStack {
                    if (UserSession.shared.user?.role == .Admin) {
                        NavigationLink(destination: CreneauCreateView(creneauxViewModel: creneauxViewModel), isActive: $createCreneau){}
                    }
                    List{
                        ForEach(searchResults, id: \.id) { element in
                            NavigationLink(destination: CreneauView(creneau: element, creneauxViewModel: creneauxViewModel)) {
                                HStack {
                                    Text(element.debut + " " + element.fin)
                                }
                            }
                        }  
                    }
                    .searchable(text: $searchText)
                    .onAppear() {
                        loadData()
                    }
                    .toolbar {
                        if (UserSession.shared.user?.role == .Admin) {
                            Button("+") {
                                createCreneau = true
                            }
                        }
                    }
                    .navigationTitle("Creneaux")
                }
            }
            .overlay(Group {
                ProgressView().opacity(dataIsLoad ? 0 : 1)
            })
            .toast(isPresenting: $creneauxViewModel.alert, alert: {
                AlertToast(displayMode: .hud, type: .complete(.green), title: creneauxViewModel.textAlert)
            }, completion: {
                creneauxViewModel.alert = false
            })
        }
    }
    
    func loadData(){
        Task{
            self.creneauxViewModel.creneaux = await API.creneauDAO().getAll()
            dataIsLoad = true
        }
    }
}