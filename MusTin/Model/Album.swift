import Foundation

class Album {
    let name: String
    let image: String?
    var songs: [Song]
    let year: Int
    let genre: Genre
    
    init(naam: String, foto: String? = "no image", liedjes: [Song], jaar: Int, gen: Genre = .none) {
        name = naam
        image = foto
        songs = liedjes
        year = jaar
        genre = gen
    }
}
