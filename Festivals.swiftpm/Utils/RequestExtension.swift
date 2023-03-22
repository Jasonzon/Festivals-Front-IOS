import Foundation

struct IdDTO: Codable {

    var ID:Int

    init(ID:Int){
        self.ID = ID
    }
}

struct BenevoleId: Codable {
    let id: Int
}

struct Ben: Codable {
    let token: String
    let benevole: Benevole

    init(token: String, benevole: Benevole) {
        self.token = token
        self.benevole = benevole
    }
}

struct Connect: Codable {
    let mail: String
    let password: String
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
        guard let encoded :Data = try? JSONEncoder().encode(element)else {
            return .failure(.JsonEncodingFailed)
        }
        var request :URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
        do {
            let (_,response) = try await upload(for: request, from: encoded, delegate: nil)
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

    func delete(from url:URL,id:Int)async -> Result<Bool, APIError>{
        guard let encoded :Data = try? JSONEncoder().encode(IdDTO(ID: id))else {
            return .failure(.JsonEncodingFailed)
        }
        var request :URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let (_,response) = try await upload(for: request, from: encoded, delegate: nil)
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

    func auth(from url: URL,token: String) async -> Result<Int, APIError> {
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "token")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as! HTTPURLResponse
            guard httpResponse.statusCode == 200 else {
                return .failure(.httpResponseError(httpResponse.statusCode))
            }
            let decoder = JSONDecoder()
            let benevole = try decoder.decode(BenevoleId.self, from: data)
            return .success(benevole.id)
        }
        catch {
            return .failure(.urlNotFound(url.absoluteString))
        }
    }

    func connect(from url:URL, mail: String, password: String) async -> Result<Ben, APIError>{
        guard let encoded :Data = try? JSONEncoder().encode(Connect(mail: mail, password: password))else {
            return .failure(.JsonEncodingFailed)
        }
        var request :URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let (data,response) = try await upload(for: request, from: encoded, delegate: nil)
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                guard let ben = try? JSONDecoder().decode(Ben.self, from: data) else{
                    return .failure(.JsonDecodingFailed)
                }
                return .success(ben)
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