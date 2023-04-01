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
    
    func create(jour: Jour) async -> Result<Int, APIError>{
        let url: URL = URL(string: self.API)!
        let serialized = JourDTO(jour: jour).serialize()!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "token")
        do {
            let (data,response) = try await URLSession.shared.upload(for: request, from: serialized, delegate: nil)
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                guard let id = try? JSONDecoder().decode(IdDTO.self, from: data) else {
                    return .failure(.JsonDecodingFailed)
                }
                return .success(id.ID)
            } else {
                return .failure(.httpResponseError(httpResponse.statusCode))
            }       
        } catch {
            return .failure(.urlNotFound(url.absoluteString))
        }
    }
    
    func update(jour: Jour) async -> Result<Bool,APIError> {
        let jourDTO = JourDTO(jour: jour)
        return await URLSession.shared.update(from: URL(string: self.API + "/" + String(jour.id))!, element: jourDTO)
    }
    
    func delete(id: Int) async -> Result<Bool,APIError>{
        return await URLSession.shared.delete(from: URL(string: self.API + "/" + String(id))!)
    }
}
