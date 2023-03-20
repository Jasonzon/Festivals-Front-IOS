import Foundation

class UserSession {

    static let shared = UserSession()
    
    var user: Benevole?
    
    private init() {}
}