import Foundation 

protocol BenevoleObserver {
    func change(nom: String)
    func change(prenom: String)
    func change(mail: String)
    func change(role: UserRole)
    func change(password: String)
}

enum UserRole : String, CaseIterable, Identifiable, Codable {
    case Basic, Admin
    var id: Self {self}
}

class Benevole {

    var observer : BenevoleObserver?
    var id: Int

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

    var role: UserRole {
        didSet {
            if role != oldValue {
                self.observer?.change(role : self.role)
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

    init(mail: String, nom: String, prenom: String, id: Int, role: UserRole, password: String) {
        self.mail = mail
        self.nom = nom
        self.prenom = prenom
        self.id = id
        self.role = role
        self.password = password
    }

    init(benevoleDTO: BenevoleDTO) {
        self.mail = benevoleDTO.mail
        self.nom = benevoleDTO.nom
        self.prenom = benevoleDTO.prenom
        self.id = benevoleDTO.id
        self.role = benevoleDTO.role
        self.password = benevoleDTO.password
    }

    func isMailValid() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.mail)
    }

    func isAdmin() -> Bool {
        return self.role == .Admin
    }

    func copy() -> Benevole {
        return Benevole(mail: self.mail, nom: self.nom, prenom: self.prenom, id: self.id, role: self.role, password: self.password)
    }

    func paste(benevole: Benevole) {
        self.mail = benevole.mail
        self.nom = benevole.nom
        self.prenom = benevole.prenom
        self.id = benevole.id
        self.role = benevole.role
        self.password = benevole.password
    }
}