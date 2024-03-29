import SwiftUI
import AlertToast

struct CreneauxView: View {

    @ObservedObject var creneauxViewModel : CreneauxViewModel = CreneauxViewModel(creneaux: [])
    @Binding var jour: Jour
    @Binding var festival: Int
    @Binding var opened: Bool
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
        ScrollView {
        VStack{
            NavigationView {
                VStack {
                    List{
                        ForEach(searchResults, id: \.id) { element in
                            NavigationLink(destination: CreneauView(creneau: element, creneauxViewModel: creneauxViewModel, festival: $festival, opened: $opened)) {
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
    }
    
    func loadData(){
        Task{
            self.creneauxViewModel.creneaux = await API.creneauDAO().getAll(url: "/jour/\(jour.id)")
            dataIsLoad = true
        }
    }
}