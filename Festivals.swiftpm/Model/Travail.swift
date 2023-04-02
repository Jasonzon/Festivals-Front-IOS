import Foundation

class Travail {

    var id: Int

    var benevole: Int
    var zone: Int
    var creneau: Int

    init(id: Int, benevole: Int, zone: Int, creneau: Int) {
        self.id = id
        self.benevole = benevole
        self.zone = zone
        self.creneau = creneau
    }

    init(travailDTO: TravailDTO) {
        self.id = travailDTO.id
        self.benevole = travailDTO.benevole
        self.zone = travailDTO.zone
        self.creneau = travailDTO.creneau
    }

    func copy() -> Travail {
        return Travail(id: self.id, benevole: self.benevole, zone: self.zone, creneau: self.creneau)
    }

    func paste(travail: Travail) {
        self.id = travail.id
        self.benevole = travail.benevole
        self.zone = travail.zone
        self.creneau = travail.creneau
    }
}