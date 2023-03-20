import Foundation

struct JourDTO: Codable {
    
    let id: Int
    let name: String
    let debut: String
    let fin: String
    let date: String

    init(id: Int, name: String, debut: String, fin: String, date: String) {
        self.id = id
        self.name = name
        self.debut = debut
        self.fin = fin
        self.date = date
    }

    init(jour: Jour) {
        self.id = jour.id
        self.name = jour.name
        self.debut = jour.debut
        self.fin = jour.fin
        self.date = jour.date
    }

    enum CodingKeys: String, CodingKey {
        case id = "jour_id"
        case name = "jour_name"
        case debut = "jour_debut"
        case fin = "jour_fin"
        case date = "jour_date"
    }
}