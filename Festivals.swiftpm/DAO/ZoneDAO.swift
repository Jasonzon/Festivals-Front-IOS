import Foundation

struct ZoneDAO {

    var API: String
    
    init(api:String){
        self.API = api + "/zone"
    }
    
    func getAll() async -> [ZoneDTO] {
        let data:Result<[ZoneDTO],APIError> = await URLSession.shared.getJSON(from: URL(string: self.API)!)
        switch data {
            case .success(let DTO):
                var zoneList: [Zone] = []
                DTO.forEach { element in
                    if let notNilElment = Zone(zoneDTO: element) {
                        zoneList.append(notNilElment)
                    }
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
        return await URLSession.shared.update(from: URL(string: self.API)!, element: zoneDTO)
    }
    
    func delete(id: Int) async -> Result<Bool,APIError>{
        return await URLSession.shared.delete(from: URL(string: self.API)!, id: id)
    }
}
