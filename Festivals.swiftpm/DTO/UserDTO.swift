import Foundation

struct UserDTO: Codable {

    let id: String?
    let mail: String
    let nom: String
    let prenom: String
    let role: UserRole
    let password: String?

    init (id: String, mail: String, nom: String, prenom: String, role: UserRole, password: String) {
        self.id = id
        self.mail = mail
        self.nom = nom
        self.prenom = prenom
        self.role = role
        self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "polyuser_id"
        case mail = "polyuser_mail"
        case nom = "polyuser_nom"
        case prenom = "polyuser_prenom"
        case role = "polyuser_role"
        case password = "polyuser_password"
    }
}