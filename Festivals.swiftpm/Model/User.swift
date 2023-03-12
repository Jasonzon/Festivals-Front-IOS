import Foundation 

protocol UserObserver {
    func changed(nom : String)
    func changed(prenom : String)
    func changed(role : UserRole)
    func changed(mail : String)
    func changed(password : String)
}

enum UserRole : String, CaseIterable, Identifiable{
    case Basic, Admin
    var id: Self {self}
}

class User : ObservableObject {

    var observer : UserObserver?
    var id : String = UUID().uuidString

    var mail : String {
        didSet {
            if mail != oldValue {
                if mail.isValidEmail() {
                    self.observer?.changed(mail : self.mail)
                } 
                else {
                    self.mail = oldValue
                }
            } 
        }
    }
    
    var nom : String {
        didSet {
            if nom != oldValue {
                if nom.count >= 1 {
                    self.observer?.changed(nom: self.nom)
                }
                else {
                    self.nom = oldValue
                }
            }
        }
    }

    var prenom : String{
        didSet {
            if prenom != oldValue {
                if prenom.count >= 1 {
                    self.observer?.changed(prenom: self.prenom)
                }
                else {
                    self.nom = oldValue
                }
            }
        }
    }
    
    var role : UserRole {
        didSet {
            if role != oldValue {
                self.observer?.changed(role : self.role)
            }
        }
    }
    
    var password : String {
        didSet {
            if password != oldValue {
                if password.count >= 1 {
                    self.observer?.changed(password: self.password)
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

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.mail)
    }

    func isAdmin() -> Bool {
        return self.role == .Admin
    }
}