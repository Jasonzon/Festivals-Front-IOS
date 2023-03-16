import Foundation

struct BenevoleDTO: Codable {

    var id: Int
    var nom: String
    var prenom: String
    var mail: String
    var role: UserRole
    var password: String

    init(id: Int, nom: String, prenom: String, mail: String, role: UserRole, password: String) {
        self.id = id
        self.nom = nom
        self.prenom = prenom
        self.mail = mail
        self.role = role
        self.password = password
    }

    init(benevole: Benevole) {
        self.id = benevole.id
        self.nom = benevole.nom
        self.prenom = benevole.prenom
        self.mail = benevole.mail
        self.role = benevole.role
        self.password = benevole.password
    }

    enum CodingKeys: String, CodingKey {
        case id = "benevole_id"
        case nom = "benevole_nom"
        case prenom = "benevole_prenom"
        case mail = "benevole_mail"
        case role = "benevole_role"
        case password = "benevole_password"
    }
}