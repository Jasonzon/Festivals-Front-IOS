import SwiftUI
import AlertToast

struct ZonesView: View {

    @ObservedObject var zonesViewModel : ZonesViewModel = ZonesViewModel(zones: [])
    @State private var searchText = ""
    @State private var createZone = false
    @State private var dataIsLoad = false
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
        VStack{
            NavigationView {
                VStack{
                    NavigationLink(destination:ZoneCreateView(zonesViewModel: zonesViewModel), isActive: $createZone){}
                    List{
                        ForEach(searchResults, id: \.id) { element in
                            NavigationLink(destination: ZonesView(zone: element, zonesViewModel: zonesViewModel)) {
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
                            createZone = true
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
    
    func loadData(){
        Task {
            let zoneDTOs = await API.zoneDAO().getAll()
            self.zonesViewModel.zones = zoneDTOs.map {
                Zone(zoneDTO: $0)
            }
        }
    }
}