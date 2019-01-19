import Foundation

class Album: Codable {
    let name: String
    let image: String?
    var songs: [Song]
    let year: Int
    var genre: String = "None"
    
    init(naam: String, foto: String? = "no image", liedjes: [Song], jaar: Int, gen: String) {
        name = naam
        image = foto
        songs = liedjes
        year = jaar
        genre = gen
    }
}
