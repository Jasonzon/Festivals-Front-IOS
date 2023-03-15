import Foundation

struct JeuDAO {

    var API: String
    
    init(api:String){
        self.API = api + "/jeu"
    }
    
    func getAll() async -> Result<[JeuDTO], APIError> {
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
                let jeux = try decoder.decode([JeuDTO].self, from: data)
                return .success(jeux)
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
    
    func create(jeu: JeuDTO) async -> Result<Bool,APIError> {
        guard let url = URL(string: API) else {
            return .failure(.urlNotFound(API))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(jeu)
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
    
    func update(jeu: JeuDTO) async -> Result<Bool,APIError> {
        guard let url = URL(string: "\(API)/\(jeu.id)") else {
            return .failure(.urlNotFound("\(API)/\(jeu.id)"))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(jeu)
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
    
    func delete(jeuId: String) async -> Result<Bool,APIError> {
        guard let url = URL(string: "\(API)/\(jeuId)") else {
            return .failure(.urlNotFound("\(API)/\(jeuId)"))
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
