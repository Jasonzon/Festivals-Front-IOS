import Foundation

struct JourDAO {

    var API: String
    
    init(api:String){
        self.API = api + "/jour"
    }
    
    func getAll(url: String) async -> [Jour] {
        let data:Result<[JourDTO],APIError> = await URLSession.shared.getJSON(from: URL(string: self.API + url)!)
        switch data {
            case .success(let DTO):
                var jourList: [Jour] = DTO.compactMap { 
                    Jour(jourDTO: $0) 
                }
                return jourList
            case .failure(let err):
                print("Erreur : \(err)")
                return []
        }
    }
    
    func create(jour: Jour) async -> Result<Int,APIError> {
        let jourDTO = JourDTO(jour: jour) 
        return await URLSession.shared.create(from: URL(string: self.API)!, element: jourDTO)
    }
    
    func update(jour: Jour) async -> Result<Bool,APIError> {
        let jourDTO = JourDTO(jour: jour)
        return await URLSession.shared.update(from: URL(string: self.API)!, element: jourDTO)
    }
    
    func delete(id: Int) async -> Result<Bool,APIError>{
        return await URLSession.shared.delete(from: URL(string: self.API)!, id: id)
    }
}
