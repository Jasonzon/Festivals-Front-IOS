import Foundation

struct BenevoleDTO: Codable {

    var id: String?
    let nom: String
    let prenom: String
    let mail: String

    init(id: String, nom: String, prenom: String, mail: String) {
        self.id = id
        self.nom = nom
        self.prenom = prenom
        self.mail = mail
    }

    enum CodingKeys: String, CodingKey {
        case id = "benevole_id"
        case nom = "benevole_nom"
        case prenom = "benevole_prenom"
        case mail = "benevole_mail"
    }
}