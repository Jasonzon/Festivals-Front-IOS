import SwiftUI
import AlertToast

struct FestivalsView: View {

    @ObservedObject var festivalsViewModel : FestivalsViewModel = FestivalsViewModel(festivals: [])
    @State private var searchText = ""
    @State private var createFestival = false
    @State private var dataIsLoad = false
    private var searchResults: [Festival] {
        if searchText.isEmpty {
            return festivalsViewModel.festivals
        } 
        else {
            return festivalsViewModel.festivals.filter {
                $0.name.uppercased().contains(searchText.uppercased()) 
            }
        }
    }
    
    var body: some View {
        VStack{
            NavigationView {
                VStack {
                    if (UserSession.shared.user?.role == .Admin) {
                        NavigationLink(destination: FestivalCreateView(festivalsViewModel: festivalsViewModel), isActive: $createFestival){}
                    }
                    List {
                        ForEach(searchResults, id: \.id) { element in
                            NavigationLink(destination: FestivalView(festival: element, festivalsViewModel: festivalsViewModel)) {
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
                            createFestival = true
                        }
                    }
                    .navigationTitle("Festivals")
                }
            }
            .overlay(Group {
                ProgressView().opacity(dataIsLoad ? 0 : 1)
            })
            .toast(isPresenting: $festivalsViewModel.alert, alert: {
                AlertToast(displayMode: .hud, type: .complete(.green), title: festivalsViewModel.textAlert)
            }, completion: {
                festivalsViewModel.alert = false
            })
        }
    }
    
    func loadData(){
        Task{
            self.festivalsViewModel.festivals = await API.festivalDAO().getAll()
            dataIsLoad = true
        }
    }
}