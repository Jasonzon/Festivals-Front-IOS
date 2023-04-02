import Foundation

struct CreneauDTO: Codable {

    let id: Int
    let debut: String
    let fin: String
    let jour: Int

    init(id: Int, debut: String, fin: String, jour: Int) {
        self.id = id
        self.debut = debut
        self.fin = fin
        self.jour = jour
    }

    init(creneau: Creneau) {
        self.id = creneau.id
        self.debut = creneau.debut
        self.fin = creneau.fin
        self.jour = creneau.jour
    }

    enum CodingKeys: String, CodingKey {
        case id = "creneau_id"
        case debut = "creneau_debut"
        case fin = "creneau_fin"
        case jour = "creneau_jour"
    }
}