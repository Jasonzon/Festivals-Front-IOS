import Foundation

struct ZoneDAO {
    
    var API: String
    
    init(api:String){
        self.API = api + "/zone"
    }
    
    func getAll(completion: @escaping ([ZoneDTO]?) -> Void) {
        guard let url = URL(string: API) else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let zones = try decoder.decode([ZoneDTO].self, from: data)
                completion(zones)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func create(zone: ZoneDTO, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: API) else {
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(zone)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    completion(httpResponse.statusCode == 201)
                } else {
                    completion(false)
                }
            }
            task.resume()
        } catch {
            completion(false)
        }
    }
    
    func update(zone: ZoneDTO, completion: @escaping (Bool) -> Void) {
        guard let id = zone.id, let url = URL(string: "\(API)/\(id)") else {
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(zone)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    completion(httpResponse.statusCode == 200)
                } else {
                    completion(false)
                }
            }
            task.resume()
        } catch {
            completion(false)
        }
    }
    
    func delete(zoneId: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(API)/\(zoneId)") else {
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                completion(httpResponse.statusCode == 204)
            } else {
                completion(false)
            }
        }
        task.resume()
    }
}
