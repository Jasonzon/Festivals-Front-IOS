import Foundation 

protocol BenevoleObserver {
    func change(nom : String)
    func change(prenom : String)
    func change(mail : String)
}

class Benevole {

    var observer : BenevoleObserver?
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

    init(mail: String, nom: String, prenom: String, id: String) {
        self.mail = mail
        self.nom = nom
        self.prenom = prenom
        self.id = id
    }

    init(benevoleDTO: BenevoleDTO) {
        self.mail = benevoleDTO.mail
        self.nom = benevoleDTO.nom
        self.prenom = benevoleDTO.prenom
        self.id = benevoleDTO.id
    }

    func isMailValid() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.mail)
    }

    func copy() -> Benevole {
        return Benevole(mail: self.mail, nom: self.nom, prenom: self.prenom, id: self.id)
    }

    func paste(benevole: Benevole) {
        self.mail = benevole.mail
        self.nom = benevole.nom
        self.prenom = benevole.prenom
        self.id = benevole.id
    }
}