import Foundation

struct JeuDTO: Codable {
    
    let id: Int
    let name: String
    let type: JeuType

    init(id: Int, name: String, type: JeuType) {
        self.id = id
        self.name = name
        self.type = type
    }

    init(jeu: Jeu) {
        self.id = jeu.id
        self.name = jeu.name
        self.type = jeu.type
    }

    enum CodingKeys: String, CodingKey {
        case id = "jeu_id"
        case name = "jeu_name"
        case type = "jeu_type"
    }
}