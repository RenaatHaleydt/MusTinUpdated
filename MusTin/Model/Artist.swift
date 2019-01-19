import Foundation

class Artist: Codable {
    let name: String
    var album: Album
    
    init(naam: String, al: Album) {
        name = naam
        album = al
    }
}
