import Foundation

class API {
    
    static var API = ""

    static func zoneDAO() -> ZoneDAO {
        return ZoneDAO(api: self.API)
    }

    static func creneauDAO() -> CreneauDAO {
        return CreneauDAO(api: self.API)
    }

    static func benevoleDAO() -> BenevoleDAO {
        return BenevoleDAO(api: self.API)
    }

    static func festivalDAO() -> FestivalDAO {
        return FestivalDAO(api: self.API)
    }

    static func jourDAO() -> JourDAO {
        return JourDAO(api: self.API)
    }
}