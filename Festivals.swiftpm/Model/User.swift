import Foundation 

protocol UserObserver {
    func change(nom : String)
    func change(prenom : String)
    func change(role : UserRole)
    func change(mail : String)
    func change(password : String)
}

enum UserRole : String, CaseIterable, Identifiable, Codable {
    case Basic, Admin
    var id: Self {self}
}

class User {

    var observer : UserObserver?
    var id: String

    var mail: String {
        didSet {
            if mail != oldValue {
                if isMailValid() {
                    self.observer?.change(mail : self.mail)
                } 
                else {
                    self.mail = oldValue
                }
            } 
        }
    }
    
    var nom: String {
        didSet {
            if nom != oldValue {
                if nom.count >= 1 {
                    self.observer?.change(nom: self.nom)
                }
                else {
                    self.nom = oldValue
                }
            }
        }
    }

    var prenom: String{
        didSet {
            if prenom != oldValue {
                if prenom.count >= 1 {
                    self.observer?.change(prenom: self.prenom)
                }
                else {
                    self.nom = oldValue
                }
            }
        }
    }
    
    var role: UserRole {
        didSet {
            if role != oldValue {
                self.observer?.change(role : self.role)
            }
        }
    }
    
    var password: String {
        didSet {
            if password != oldValue {
                if password.count >= 1 {
                    self.observer?.change(password: self.password)
                }
                else {
                    self.password = oldValue
                }
            }
        }
    }

    init(mail : String, nom : String, prenom : String, role : UserRole, id : String, password : String = "") {
        self.mail = mail
        self.nom = nom
        self.prenom = prenom
        self.role = role
        self.id = id
        self.password = password
    }

    init(userDTO: UserDTO) {
        self.mail = userDTO.mail
        self.nom = userDTO.nom
        self.prenom = userDTO.prenom
        self.role = userDTO.role
        self.id = userDTO.id
        self.password = userDTO.password
    }

    func isMailValid() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.mail)
    }

    func isAdmin() -> Bool {
        return self.role == .Admin
    }

    func copy() -> User {
        return User(mail: self.mail, nom: self.nom, prenom: self.prenom, role: self.role, id: self.id, password: self.password)
    }

    func paste(user: User) {
        self.mail = user.mail
        self.nom = user.nom
        self.prenom = user.prenom
        self.role = user.role
        self.id = user.id
        self.password = user.password
    }
}