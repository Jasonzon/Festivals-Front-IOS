import Foundation

class UserSession {

    static let shared = UserSession()
    
    var user: User?
    
    private init() {}
}