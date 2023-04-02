import SwiftUI
import AlertToast

struct BenevolesTravailView: View {

    @ObservedObject var benevolesViewModel : BenevolesViewModel = BenevolesViewModel(benevoles: [])
    @State private var searchText = ""
    @State private var dataIsLoad = false
    let url: String
    let maximum: Int
    let zone: Int
    let creneau: Int
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
        ScrollView {
        VStack {
            if (UserSession.shared.user != nil && benevolesViewModel.benevoles.count < maximum && !benevolesViewModel.benevoles.contains(where: { $0.id == UserSession.shared.user!.id })) {
                Button("Participer") {
                    Task {
                        let data = await API.travailDAO().create(travail: Travail(id: 0, benevole: UserSession.shared.user!.id, zone: zone, creneau: creneau))
                    }
                }
            }
            if (UserSession.shared.user != nil && benevolesViewModel.benevoles.contains(where: { $0.id == UserSession.shared.user!.id })) {
                Button("Quitter") {
                    Task {
                        let data = await API.travailDAO().delete(benevole: UserSession.shared.user!.id, creneau: creneau, zone: zone)
                    }
                }
            }
            NavigationView {
                VStack{
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
    }
    
    func loadData(){
        Task{
            self.benevolesViewModel.benevoles = await API.benevoleDAO().getAll(url: url)
            dataIsLoad = true
        }
    }
}