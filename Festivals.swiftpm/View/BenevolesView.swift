import SwiftUI
import AlertToast

struct BenevolesView: View {

    @ObservedObject var benevolesViewModel : BenevolesViewModel = BenevolesViewModel(benevoles: [])
    @State private var searchText = ""
    @State private var createBenevole = false
    @State private var dataIsLoad = false
    private var searchResults: [Benevole] {
        if searchText.isEmpty {
            return benevolesViewModel.benevoles
        } 
        else {
            return benevolesViewModel.benevoles.filter {
                $0.nom.uppercased().contains(searchText.uppercased()) || $0.prenom.uppercased().contains(searchText.uppercased()) || $0.mail.uppercased().contains(searchText.uppercased())
            }
        }
    }
    
    var body: some View {
        VStack{
            NavigationView {
                VStack{
                    NavigationLink(destination:BenevoleCreateView(benevolesViewModel: benevolesViewModel), isActive: $createBenevole){}
                    List {
                        ForEach(searchResults, id: \.id) { element in
                            NavigationLink(destination:BenevoleView(benevole: element, benevolesViewModel: benevolesViewModel)) {
                                HStack {
                                    Text(element.prenom + " " + element.nom)
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
                            createBenevole = true
                        }
                    }
                    .navigationTitle("Bénévoles")
                }
            }
            .overlay(Group {
                ProgressView().opacity(dataIsLoad ? 0 : 1)
            })
            .toast(isPresenting: $benevolesViewModel.alert, alert: {
                AlertToast(displayMode: .hud, type: .complete(.green), title: benevolesViewModel.textAlert)
            }, completion: {
                benevolesViewModel.alert = false
            })
        }
    }
    
    func loadData(){
        Task{
            self.benevolesViewModel.benevoles = await API.benevoleDAO().getAll()
            dataIsLoad = true
        }
    }
}