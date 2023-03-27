import Foundation

struct FestivalDAO {

    var API: String
    
    init(api:String){
        self.API = api + "/festival"
    }
    
    func getAll() async -> [Festival] {
        let data:Result<[FestivalDTO],APIError> = await URLSession.shared.getJSON(from: URL(string: self.API)!)
        switch data {
            case .success(let DTO):
                var festivalList: [Festival] = DTO.compactMap { 
                    Festival(festivalDTO: $0) 
                }
                return festivalList
            case .failure(let err):
                print("Erreur : \(err)")
                return []
        }
    }
    
    func create(festival: Festival) async -> Result<Int,APIError> {
        let festivalDTO = FestivalDTO(festival: festival) 
        return await URLSession.shared.create(from: URL(string: self.API)!, element: festivalDTO)
    }
    
    func update(festival: Festival) async -> Result<Bool,APIError> {
        let festivalDTO = FestivalDTO(festival: festival)
        return await URLSession.shared.update(from: URL(string: self.API + "/" + String(festival.id))!, element: festivalDTO)
    }
    
    func delete(id: Int) async -> Result<Bool,APIError>{
        return await URLSession.shared.delete(from: URL(string: self.API + "/" + String(id))!, id: id)
    }
}
