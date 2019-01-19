import Foundation

class Artists {
    var artists = [Artist]()
    var list = [Artist]()
    
    init() {
        getArtists()
    }
    
    func getArtists() {
        var artiest: Artist?
        let songFolderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        var artiestenNaam: String = ""
        var albumTitel: String = ""
        var jaar: Int?
        var gen: Genre
        var songTitel: String
        
        do {
            let songsPath = try FileManager.default.contentsOfDirectory(at: songFolderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for song in songsPath {
                var songString = song.absoluteString
                
                if songString.contains(".mp3") {
                    var str = songString.components(separatedBy: "/")
                    songString = str[str.count-1]
                    songString = songString.replacingOccurrences(of: "%20", with: " ")
                    songString = songString.replacingOccurrences(of: ".mp3", with: "")
                    str = songString.components(separatedBy: " - ")
                    if(!artists.contains { $0.name.elementsEqual(str[0]) }) {
                        artiestenNaam = str[0]
                        albumTitel = str[1]
                        jaar = Int(str[2])
                        switch str[3].lowercased() {
                            case "rock": gen = Genre.rock
                            case "punk": gen = Genre.punk
                            case "metal": gen = Genre.metal
                            case "dance": gen = Genre.dance
                            case "electronic": gen = Genre.electronic
                            case "indie": gen = Genre.indie
                            case "alternative": gen = Genre.alternative
                            case "alternative rock": gen = Genre.alternativeRock
                            case "punk-rock": gen = Genre.punkRock
                            default:
                                gen = Genre.none
                        }
                        songTitel = str[str.count-1]
                        
                        artiest = Artist(naam: artiestenNaam, al: Album(naam: albumTitel, foto: "", liedjes: [Song(titel: songTitel, type: ".mp3")], jaar: jaar!, gen: gen))
                        artists.append(artiest!)
                    } else {
                        artists.filter{$0.name == str[0]}.first!.album.songs.append(Song(titel: str[str.count-1], type: ".mp3"))
                    }
                }
            }
        }
        catch {
            
        }
    }
    
    func getAlbumFromArtist() {
        
    }
    
    func getSongsFromAlbum() {
        
    }
}
