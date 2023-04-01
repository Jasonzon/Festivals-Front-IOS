import Foundation

struct JourDTO: Codable {
    
    let id: Int
    let name: String
    let debut: Date
    let fin: Date
    let date: Date
    let festival: Int

    init(id: Int, name: String, debut: Date, fin: Date, date: Date, festival: Int) {
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

    func serialize() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["name"] = self.name
        dict["debut"] = self.debut.timeIntervalSince1970
        dict["fin"] = self.fin.timeIntervalSince1970
        dict["date"] = self.date.timeIntervalSince1970
        dict["festival"] = self.festival
        return dict
    }
}