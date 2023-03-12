import Foundation

class API {
    static var API = ""
    
    static func jeuDAO() -> JeuDAO {
        return JeuDAO(api: self.API)
    }

    static func zoneDAO() -> ZoneDAO {
        return ZoneDAO(api: self.API)
    }

    static func creneauDAO() -> CreneauDAO {
        return CreneauDAO(api: self.API)
    }

    static func benevoleDAO() -> BenevoleDAO {
        return BenevoleDAO(api: self.API)
    }

    static func userDAO() -> UserDAO {
        return UserDAO(api: self.API)
    }
}