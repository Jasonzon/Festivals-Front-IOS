import Foundation

struct CreneauDAO {

    var API: String
    
    init(api:String){
        self.API = api + "/creneau"
    }
    
    func getAll(url: String) async -> [Creneau] {
        let data:Result<[CreneauDTO],APIError> = await URLSession.shared.getJSON(from: URL(string: self.API + url)!)
        switch data {
            case .success(let DTO):
                var creneauList: [Creneau] = DTO.compactMap { 
                    Creneau(creneauDTO: $0) 
                }
                return creneauList
            case .failure(let err):
                print("Erreur : \(err)")
                return []
        }
    }
    
    func create(creneau: Creneau) async -> Result<Int,APIError> {
        let creneauDTO = CreneauDTO(creneau: creneau)
        return await URLSession.shared.create(from: URL(string: self.API)!, element: creneauDTO)
    }
    
    func update(creneau: Creneau) async -> Result<Bool,APIError> {
        let creneauDTO = CreneauDTO(creneau: creneau)
        return await URLSession.shared.update(from: URL(string: self.API + "/" + String(creneau.id))!, element: creneauDTO)
    }
    
    func delete(id: Int) async -> Result<Bool,APIError>{
        return await URLSession.shared.delete(from: URL(string: self.API + "/" + String(id))!)
    }
}
