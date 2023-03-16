import SwiftUI
import AlertToast

struct JeuxView: View {

    @ObservedObject var jeuxViewModel : JeuxViewModel = JeuxViewModel(jeux: [])
    @State private var searchText = ""
    @State private var createJeu = false
    @State private var dataIsLoad = false
    var types: [String] = ["enfant","famille","initie","avance","expert"]
    private var searchResults: [Jeu] {
        if searchText.isEmpty {
            return jeuxViewModel.jeux
        } 
        else {
            return jeuxViewModel.jeux.filter {
                $0.name.uppercased().contains(searchText.uppercased()) 
            }
        }
    }
    
    var body: some View {
        VStack{
            NavigationView {
                VStack{
                    NavigationLink(destination:JeuCreateView(jeuxViewModel: jeuxViewModel), isActive: $createJeu){}
                    List{
                        ForEach(types, id: \.self) { type in
                            Section(type) {
                                ForEach(searchResults, id: \.id) { element in
                                    if (element.type == type) {
                                        NavigationLink(destination:JeuxView(jeu: element, jeuxViewModel: jeuxViewModel)) {
                                            HStack {
                                                Text(element.name)
                                            }
                                        }
                                    }
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
                            createJeu = true
                        }
                    }
                    .navigationTitle("Jeux")
                }
            }
            .overlay(Group {
                ProgressView().opacity(dataIsLoad ? 0 : 1)
            })
            .toast(isPresenting: $jeuxViewModel.alert, alert: {
                AlertToast(displayMode: .hud, type: .complete(.green), title: jeuxViewModel.textAlert)
            }, completion: {
                jeuxViewModel.alert = false
            })
        }
    }
    
    func loadData(){
        Task {
            let jeuDTOs = try? await API.jeuDAO().getAll()
            guard let jeuDTOs = jeuDTOs else {
                print("Failed to load data")
                return
            }
            self.jeuxViewModel.jeux = jeuDTOs.map {
                Jeu(jeuDTO: $0)
            }
        }
    }
}