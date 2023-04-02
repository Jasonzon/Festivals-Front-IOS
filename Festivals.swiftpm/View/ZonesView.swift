import SwiftUI
import AlertToast

struct ZonesView: View {

    @ObservedObject var zonesViewModel : ZonesViewModel = ZonesViewModel(zones: [])
    @Binding var festival: Int
    @State private var searchText = ""
    @State private var createZone = false
    @State private var dataIsLoad = false
    @Binding var creneau: Int
    private var searchResults: [Zone] {
        if searchText.isEmpty {
            return zonesViewModel.zones
        } 
        else {
            return zonesViewModel.zones.filter {
                $0.name.uppercased().contains(searchText.uppercased()) 
            }
        }
    }
    
    var body: some View {
        ScrollView {
        VStack{
            NavigationView {
                VStack {
                    if (UserSession.shared.user?.role == .Admin) {
                        NavigationLink(destination:ZoneCreateView(zonesViewModel: zonesViewModel, festival: festival), isActive: $createZone){}
                    }
                    List{
                        ForEach(searchResults, id: \.id) { element in
                            NavigationLink(destination: ZoneView(zone: element, zonesViewModel: zonesViewModel, creneau: $creneau)) {
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
                        if (UserSession.shared.user?.role == .Admin) {
                            Button("+") {
                                createZone = true
                            }
                        }
                    }
                    .navigationTitle("Zones")
                }
            }
            .overlay(Group {
                ProgressView().opacity(dataIsLoad ? 0 : 1)
            })
            .toast(isPresenting: $zonesViewModel.alert, alert: {
                AlertToast(displayMode: .hud, type: .complete(.green), title: zonesViewModel.textAlert)
            }, completion: {
                zonesViewModel.alert = false
            })
        }
        }
    }
    
    func loadData(){
        Task{
            self.zonesViewModel.zones = await API.zoneDAO().getAll(url: "/festival/\(festival)")
            dataIsLoad = true
        }
    }
}