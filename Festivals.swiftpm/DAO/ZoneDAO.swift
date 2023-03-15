import Foundation

struct ZoneDAO {

    var API: String
    
    init(api:String){
        self.API = api + "/zone"
    }
    
    func getAll() async -> Result<[ZoneDTO], APIError> {
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
                let zones = try decoder.decode([ZoneDTO].self, from: data)
                return .success(zones)
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
    
    func create(zone: ZoneDTO) async -> Result<Bool,APIError> {
        guard let url = URL(string: API) else {
            return .failure(.urlNotFound(API))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(zone)
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
    
    func update(zone: ZoneDTO) async -> Result<Bool,APIError> {
        guard let id = zone.id, let url = URL(string: "\(API)/\(id)") else {
            return .failure(.urlNotFound(url))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(zone)
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
    
    func delete(zoneId: String) async -> Result<Bool,APIError> {
        guard let url = URL(string: "\(API)/\(zoneId)") else {
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
