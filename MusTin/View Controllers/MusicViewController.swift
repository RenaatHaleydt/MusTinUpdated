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
        if ArtistModelController.unplayedArtists.isEmpty {
            _ = ArtistModelController()
            _ = SettingsModelController()
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(unplayedArtistsHasChange), name: ArtistModelController.unplayedArtistsNotification, object: nil)
        
        audioPlayer = AVAudioPlayer()
        showNextArtist()
        initializeAudioPlayer()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNextArtist()
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
        
        if audioPlayer!.isPlaying {
            audioPlayer?.pause()
            //playButton.setImage(UIImage(named: "Play.png"), for: .normal)
        } else {
            audioPlayer?.play()
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
                guard ArtistModelController.unplayedArtists.count > 0 else {
                    showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: "No artists", message: "There are no more artists!")
                    audioPlayer!.stop()
                    return
                }
                likeArtist(art: currentArtist!)
                showAlert(title: "Liked", message: "You liked \n\(currentArtist!.name)!")
                showNextArtist()
                playSong(artist: currentArtist!, song: currentSong!)
            }
        }
    }
    
    @IBAction func ArtistSwipedLeft(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            if sender.direction == .left {
                guard ArtistModelController.unplayedArtists.count > 0 else {
                    showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: "No artists", message: "There are no more artists!")
                    audioPlayer!.stop()
                    return
                }
                dislikeArtist(art: currentArtist!)
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
        if audioPlayer!.isPlaying {
            playButton.setImage(UIImage(named: "Pause.png"), for: .normal)
        } else {
            playButton.setImage(UIImage(named: "Play.png"), for: .normal)
        }
    }
    
    //Deze code is gokopieerd van StackOverflow (https://stackoverflow.com/questions/33861565/how-to-show-a-message-on-screen-for-a-few-seconds)
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    func showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Start over", style: .default, handler: {
            action in
                self.viewDidLoad()
        })
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToMusicView(segue: UIStoryboardSegue) {
        
    }
    
    //-----------------------------------domain methods----------------------------------------------
    @objc func unplayedArtistsHasChange() {
        showNextArtist()
    }
    
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
        // Om op de main thread te werken
        //DispatchQueue.main.async {
            let currentSongURL = Bundle.main.url(forResource: self.giveNameOfFile(artiest: artist, song: song), withExtension: song.xtension)
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: currentSongURL!)
                audioPlayer!.volume = self.volumeSlider.value
                audioPlayer!.play()
                checkPlayOrPause()
            }
            catch {
                print(error)
            }
        //}
        
    }
    
    func showNextArtist() {
        guard let ca = ArtistModelController.unplayedArtists.first else {
            showAlertWithConfirmationWhenUnplayedArtistsAreEmpty(title: "No artists", message: "There are no more artists!")
            //audioPlayer!.stop()
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
    
    func dislikeArtist(art: Artist) {
        ArtistModelController.dislikedArtists.append(art)
    }
    
    func likeArtist(art: Artist) {
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
        ArtistModelController.playedArtists.append(ArtistModelController.unplayedArtists.remove(at: ArtistModelController.unplayedArtists.firstIndex{ $0.name == art.name }!))
    }
}

