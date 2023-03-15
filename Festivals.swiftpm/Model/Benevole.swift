import Foundation 

protocol BenevoleObserver {
    func changed(nom : String)
    func changed(prenom : String)
    func changed(mail : String)
}

class Benevole : ObservableObject {

    var observer : BenevoleObserver?
    var id : String = UUID().uuidString

    var mail : String {
        didSet {
            if mail != oldValue {
                if isMailValid() {
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

    init(mail : String, nom : String, prenom : String, id : String) {
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
}