import Foundation

struct BenevoleDAO {

    var API: String
    
    init(api:String){
        self.API = api + "/benevole"
    }
    
    func getAll() async -> [Benevole] {
        let data:Result<[BenevoleDTO],APIError> = await URLSession.shared.getJSON(from: URL(string: self.API)!)
        switch data {
            case .success(let DTO):
                var benevoleList: [Benevole] = DTO.compactMap { 
                    Benevole(benevoleDTO: $0) 
                }
                return benevoleList
            case .failure(let err):
                print("Erreur : \(err)")
                return []
        }
    }
    
    func create(benevole: Benevole) async -> Result<Int,APIError> {
        let benevoleDTO = BenevoleDTO(benevole: benevole) 
        return await URLSession.shared.create(from: URL(string: self.API)!, element: benevoleDTO)
    }
    
    func update(benevole: Benevole) async -> Result<Bool,APIError> {
        let benevoleDTO = BenevoleDTO(benevole: benevole)
        return await URLSession.shared.update(from: URL(string: self.API)!, element: benevoleDTO)
    }
    
    func delete(id: Int) async -> Result<Bool,APIError>{
        return await URLSession.shared.delete(from: URL(string: self.API)!, id: id)
    }

    /*
    func auth(token: String) async -> Result<Bool,APIError> {
        return await URLSession.shared.auth(from: URL(string: self.API + "/auth")!, token: token)
    }*/
}
