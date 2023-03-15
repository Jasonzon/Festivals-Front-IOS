import Foundation

struct CreneauDAO {

    var API: String
    
    init(api:String){
        self.API = api + "/creneau"
    }
    
    func getAll() async -> Result<[CreneauDTO], APIError> {
        guard let url = URL(string: API) else {
            return .failure(.urlNotFound(API))
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.unknown)
            }
            if httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                let creneaux = try decoder.decode([CreneauDTO].self, from: data)
                return .success(creneaux)
            } 
            else {
                return .failure(.httpResponseError(httpResponse.statusCode))
            }
        } 
        catch let error as APIError {
            return .failure(error)
        } 
        catch {
            return .failure(.unknown)
        }
    }
    
    func create(creneau: CreneauDTO) async -> Result<Bool,APIError> {
        guard let url = URL(string: API) else {
            return .failure(.urlNotFound(API))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(creneau)
            request.httpBody = jsonData
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    return .success(true)
                } 
                else {
                    return .failure(.httpResponseError(httpResponse.statusCode))
                }
            } 
            else {
                return .failure(.unknown)
            }
        }
        catch let error as APIError {
            return .failure(error)
        } 
        catch {
            return .failure(.unknown)
        }
    }
    
    func update(creneau: CreneauDTO) async -> Result<Bool,APIError> {
        guard let url = URL(string: "\(API)/\(creneau.id)") else {
            return .failure(.urlNotFound("\(API)/\(creneau.id)"))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(creneau)
            request.httpBody = jsonData
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    return .success(true)
                } 
                else {
                    return .failure(.httpResponseError(httpResponse.statusCode))
                }
            } 
            else {
                return .failure(.unknown)
            }
        } 
        catch let error as APIError {
            return .failure(error)
        }
        catch {
            return .failure(.unknown)
        }
    }
    
    func delete(creneauId: String) async -> Result<Bool,APIError> {
        guard let url = URL(string: "\(API)/\(creneauId)") else {
            return .failure(.urlNotFound("\(API)/\(creneauId)"))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    return .success(true)
                } 
                else {
                    return .failure(.httpResponseError(httpResponse.statusCode))
                }
            } 
            else {
                return .failure(.unknown)
            }
        }
        catch let error as APIError {
            return .failure(error)
        } 
        catch {
            return .failure(.unknown)
        }
    }
}
