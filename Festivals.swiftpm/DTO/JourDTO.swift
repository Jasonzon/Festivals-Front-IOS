import Foundation

struct JourDTO: Codable {
    
    let id: Int
    let name: String
    let debut: String
    let fin: String
    let date: String
    let festival: Int

    init(id: Int, name: String, debut: String, fin: String, date: String, festival: Int) {
        self.id = id
        self.name = name
        self.debut = debut
        self.fin = fin
        self.date = date
        self.festival = festival
    }

    init(jour: Jour) {
        self.id = jour.id
        self.name = jour.name
        self.debut = jour.debut
        self.fin = jour.fin
        self.date = jour.date
        self.festival = jour.festival
    }

    enum CodingKeys: String, CodingKey {
        case id = "jour_id"
        case name = "jour_name"
        case debut = "jour_debut"
        case fin = "jour_fin"
        case date = "jour_date"
        case festival = "jour_festival"
    }
}