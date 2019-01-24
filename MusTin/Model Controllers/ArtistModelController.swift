//
//  ArtistController.swift
//  MusTin
//
//  Created by Renaat Haleydt on 19/01/2019.
//  Copyright © 2019 Renaat Haleydt. All rights reserved.
//

import Foundation

class ArtistModelController {
    static var allArtists: [Artist] = []
    static var unplayedArtists: [Artist] = []
    {
        didSet {
            NotificationCenter.default.post(name: ArtistModelController.unplayedArtistsNotification, object: nil)
        }
    }
    static var playedArtists: [Artist] = []
    static var likedArtists: [Artist] = [] {
        didSet {
            NotificationCenter.default.post(name: ArtistModelController.likedArtistsNotification, object: nil)
        }
    }
    static var dislikedArtists: [Artist] = []
    static let likedArtistsNotification = Notification.Name("ArtistModelController.likedArtistsUpdated")
    static let unplayedArtistsNotification = Notification.Name("ArtistModelController.unplayedArtistsUpdated")
    
    init() {
        readSongsFromHardDisk()
        ArtistModelController.unplayedArtists = ArtistModelController.allArtists.shuffled()
    }
    
    //---------------------------------------Domain methods------------------------------------------------
    static func getDistinctGenres() -> [String] {
        var genres = Array(Set(ArtistModelController.allArtists.filter({ !ArtistModelController.playedArtists.contains($0)}).compactMap({ $0.album.genre })))
        genres.append("All")
        genres = genres.sorted(by: <)
        return genres
    }
    
    static func importSettings() {
        let art = ArtistModelController.allArtists.filter( { !ArtistModelController.playedArtists.contains($0) } )
        let sett = SettingsModelController.settings
        
        guard sett?.genre != "All" else {
            ArtistModelController.unplayedArtists = art.shuffled()
            return
        }
        ArtistModelController.unplayedArtists = art.filter({ $0.album.genre == sett!.genre }).shuffled()
        
    }
    
    static func clearData() {
        _ = SettingsModelController.init()
        ArtistModelController.unplayedArtists = []
        ArtistModelController.playedArtists = []
        ArtistModelController.dislikedArtists = []
        ArtistModelController.likedArtists = []
        _ = ArtistModelController.init()
        MusicViewController.firstTime = true
    }
    
    static func moveUnPlayedArtistToPlayed(art: Artist) {
        ArtistModelController.playedArtists.append(ArtistModelController.unplayedArtists.remove(at: ArtistModelController.unplayedArtists.firstIndex{ $0 == art }!))
    }
    
    static func removeLikedArtist(index: Int) {
        ArtistModelController.dislikedArtists.append(ArtistModelController.likedArtists.remove(at: index))
    }
    
    //---------------------------------------Data methods--------------------------------------------------
    static func saveData() {
        ArtistModelController.saveAllArtistsData()
        ArtistModelController.saveUnplayedArtistsData()
        ArtistModelController.savePlayedArtistsData()
        ArtistModelController.saveLikedArtistsData()
        ArtistModelController.saveDislikedArtistsData()
    }
    
    static func fetchData() {
        ArtistModelController.fetchSavedAllArtistsData()
        ArtistModelController.fetchSavedUnplayedArtistsData()
        ArtistModelController.fetchSavedPlayedArtistsData()
        ArtistModelController.fetchSavedLikedArtistsData()
        ArtistModelController.fetchSavedDislikedArtistsData()
    }
    
    
    static func saveAllArtistsData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL =  documentsDirectory.appendingPathComponent("allArtists").appendingPathExtension("plist")
        
        let propertyListEncoder = PropertyListEncoder()
        let encodedAllArtists = try? propertyListEncoder.encode(ArtistModelController.allArtists)
        
