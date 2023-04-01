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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let isoString = dateFormatter.string(from: jour.date)
        print(isoString)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "HH:mm"
        let timeString = dateFormatter2.string(from: jour.debut)
        print(timeString)
        let timeString2 = dateFormatter2.string(from: jour.fin)
        print(timeString2)
        return await URLSession.shared.create(from: URL(string: self.API)!, element: jourDTO)
    }
    
    func update(jour: Jour) async -> Result<Bool,APIError> {
        let jourDTO = JourDTO(jour: jour)
        return await URLSession.shared.update(from: URL(string: self.API + "/" + String(jour.id))!, element: jourDTO)
    }
    
    func delete(id: Int) async -> Result<Bool,APIError>{
        return await URLSession.shared.delete(from: URL(string: self.API + "/" + String(id))!)
    }
}
