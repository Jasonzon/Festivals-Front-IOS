import Foundation

protocol ZoneObserver {
    func change(name: String)
}

class Zone {

    var observer : ZoneObserver?
    var id: String

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

    init(name: String, id: String) {
        self.name = name
        self.id = id
    }

    init(zoneDTO: ZoneDTO) {
        self.name = zoneDTO.name
        self.id = zoneDTO.id
    }

    func copy() -> Zone {
        return Zone(name: self.name, id: self.id)
    }

    func paste(zone: Zone) {
        self.name = zone.name
        self.id = zone.id
    }
}