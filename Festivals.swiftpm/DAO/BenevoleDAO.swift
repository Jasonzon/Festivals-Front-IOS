import Foundation

struct BenevoleDAO {

    var API: String
    
    init(api:String){
        self.API = api + "/benevole"
    }
    
    func getAll() async -> [BenevoleDTO] {
        let data:Result<[BenevoleDTO],APIError> = await URLSession.shared.getJSON(from: URL(string: self.API)!)
        switch data {
            case .success(let DTO):
                var benevoleList: [Benevole] = []
                DTO.forEach { element in
                    if let notNilElment = Benevole(benevoleDTO: element) {
                        ingredientList.append(notNilElment)
                    }
                }
                return ingredientList
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
}
