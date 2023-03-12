import Foundation

struct BenevoleDAO {
    
    var API: String

    init(api:String){
        self.API = api + "/benevole"
    }
    
    func getAll(completion: @escaping ([Benevole]?) -> Void) {
        let url = URL(string: self.API)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            do {
                let benevolesDTO = try JSONDecoder().decode([BenevoleDTO].self, from: data)
                let benevoles = benevolesDTO.map { $0.toBenevole() }
                completion(benevoles)
            } catch {
                print("Error decoding benevoles: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    func create(benevole: Benevole, completion: @escaping (Bool) -> Void) {
        let url = URL(string: self.API)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let benevoleDTO = BenevoleDTO(from: benevole)
            let jsonData = try JSONEncoder().encode(benevoleDTO)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let _ = data else {
                    completion(false)
                    return
                }
                completion(true)
            }.resume()
        } catch {
            print("Error encoding benevole: \(error)")
            completion(false)
        }
    }
    
    func update(benevole: Benevole, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(self.API)/\(benevole.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let benevoleDTO = BenevoleDTO(from: benevole)
            let jsonData = try JSONEncoder().encode(benevoleDTO)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let _ = data else {
                    completion(false)
                    return
                }
                completion(true)
            }.resume()
        } catch {
            print("Error encoding benevole: \(error)")
            completion(false)
        }
    }
    
    func delete(benevole: Benevole, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(self.API)/\(benevole.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let _ = data else {
                completion(false)
                return
            }
            completion(true)
        }.resume()
    }
}
