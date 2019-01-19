//
//  ViewController.swift
//  MusTin
//
//  Created by Renaat Hxaleydt on 23/12/2018.
//  Copyright © 2018 Renaat Haleydt. All rights reserved.
//

import UIKit
import AVFoundation

class MusicViewController: UIViewController {
    //---------------------------------------properties----------------------------------------------
    var audioPlayer: AVAudioPlayer?
    var currentArtist: Artist?
    var currentSong: Song?
    var unPlayedArtists: [Artist] = []
    var playedArtists: [Artist] = []
    var firstTime = true
    var tellerSongs = 0
    
    
    //---------------------------------------IBOutlets-----------------------------------------------
    
    @IBOutlet weak var albumCoverImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    //---------------------------------ViewController methods----------------------------------------
    
    override func viewDidLoad() {
        audioPlayer = AVAudioPlayer()
        unPlayedArtists =  Artists().artists
        print("Lijst met unPlayed in het begin!")
        for ar in unPlayedArtists {
            print(ar.name)
        }
        showNextArtist()
        initializeAudioPlayer()
        super.viewDidLoad()
    }

    //-------------------------------------IBActions-------------------------------------------------

    @IBAction func previousButtonPressed(_ sender: UIButton) {
        if let song = getPreviousSongFromCurrentArtist() {
            currentSong = song
            playSong(artist: currentArtist!, song: currentSong!)
            updateGUI(artiest: currentArtist!, currentSong: currentSong!)
        } else {
            
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if firstTime == true {
            playSong(artist: currentArtist!, song: currentSong!)
            firstTime = false
            //playButton.setImage(UIImage(named: "Pause.png"), for: .normal)
            return
        }
        
        if self.audioPlayer!.isPlaying {
            self.audioPlayer?.pause()
            //playButton.setImage(UIImage(named: "Play.png"), for: .normal)
        } else {
            self.audioPlayer?.play()
            //playButton.setImage(UIImage(named: "Pause.png"), for: .normal)
        }
        checkPlayOrPause()
        
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if let song = getNextSongFromCurrentArtist(){
            currentSong = song
            playSong(artist: currentArtist!, song: currentSong!)
            updateGUI(artiest: currentArtist!, currentSong: currentSong!)
        } else {
            
        }
    }
    
    @IBAction func volumeSliderMoved(_ sender: UISlider) {
        audioPlayer!.volume = sender.value
    }
    
    @IBAction func artistSwipedRight(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            if sender.direction == .right {
                likeArtist(art: currentArtist!)
                showAlert(title: "Liked", message: "You liked the \n\(currentArtist!.name)!")
                showNextArtist()
                playSong(artist: currentArtist!, song: currentSong!)
            }
        }
    }
    
    
    @IBAction func ArtistSwipedLeft(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            if sender.direction == .left {
                unlikeArtist(art: currentArtist!)
                showAlert(title: "Not liked", message: "You didn't like \n\(currentArtist!.name)!")
                showNextArtist()
                playSong(artist: currentArtist!, song: currentSong!)
            }
        }
    }
    
    //---------------------------------------GUI-----------------------------------------------------
    
    func updateGUI(artiest: Artist, currentSong: Song) {
        artistNameLabel.text = artiest.name
        songNameLabel.text = currentSong.title
    }
    
    func checkPlayOrPause() {
        if self.audioPlayer!.isPlaying {
            playButton.setImage(UIImage(named: "Pause.png"), for: .normal)
        } else {
            playButton.setImage(UIImage(named: "Play.png"), for: .normal)
        }
    }
    
    //Deze code is gokopieerd van StackOverflow (https://stackoverflow.com/questions/33861565/how-to-show-a-message-on-screen-for-a-few-seconds)
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    //-----------------------------------domain methods----------------------------------------------
    
    func initializeAudioPlayer() {
        let currentSongURL = Bundle.main.url(forResource: self.giveNameOfFile(artiest: currentArtist!, song: currentSong!), withExtension: currentSong!.xtension)
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: currentSongURL!)
            audioPlayer!.volume = self.volumeSlider.value
        }
        catch {
            print(error)
        }
    }
    
    func playSong(artist: Artist, song: Song) {
        // Om op de main thread te werken
        //DispatchQueue.main.async {
            let currentSongURL = Bundle.main.url(forResource: self.giveNameOfFile(artiest: artist, song: song), withExtension: song.xtension)
            do {
                try self.audioPlayer = AVAudioPlayer(contentsOf: currentSongURL!)
                self.audioPlayer!.volume = self.volumeSlider.value
                self.audioPlayer!.play()
                checkPlayOrPause()
            }
            catch {
                print(error)
            }
        //}
        
    }
    
    func showNextArtist() {
        for ar in unPlayedArtists {
            print("Bij begin van methode \(ar.name)")
        }
        if unPlayedArtists.isEmpty {
            showAlert(title: "No artists", message: "There are no more artists!")
            audioPlayer?.stop()
            for ar in unPlayedArtists {
                print("blablablablabla \(ar.name)")
            }
            return
        }
        guard let ca = unPlayedArtists.randomElement() else {
            showAlert(title: "No artists", message: "There are no more artists!")
            return
        }
        currentArtist = ca
        moveUnPlayedArtistToPlayed(art: currentArtist!)
        tellerSongs = 0
        if let song = getNextSongFromCurrentArtist(){
            currentSong = song
            updateGUI(artiest: currentArtist!, currentSong: currentSong!)
        } else {
            showAlert(title: "No songs", message: "There are no songs from \(currentArtist!.name)")
        }
    }
    
    func unlikeArtist(art: Artist) {
        
    }
    
    func likeArtist(art: Artist) {
        
    }
    
    func getNextSongFromCurrentArtist() -> Song? {
        if currentArtist!.album.songs.count >= tellerSongs+1 {
            let next = currentArtist!.album.songs[tellerSongs]
            tellerSongs += 1
            
            return next
        } else {
            return nil
        }
    }
    
    func getPreviousSongFromCurrentArtist() -> Song? {
        guard tellerSongs != 0 else {
            return nil
        }
        tellerSongs -= 1
        return currentArtist!.album.songs[tellerSongs]
    }
    
    func giveNameOfFile(artiest: Artist, song: Song) -> String {
        return "\(artiest.name) - \(artiest.album.name) - \(artiest.album.year) - \(giveGenre(genre: artiest.album.genre)) - \(song.title)"
    }
    
    //TODOTODOTODOTODO: deze methode kan naar class Artist verhuizen!
    func giveGenre(genre: Genre) -> String {
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
    
    func moveUnPlayedArtistToPlayed(art: Artist) {
        playedArtists.append(unPlayedArtists.remove(at: unPlayedArtists.firstIndex{ $0.name == art.name }!))
    }
}

