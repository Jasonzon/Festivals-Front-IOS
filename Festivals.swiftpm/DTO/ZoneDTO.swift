import Foundation

struct ZoneDTO: Codable {
    
    let id: Int
    let name: String
    let benevoles: Int
    let festival: Int

    init(id: Int, name: String, benevoles: Int, festival: Int) {
        self.id = id
        self.name = name
        self.benevoles = benevoles
        self.festival = festival
    }

    init(zone: Zone) {
        self.id = zone.id
        self.name = zone.name
        self.benevoles = zone.benevoles
        self.festival = zone.festival
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "zone_id"
        case name = "zone_name"
        case benevoles = "zone_benevoles"
        case festival = "zone_festival"
    }
}
