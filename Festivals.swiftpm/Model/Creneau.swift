import Foundation

protocol CreneauObserver {
    func changed(debut: String)
    func changed(fin: String)
}

class Creneau : ObservableObject {

    var observer : CreneauObserver?
    var id : String = UUID().uuidString

    var debut : String {
        didSet {
            if debut != oldValue {
                if debut.isValidDate() {
                    self.observer?.changed(debut: self.debut)
                }
                else {
                    self.debut = oldValue
                }
            }
        }
    }

    var fin : String {
        didSet {
            if fin != oldValue {
                if fin.isValidDate() {
                    self.observer?.changed(fin: self.fin)
                }
                else {
                    self.fin = oldValue
                }
            }
        }
    }

    init(debut: String, fin: String, id: String) {
        self.debut = debut
        self.fin = fin
        self.id = id
    }

    func isValidDate() -> Bool {
        return true //Pour l'instant, à changer
    }
}