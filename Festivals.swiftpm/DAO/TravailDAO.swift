import Foundation

struct TravailDAO {

    var API: String
    
    init(api:String){
        self.API = api + "/travail"
    }
    
    func getAll() async -> [Travail] {
        let data:Result<[TravailDTO],APIError> = await URLSession.shared.getJSON(from: URL(string: self.API)!)
        switch data {
            case .success(let DTO):
                var travailList: [Travail] = DTO.compactMap { 
                    Travail(travailDTO: $0) 
                }
                return travailList
            case .failure(let err):
                print("Erreur : \(err)")
                return []
        }
    }
    
    func create(travail: Travail) async -> Result<Int,APIError> {
        let travailDTO = TravailDTO(travail: travail) 
        return await URLSession.shared.create(from: URL(string: self.API)!, element: travailDTO)
    }
    
    func delete(id: Int) async -> Result<Bool,APIError>{
        return await URLSession.shared.delete(from: URL(string: self.API + "/" + String(id))!)
    }
}
