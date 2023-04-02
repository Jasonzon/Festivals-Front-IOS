import Foundation

struct IdDTO: Codable {

    var ID:Int

    init(ID:Int){
        self.ID = ID
    }
}

extension URLSession {

    func getJSON<T:Decodable>(from url:URL) async -> Result<T, APIError>{
        guard let(data,_) = try? await data(from: url) else {
            return .failure(.urlNotFound(url.absoluteString))
        }
        guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            print(String(decoding: data,as: UTF8.self))
            return .failure(.JsonDecodingFailed)
        }
        return .success(decoded)
    }

    func create<T:Encodable>(from url:URL,element:T)async -> Result<Int, APIError>{
        print("ON EST LA")
        guard let encoded :Data = try? JSONEncoder().encode(element)else {
            return .failure(.JsonEncodingFailed)
        }
        var request :URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = UserDefaults.standard.string(forKey: "token") {
            request.addValue(token, forHTTPHeaderField: "token")
        }
        do {
            let (data,response) = try await upload(for: request, from: encoded, delegate: nil)
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                guard let id  = try? JSONDecoder().decode(IdDTO.self, from: data) else{
                    return .failure(.JsonDecodingFailed)
                }
                return .success(id.ID)
            }
            else {
                return .failure(.httpResponseError(httpResponse.statusCode))
            }       
        }
        catch{
            return .failure(.urlNotFound(url.absoluteString))
        }
    }

    func update<T:Encodable>(from url:URL,element:T)async -> Result<Bool, APIError>{
        guard let encoded :Data = try? JSONEncoder().encode(element)else {
            return .failure(.JsonEncodingFailed)
        }
        var request :URLRequest = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "token")
        do {
            let (_,response) = try await URLSession.shared.upload(for: request, from: encoded, delegate: nil)
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

    func delete(from url:URL)async -> Result<Bool, APIError>{
        var request :URLRequest = URLRequest(url: url)
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