import Foundation

struct UserDAO {

    var API: String
    
    init(api:String){
        self.API = api + "/polyuser"
    }
    
    func getAll() async -> Result<[UserDTO], APIError> {
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
                let users = try decoder.decode([UserDTO].self, from: data)
                return .success(users)
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
    
    func create(user: UserDTO) async -> Result<Bool,APIError> {
        guard let url = URL(string: API) else {
            return .failure(.urlNotFound(API))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(user)
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
    
    func update(user: UserDTO) async -> Result<Bool,APIError> {
        guard let url = URL(string: "\(API)/\(user.id)") else {
            return .failure(.urlNotFound("\(API)/\(user.id)"))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(user)
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
    
    func delete(userId: String) async -> Result<Bool,APIError> {
        guard let url = URL(string: "\(API)/\(userId)") else {
            return .failure(.urlNotFound("\(API)/\(userId)"))
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
