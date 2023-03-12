import Foundation

struct JeuDTO: Codable {
    
    let id: String?
    let name: String
    let type: String

    init(id: String, name: String, type: JeuType) {
        self.id = id
        self.name = name
        self.type = type.rawValue
    }

    enum CodingKeys: String, CodingKey {
        case id = "jeu_id"
        case name = "jeu_name"
        case type = "jeu_type"
    }
}