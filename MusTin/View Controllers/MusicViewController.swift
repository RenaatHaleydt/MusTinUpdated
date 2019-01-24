//
//  ViewController.swift
//  MusTin
//
//  Created by Renaat Hxaleydt on 23/12/2018.
//  Copyright © 2018 Renaat Haleydt. All rights reserved.
//

import UIKit
import AVFoundation

var audioPlayer: AVAudioPlayer?

class MusicViewController: UIViewController {
    //---------------------------------------properties----------------------------------------------
    
    var currentArtist: Artist?
    var currentSong: Song?
    static var firstTime = true // Is nodig om de player niet te laten beginnen als het scherm geladen is, maar wel wanneer er voor de eerste keer op de playButton gedrukt is.
    var tellerSongs = 0 // Wordt gebruikt om de teller bij te houden welke song er aan het spelen is
    
    
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
        if ArtistModelController.unplayedArtists.isEmpty {
            _ = ArtistModelController()
            _ = SettingsModelController()
        }
        
        audioPlayer = AVAudioPlayer()
        //showNextArtistForFirstTime()
        showNextArtist()
        initializeAudioPlayer()
        
        print("\n\n\n\nIn viewDidLoad")
        print("All Artists: ")
        for ar in ArtistModelController.allArtists {
            print(ar.name)
        }
        print("\n\nUnplayed Artists: ")
        for ar in ArtistModelController.unplayedArtists {
            print(ar.name)
        }
        print("\n\nPlayed Artists: ")
        for ar in ArtistModelController.playedArtists {
            print(ar.name)
        }
        print("\n\nDisliked Artists: ")
        for ar in ArtistModelController.dislikedArtists {
            print(ar.name)
        }
        print("\n\nLiked Artists: ")
        for ar in ArtistModelController.likedArtists {
            print(ar.name)
        }
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if MusicViewController.firstTime == true {
            audioPlayer = AVAudioPlayer()
            //showNextArtistForFirstTime()
            showNextArtist()
            initializeAudioPlayer()
        } else {
            showNextArtist()
        }
        
        print("\n\n\n\nIn viewWillAppear")
        print("All Artists: ")
        for ar in ArtistModelController.allArtists {
            print(ar.name)
        }
        print("\n\nUnplayed Artists: ")
        for ar in ArtistModelController.unplayedArtists {
            print(ar.name)
        }
        print("\n\nPlayed Artists: ")
        for ar in ArtistModelController.playedArtists {
            print(ar.name)
        }
        print("\n\nDisliked Artists: ")
        for ar in ArtistModelController.dislikedArtists {
            print(ar.name)
        }
        print("\n\nLiked Artists: ")
        for ar in ArtistModelController.likedArtists {
            print(ar.name)
        }
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
        if MusicViewController.firstTime == true { // Is nodig om de player niet te laten beginnen als het scherm geladen is, maar wel wanneer er voor de eerste keer op de playButton gedrukt is.
            playSong(artist: currentArtist!, song: currentSong!)
            //MusicViewController.firstTime = false
            return
        }
        
        if audioPlayer!.isPlaying {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
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

    @IBAction func likeButtonPressed(_ sender: UIButton) {
        guard ArtistModelController.unplayedArtists.count > 0 else {
            if !ArtistModelController.likedArtists.contains(self.currentArtist!) && !ArtistModelController.dislikedArtists.contains(self.currentArtist!) {
                likeArtist(art: currentArtist!)
            }
            showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: "No artists", message: "There are no more artists to show!\nGo to Settings and change your genre or reset your app end start over.")
            audioPlayer!.stop()
            checkPlayOrPause()
            return
        }
        likeArtist(art: currentArtist!)
        showAlert(title: "Liked", message: "You liked \n\(currentArtist!.name)!", time: 0.7)
        showNextArtist()
        playSong(artist: currentArtist!, song: currentSong!)
    }
    
