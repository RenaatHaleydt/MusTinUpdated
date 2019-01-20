import Foundation

class Artist: Codable, Equatable {
    let name: String
    var album: Album
    
    init(naam: String, al: Album) {
        name = naam
        album = al
    }
    
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return lhs.name == rhs.name && lhs.album.name == rhs.album.name && lhs.album.year == rhs.album.year
    }
}
