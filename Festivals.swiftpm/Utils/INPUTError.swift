import Foundation
import SwiftUI

enum INPUTError : Error, CustomStringConvertible, Equatable, LocalizedError {
    
    case noError
    case emptyField(String)
    case negativeOrNullValue(String)
    case unknown

    var description : String {
        switch self {
        case .noError:
            return "No error"
        case .emptyField(let value):
            return "Champs Vide pour \(value)"
        case .negativeOrNullValue(let value):
            return "La valeur rentrée ne peut être nul ou négative pour \(value)"
        case .unknown:
            return "unknown error"
        }
    }
}