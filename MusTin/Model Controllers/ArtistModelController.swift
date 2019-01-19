//
//  ArtistController.swift
//  MusTin
//
//  Created by Renaat Haleydt on 19/01/2019.
//  Copyright © 2019 Renaat Haleydt. All rights reserved.
//

import Foundation

class ArtistModelController {
    static var unplayedArtists: [Artist] = []
    static var playedArtists = [Artist]()
    static var likedArtists: [Artist] = [] {
        didSet {
            NotificationCenter.default.post(name: ArtistModelController.likedArtistsNotification, object: nil)
        }
    }
    static var dislikedArtists: [Artist] = []
    static let likedArtistsNotification = Notification.Name("ArtistModelController.likedArtistsUpdated")
    
    init() {
        readSongsFromHardDisk()
    }
    
    static func saveUnplayedArtistsData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL =  documentsDirectory.appendingPathComponent("unplayedArtists").appendingPathExtension("plist")

        let propertyListEncoder = PropertyListEncoder()
        let encodedUnplayedArtists = try? propertyListEncoder.encode(ArtistModelController.unplayedArtists)

        try? encodedUnplayedArtists?.write(to: archiveURL, options: .noFileProtection)// .noFileProtection is om de documents later te kunnen wijzigen
    }
    
    static func fetchSavedUnplayedArtistsData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL =  documentsDirectory.appendingPathComponent("unplayedArtists").appendingPathExtension("plist")
        
        let propertyListDecoder = PropertyListDecoder()
        if let fetchedUnplayedArtists = try? Data(contentsOf: archiveURL), let decodedUnplayedArtists = try? propertyListDecoder.decode(Array<Artist>.self, from: fetchedUnplayedArtists) {
            ArtistModelController.unplayedArtists = decodedUnplayedArtists
        }
    }
    
    func readSongsFromHardDisk() {
        var artiest: Artist?
        let songFolderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        var artiestenNaam: String = ""
        var albumTitel: String = ""
        var jaar: Int?
        var gen: String
        var songTitel: String
        
        guard let songsPath = try? FileManager.default.contentsOfDirectory(at: songFolderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else { return }
        
        for song in songsPath {
            var songString = song.absoluteString
            
            if songString.contains(".mp3") {
                var str = songString.components(separatedBy: "/")
                songString = str[str.count-1]
                songString = songString.replacingOccurrences(of: "%20", with: " ")
                songString = songString.replacingOccurrences(of: ".mp3", with: "")
                str = songString.components(separatedBy: " - ")
                if(!ArtistModelController.unplayedArtists.contains { $0.name.elementsEqual(str[0]) }) {
                    artiestenNaam = str[0]
                    albumTitel = str[1]
                    jaar = Int(str[2])
                    gen = str[3]
                    //                    switch str[3].lowercased() {
                    //                        case "rock": gen = Genre.rock
                    //                        case "punk": gen = Genre.punk
                    //                        case "metal": gen = Genre.metal
                    //                        case "dance": gen = Genre.dance
                    //                        case "electronic": gen = Genre.electronic
                    //                        case "indie": gen = Genre.indie
                    //                        case "alternative": gen = Genre.alternative
                    //                        case "alternative rock": gen = Genre.alternativeRock
                    //                        case "punk-rock": gen = Genre.punkRock
                    //                        default:
                    //                            gen = Genre.none
                    //                    }
                    songTitel = str[str.count-1]
                    
                    artiest = Artist(naam: artiestenNaam, al: Album(naam: albumTitel, foto: "", liedjes: [Song(titel: songTitel, type: ".mp3")], jaar: jaar!, gen: gen))
                    ArtistModelController.unplayedArtists.append(artiest!)
                } else {
                    ArtistModelController.unplayedArtists.filter{$0.name == str[0]}.first!.album.songs.append(Song(titel: str[str.count-1], type: ".mp3"))
                }
            }
        }
    }
}
