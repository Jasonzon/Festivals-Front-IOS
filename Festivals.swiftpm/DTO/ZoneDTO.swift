import Foundation

struct ZoneDTO: Codable {
    
    let id: Int
    let name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

    init(zone: Zone) {
        self.id = zone.id
        self.name = zone.name
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "zone_id"
        case name = "zone_name"
    }
}
