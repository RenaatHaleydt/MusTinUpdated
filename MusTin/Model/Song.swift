import Foundation

class Song: Codable {
    let title: String
    let xtension: String
    
    init(titel: String, type: String) {
        title = titel
        self.xtension = type
    }
}
