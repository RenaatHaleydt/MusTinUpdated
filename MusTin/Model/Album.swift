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
    
    func giveGenreInString(genre: Genre) -> String {
        switch genre {
        case Genre.alternative:
            return "Alternative"
        case Genre.alternativeRock:
            return "Alternative Rock"
        case Genre.dance:
            return "Dance"
        case Genre.electronic:
            return "Electronic"
        case Genre.indie:
            return "Indie"
        case Genre.metal:
            return "Metal"
        case Genre.punk:
            return "Punk"
        case Genre.punkRock:
            return "Punk-Rock"
        case Genre.rock:
            return "Rock"
        default:
            return "none"
        }
    }
}
