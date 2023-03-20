import Foundation

struct FestivalDTO: Codable {
    
    let id: Int
    let name: String
    let year: String
    let opened: Bool

    init(id: Int, name: String, year: String, opened: Bool) {
        self.id = id
        self.name = name
        self.year = year
        self.opened = opened
    }

    init(festival: Festival) {
        self.id = festival.id
        self.name = festival.name
        self.year = festival.year
        self.opened = festival.opened
    }

    enum CodingKeys: String, CodingKey {
        case id = "festival_id"
        case name = "festival_name"
        case year = "festival_year"
        case opened = "festival_open"
    }
}