import Foundation

struct BenevoleDAO {

    var API: String
    
    init(api:String){
        self.API = api + "/benevole"
    }
    
    func getAll() async -> Result<[BenevoleDTO], APIError> {
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
                let benevoles = try decoder.decode([BenevoleDTO].self, from: data)
                return .success(benevoles)
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
    
    func create(benevole: BenevoleDTO) async -> Result<Bool,APIError> {
        guard let url = URL(string: API) else {
            return .failure(.urlNotFound(API))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(benevole)
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
    
    func update(benevole: BenevoleDTO) async -> Result<Bool,APIError> {
        guard let id = benevole.id, let url = URL(string: "\(API)/\(id)") else {
            return .failure(.urlNotFound(url))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(benevole)
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
    
    func delete(benevoleId: String) async -> Result<Bool,APIError> {
        guard let url = URL(string: "\(API)/\(benevoleId)") else {
            return .failure(.urlNotFound(url))
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