        try? encodedAllArtists?.write(to: archiveURL, options: .noFileProtection)// .noFileProtection is om de documents later te kunnen wijzigen
    }
    
    static func fetchSavedAllArtistsData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL =  documentsDirectory.appendingPathComponent("allArtists").appendingPathExtension("plist")
        
        let propertyListDecoder = PropertyListDecoder()
        if let fetchedAllArtists = try? Data(contentsOf: archiveURL), let decodedAllArtists = try? propertyListDecoder.decode(Array<Artist>.self, from: fetchedAllArtists) {
            ArtistModelController.allArtists = decodedAllArtists
        }
    }
    
    static func saveUnplayedArtistsData() {
        ArtistModelController.unplayedArtists = ArtistModelController.allArtists.filter({!ArtistModelController.playedArtists.contains($0)})
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
    
    static func savePlayedArtistsData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL =  documentsDirectory.appendingPathComponent("playedArtists").appendingPathExtension("plist")
        
        let propertyListEncoder = PropertyListEncoder()
        let encodedPlayedArtists = try? propertyListEncoder.encode(ArtistModelController.playedArtists)
        
        try? encodedPlayedArtists?.write(to: archiveURL, options: .noFileProtection)// .noFileProtection is om de documents later te kunnen wijzigen
    }
    
    static func fetchSavedPlayedArtistsData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL =  documentsDirectory.appendingPathComponent("playedArtists").appendingPathExtension("plist")
        
        let propertyListDecoder = PropertyListDecoder()
        if let fetchedPlayedArtists = try? Data(contentsOf: archiveURL), let decodedPlayedArtists = try? propertyListDecoder.decode(Array<Artist>.self, from: fetchedPlayedArtists) {
            ArtistModelController.playedArtists = decodedPlayedArtists
        }
    }
    
    static func saveLikedArtistsData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL =  documentsDirectory.appendingPathComponent("likedArtists").appendingPathExtension("plist")
        
        let propertyListEncoder = PropertyListEncoder()
        let encodedLikedArtists = try? propertyListEncoder.encode(ArtistModelController.likedArtists)
        
        try? encodedLikedArtists?.write(to: archiveURL, options: .noFileProtection)// .noFileProtection is om de documents later te kunnen wijzigen
    }
    
    static func fetchSavedLikedArtistsData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL =  documentsDirectory.appendingPathComponent("likedArtists").appendingPathExtension("plist")
        
        let propertyListDecoder = PropertyListDecoder()
        if let fetchedLikedArtists = try? Data(contentsOf: archiveURL), let decodedLikedArtists = try? propertyListDecoder.decode(Array<Artist>.self, from: fetchedLikedArtists) {
            ArtistModelController.likedArtists = decodedLikedArtists
        }
    }
    
    static func saveDislikedArtistsData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL =  documentsDirectory.appendingPathComponent("dislikedArtists").appendingPathExtension("plist")
        
        let propertyListEncoder = PropertyListEncoder()
        let encodedDislikedArtists = try? propertyListEncoder.encode(ArtistModelController.dislikedArtists)
        
        try? encodedDislikedArtists?.write(to: archiveURL, options: .noFileProtection)// .noFileProtection is om de documents later te kunnen wijzigen
    }
    
    static func fetchSavedDislikedArtistsData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL =  documentsDirectory.appendingPathComponent("dislikedArtists").appendingPathExtension("plist")
        
        let propertyListDecoder = PropertyListDecoder()
        if let fetchedDislikedArtists = try? Data(contentsOf: archiveURL), let decodedDislikedArtists = try? propertyListDecoder.decode(Array<Artist>.self, from: fetchedDislikedArtists) {
            ArtistModelController.dislikedArtists = decodedDislikedArtists
        }
    }
    
    //---------------------------------------Read songs--------------------------------------------------
    
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
                if(!ArtistModelController.allArtists.contains { $0.name == str[0] }) {
                    artiestenNaam = str[0]
                    albumTitel = str[1]
                    jaar = Int(str[2])
                    gen = str[3]
                    songTitel = str[str.count-1]
                    
                    artiest = Artist(naam: artiestenNaam, al: Album(naam: albumTitel, foto: "", liedjes: [Song(titel: songTitel, type: ".mp3")], jaar: jaar!, gen: gen))
                    ArtistModelController.allArtists.append(artiest!)
                } else {
                    let artist1 = ArtistModelController.allArtists.filter{$0.name == str[0]}.first!
                    if (!artist1.album.songs.contains { $0.title == str[str.count-1] }) {
                        ArtistModelController.allArtists.filter{$0.name == str[0]}.first!.album.songs.append(Song(titel: str[str.count-1], type: ".mp3"))
                    }
                }
            }
        }
    }
}