    @IBAction func artistSwipedRight(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            if sender.direction == .right {
                guard ArtistModelController.unplayedArtists.count > 0 else {
                    if !ArtistModelController.likedArtists.contains(self.currentArtist!) && !ArtistModelController.dislikedArtists.contains(self.currentArtist!) {
                        likeArtist(art: currentArtist!)
                    }
                    showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: "No artists", message: "There are no more artists to show!\nGo to Settings and change your genre or reset your app end start over.")
                    audioPlayer!.stop()
                    checkPlayOrPause()
                    return
                }
                likeArtist(art: currentArtist!)
                showAlert(title: "Liked", message: "You liked \n\(currentArtist!.name)!", time: 0.7)
                showNextArtist()
                playSong(artist: currentArtist!, song: currentSong!)
            }
        }
    }
    
    @IBAction func dislikeButtonPressed(_ sender: UIButton) {
        guard ArtistModelController.unplayedArtists.count > 0 else {
            if !ArtistModelController.likedArtists.contains(self.currentArtist!) && !ArtistModelController.dislikedArtists.contains(self.currentArtist!) {
                dislikeArtist(art: currentArtist!)
            }
            showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: "No artists", message: "There are no more artists to show!\nGo to Settings and change your genre or reset your app end start over.")
            audioPlayer!.stop()
            checkPlayOrPause()
            return
        }
        dislikeArtist(art: currentArtist!)
        showAlert(title: "Not liked", message: "You didn't like \n\(currentArtist!.name)!", time: 0.7)
        showNextArtist()
        playSong(artist: currentArtist!, song: currentSong!)
    }
    
    
    @IBAction func ArtistSwipedLeft(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            if sender.direction == .left {
                guard ArtistModelController.unplayedArtists.count > 0 else {
                    if !ArtistModelController.likedArtists.contains(self.currentArtist!) && !ArtistModelController.dislikedArtists.contains(self.currentArtist!) {
                        dislikeArtist(art: currentArtist!)
                    }
                    
                    audioPlayer!.stop()
                    checkPlayOrPause()
                    showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: "No artists", message: "There are no more artists to show!\nGo to Settings and change your genre or reset your app end start over.")
                    return
                }
                dislikeArtist(art: currentArtist!)
                showAlert(title: "Not liked", message: "You didn't like \n\(currentArtist!.name)!", time: 0.7)
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
        if audioPlayer!.isPlaying {
            playButton.setImage(UIImage(named: "Pause.png"), for: .normal)
        } else {
            playButton.setImage(UIImage(named: "Play.png"), for: .normal)
        }
    }
    
    //Deze code is gekopieerd van StackOverflow (https://stackoverflow.com/questions/33861565/how-to-show-a-message-on-screen-for-a-few-seconds)
    func showAlert(title: String, message: String, time: Double) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    func showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Start over", style: .default, handler: {
            action in
                _ = SettingsModelController.init()
                ArtistModelController.clearData()
                _ = ArtistModelController.init()
                
                MusicViewController.firstTime = true
            
        })
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToMusicView(segue: UIStoryboardSegue) {
        
    }
    
    //-----------------------------------domain methods----------------------------------------------
    func initializeAudioPlayer() {
        let currentSongURL = Bundle.main.url(forResource: self.giveNameOfFile(artiest: currentArtist!, song: currentSong!), withExtension: currentSong!.xtension)
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: currentSongURL!)
            audioPlayer!.volume = self.volumeSlider.value
            playButton.setImage(UIImage(named: "Play.png"), for: .normal)
        }
        catch {
            print(error)
        }
    }
    
    func playSong(artist: Artist, song: Song) {
        let currentSongURL = Bundle.main.url(forResource: self.giveNameOfFile(artiest: artist, song: song), withExtension: song.xtension)
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: currentSongURL!)
            audioPlayer!.volume = self.volumeSlider.value
            audioPlayer!.play()
            checkPlayOrPause()
            MusicViewController.firstTime = false
            
        }
        catch {
            print(error)
        }
    }
    
    func showNextArtist() {
        guard let ca = ArtistModelController.unplayedArtists.first else {
            if MusicViewController.firstTime == true { // De lijst van unplayedArtists is in het begin leeg, je wil niet dat hij dan de Alert geeft
                return
            } else {
                showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: "No artists", message: "There are no more artists to show!\nGo to Settings and change your genre or reset your app end start over.")
                //audioPlayer!.stop()
                return
            }
        }
        //if SettingsModelController.settings?.genre != "Not Set" {
            //ArtistModelController.importSettings()
        //}
        
        ArtistModelController.importSettings()
        currentArtist = ca
        
        tellerSongs = 0
        if let song = getNextSongFromCurrentArtist(){
            currentSong = song
            updateGUI(artiest: currentArtist!, currentSong: currentSong!)
        } else {
            showAlert(title: "No songs", message: "There are no songs from \(currentArtist!.name)", time: 2)
        }
    }
    
    func dislikeArtist(art: Artist) {
        moveUnPlayedArtistToPlayed(art: currentArtist!)
        if ArtistModelController.dislikedArtists.contains(art) {
            return
        }
        ArtistModelController.dislikedArtists.append(art)
    }
    
    func likeArtist(art: Artist) {
        moveUnPlayedArtistToPlayed(art: currentArtist!)
        if ArtistModelController.likedArtists.contains(art) {
          return
        }
        ArtistModelController.likedArtists.append(art)
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
        return "\(artiest.name) - \(artiest.album.name) - \(artiest.album.year) - \(artiest.album.genre) - \(song.title)"
    }
    
    func moveUnPlayedArtistToPlayed(art: Artist) {
        ArtistModelController.playedArtists.append(ArtistModelController.unplayedArtists.remove(at: ArtistModelController.unplayedArtists.firstIndex{ $0 == art }!))
    }
}

