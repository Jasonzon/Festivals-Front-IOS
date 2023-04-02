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
    
    func delete(benevole: Int, creneau: Int, zone: Int) async -> Result<Bool,APIError>{
        var request :URLRequest = URLRequest(url: URL(string: self.API + "/query?creneau=\(creneau)&benevole=\(benevole)&zone=\(zone)"))
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "token")
        do{
            let (_,response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                return .success(true)
            }
            else {
                return .failure(.httpResponseError(httpResponse.statusCode))
            }
        }
        catch{
            return .failure(.urlNotFound(url.absoluteString))
        }
    }
}
