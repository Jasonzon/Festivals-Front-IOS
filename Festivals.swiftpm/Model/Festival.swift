import Foundation

protocol FestivalObserver {
    func change(name: String)
    func change(year: String)
    func change(opened: Bool)
}

class Festival {

    var observer : FestivalObserver?
    var id: Int

    var name: String {
        didSet {
            if name != oldValue {
                if name.count >= 1 {
                    self.observer?.change(name: self.name)
                }
                else {
                    self.name = oldValue
                }
            }
        }
    }

    var year: String {
        didSet {
            if year != oldValue {
                if year.count == 4 {
                    self.observer?.change(year: self.year)
                }
                else {
                    self.year = oldValue
                }
            }
        }
    }

    var opened: Bool {
        didSet {
            if opened != oldValue {
                self.observer?.change(opened: self.opened)
            }
        }
    }

    init(name: String, year: String, opened: Bool, id: Int) {
        self.name = name
        self.year = year
        self.opened = opened
        self.id = id
    }

    init(festivalDTO: FestivalDTO) {
        self.name = festivalDTO.name
        self.year = festivalDTO.year
        self.opened = festivalDTO.opened
        self.id = festivalDTO.id
    }

    func copy() -> Festival {
        return Festival(name: self.name, year: self.year, opened: self.opened, id: self.id)
    }

    func paste(festival: Festival) {
        self.name = festival.name
        self.year = festival.year
        self.opened = festival.opened
        self.id = festival.id
    }
}