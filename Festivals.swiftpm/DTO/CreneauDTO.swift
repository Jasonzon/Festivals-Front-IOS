struct CreneauDTO: Codable {
    
    let id: String?
    let debut: String
    let fin: String

    init(id: String, debut: String, fin: String) {
        self.id = id
        self.debut = debut
        self.fin = fin
    }

    enum CodingKeys: String, CodingKey {
        case id = "creneau_id"
        case debut = "creneau_debut"
        case fin = "creneau_fin"
    }
}