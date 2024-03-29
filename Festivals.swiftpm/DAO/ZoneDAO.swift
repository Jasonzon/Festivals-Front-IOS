import Foundation

struct ZoneDAO {

    var API: String
    
    init(api:String){
        self.API = api + "/zone"
    }
    
    func getAll(url: String) async -> [Zone] {
        let data:Result<[ZoneDTO],APIError> = await URLSession.shared.getJSON(from: URL(string: self.API + url)!)
        switch data {
            case .success(let DTO):
                var zoneList: [Zone] = DTO.compactMap { 
                    Zone(zoneDTO: $0) 
                }
                return zoneList
            case .failure(let err):
                print("Erreur : \(err)")
                return []
        }
    }
    
    func create(zone: Zone) async -> Result<Int,APIError> {
        let zoneDTO = ZoneDTO(zone: zone)
        return await URLSession.shared.create(from: URL(string: self.API)!, element: zoneDTO)
    }
    
    func update(zone: Zone) async -> Result<Bool,APIError> {
        let zoneDTO = ZoneDTO(zone: zone)
        return await URLSession.shared.update(from: URL(string: self.API + "/" + String(zone.id))!, element: zoneDTO)
    }
    
    func delete(id: Int) async -> Result<Bool,APIError>{
        return await URLSession.shared.delete(from: URL(string: self.API + "/" + String(id))!)
    }
}
