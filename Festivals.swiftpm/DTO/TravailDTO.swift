import Foundation

struct TravailDTO: Codable {
    
    let id: Int
    let benevole: Int
    let zone: Int
    let creneau: Int

    init(id: Int, benevole: Int, zone: Int, creneau: Int) {
        self.id = id
        self.benevole = benevole
        self.zone = zone
        self.creneau = creneau
    }

    init(travail: Travail) {
        self.id = travail.id
        self.benevole = travail.benevole
        self.zone = travail.zone
        self.creneau = travail.creneau
    }

    enum CodingKeys: String, CodingKey {
        case id = "travail_id"
        case benevole = "travail_benevole"
        case zone = "travail_zone"
        case creneau = "travail_creneau"
    }
}