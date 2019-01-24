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
    let likeSeconds = 0.7
    
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
        showNextArtist()
        initializeAudioPlayer(artist: currentArtist!, song: currentSong!)
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        audioPlayer = AVAudioPlayer()
        if ArtistModelController.unplayedArtists.count == 0 {
            showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: "No artists", message: "There are no more artists to show!\nGo to Settings and change your genre or reset your app end start over.")
            return
        }
        showNextArtist()
        initializeAudioPlayer(artist: currentArtist!, song: currentSong!)
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
            audioPlayer!.stop()
            checkPlayOrPause()
            showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: "No artists", message: "There are no more artists to show!\nGo to Settings and change your genre or reset your app end start over.")
            
            return
        }
        likeArtist(art: currentArtist!)
        showAlert(title: "Liked", message: "You liked \n\(currentArtist!.name)!", time: self.likeSeconds)
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
                    audioPlayer!.stop()
                    checkPlayOrPause()
                    showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: "No artists", message: "There are no more artists to show!\nGo to Settings and change your genre or reset your app end start over.")
                    
                    return
                }
                likeArtist(art: currentArtist!)
                showAlert(title: "Liked", message: "You liked \n\(currentArtist!.name)!", time: self.likeSeconds)
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
            audioPlayer!.stop()
            checkPlayOrPause()
            showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: "No artists", message: "There are no more artists to show!\nGo to Settings and change your genre or reset your app end start over.")
            
            return
        }
        dislikeArtist(art: currentArtist!)
        showAlert(title: "Not liked", message: "You didn't like \n\(currentArtist!.name)!", time: self.likeSeconds)
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
                showAlert(title: "Not liked", message: "You didn't like \n\(currentArtist!.name)!", time: self.likeSeconds)
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
        //audioPlayer?.stop()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Start over", style: .destructive, handler: {
            action in
                ArtistModelController.clearData()
            
        })
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToMusicView(segue: UIStoryboardSegue) {
        
    }
    
    //-----------------------------------domain methods----------------------------------------------
    /**
     This is a method to initialize the AudioPlayer for the first time.
     */
    func initializeAudioPlayer(artist: Artist, song: Song) {
        let currentSongURL = Bundle.main.url(forResource: self.giveNameOfFile(artiest: artist, song: song), withExtension: currentSong!.xtension)
            try? audioPlayer = AVAudioPlayer(contentsOf: currentSongURL!)
            audioPlayer!.volume = self.volumeSlider.value
            checkPlayOrPause()
        //playButton.setImage(UIImage(named: "Play.png"), for: .normal)
    }
    
    /**
     This is a method to initialize the AudioPlayer, but also to play a song
     */
    func playSong(artist: Artist, song: Song) {
        initializeAudioPlayer(artist: currentArtist!, song: currentSong!)
        audioPlayer!.play()
        checkPlayOrPause()
        MusicViewController.firstTime = false
    }
    
    func showNextArtist() {
        guard let ca = ArtistModelController.unplayedArtists.first else {
            if MusicViewController.firstTime == true { // De lijst van unplayedArtists is in het begin leeg, je wil niet dat hij dan de Alert geeft
                return
            } else {
                audioPlayer?.stop()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: "No artists", message: "There are no more artists to show!\nGo to Settings and change your genre or reset your app end start over.")
                })
//                showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: "No artists", message: "There are no more artists to show!\nGo to Settings and change your genre or reset your app end start over.")
                return
            }
        }
        
        ArtistModelController.importSettings()
        currentArtist = ca
        
        tellerSongs = 0
        if let song = getNextSongFromCurrentArtist(){
            currentSong = song
            updateGUI(artiest: currentArtist!, currentSong: currentSong!)
        }
    }
    
    func dislikeArtist(art: Artist) {
        MusicViewController.firstTime = false
        ArtistModelController.moveUnPlayedArtistToPlayed(art: currentArtist!)
        if ArtistModelController.dislikedArtists.contains(art) {
            return
        }
        ArtistModelController.dislikedArtists.append(art)
    }
    
    func likeArtist(art: Artist) {
        MusicViewController.firstTime = false
        ArtistModelController.moveUnPlayedArtistToPlayed(art: currentArtist!)
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
    
}

