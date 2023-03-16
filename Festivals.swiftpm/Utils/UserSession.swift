import Foundation

class UserSession {

    static let shared = UserSession()
    
    var benevole: Benevole?
    
    private init() {}
}