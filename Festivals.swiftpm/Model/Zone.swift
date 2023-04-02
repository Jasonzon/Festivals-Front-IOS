import Foundation

protocol ZoneObserver {
    func change(name: String)
    func change(benevoles: Int)
}

class Zone {

    var observer : ZoneObserver?
    var id: Int
    var festival: Int

    var name: String {
        didSet {
            if name != oldValue {
                if name.count >= 1 {
                    self.observer?.change(name: self.name)
                }
                else {
                    self.name = oldValue
                }
            }
        }
    }

    var benevoles: Int {
        didSet {
            if benevoles != oldValue {
                if benevoles >= 3 {
                    self.observer?.change(benevoles: self.benevoles)
                }
                else {
                    self.benevoles = oldValue
                }
            }
        }
    }

    init(name: String, id: Int, benevoles: Int, festival: Int) {
        self.name = name
        self.id = id
        self.benevoles = benevoles
        self.festival = festival
    }

    init(zoneDTO: ZoneDTO) {
        self.name = zoneDTO.name
        self.id = zoneDTO.id
        self.benevoles = zoneDTO.benevoles
        self.festival = zoneDTO.festival
    }

    func copy() -> Zone {
        return Zone(name: self.name, id: self.id, benevoles: self.benevoles, festival: self.festival)
    }

    func paste(zone: Zone) {
        self.name = zone.name
        self.id = zone.id
        self.benevoles = zone.benevoles
        self.festival = zone.festival
    }
}