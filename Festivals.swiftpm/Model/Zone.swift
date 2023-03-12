import Foundation

protocol ZoneObserver {
    func changed(name: String)
}

class Zone : ObservableObject {

    var observer : ZoneObserver?
    var id : String = UUID().uuidString

    var name : String {
        didSet {
            if name != oldValue {
                if name.count >= 1 {
                    self.observer?.changed(name: self.name)
                }
                else {
                    self.name = oldValue
                }
            }
        }
    }

    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
}