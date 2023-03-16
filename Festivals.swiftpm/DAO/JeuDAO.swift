import Foundation

struct JeuDAO {

    var API: String
    
    init(api:String){
        self.API = api + "/jeu"
    }
    
    func getAll() async -> [Jeu] {
        let data:Result<[JeuDTO],APIError> = await URLSession.shared.getJSON(from: URL(string: self.API)!)
        switch data {
            case .success(let DTO):
                var jeuList: [Jeu] = []
                DTO.forEach { element in
                    if let notNilElment = Jeu(jeuDTO: element) {
                        ingredientList.append(notNilElment)
                    }
                }
                return jeuList
            case .failure(let err):
                print("Erreur : \(err)")
                return []
        }
    }
    
    func create(jeu: Jeu) async -> Result<Int,APIError> {
        let jeuDTO = JeuDTO(jeu: jeu) 
        return await URLSession.shared.create(from: URL(string: self.API)!, element: jeuDTO)
    }
    
    func update(jeu: Jeu) async -> Result<Bool,APIError> {
        let jeuDTO = JeuDTO(jeu: jeu)
        return await URLSession.shared.update(from: URL(string: self.API)!, element: jeuDTO)
    }
    
    func delete(id: Int) async -> Result<Bool,APIError>{
        return await URLSession.shared.delete(from: URL(string: self.API)!, id: id)
    }
}
