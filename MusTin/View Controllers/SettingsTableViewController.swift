//
//  SettingsTableViewController.swift
//  MusTin
//
//  Created by Renaat Haleydt on 20/01/2019.
//  Copyright © 2019 Renaat Haleydt. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, SelectGenreTableViewControllerDelegate {
    
    var settings: Settings?
    var genre: String?
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //audioPlayer?.stop()
        settings = SettingsModelController.settings
        updateGUI()
    }
    
    func updateGUI() {
        SettingsModelController.fetchSavedSettingsData()
        updateGenre()
    }
    
    func updateGenre() {
        if let genre = SettingsModelController.settings?.genre {
            genreLabel.text = genre
        } else {
            genreLabel.text = "All"
        }
    }
    
    func didSelect(genre: String) {
        SettingsModelController.settings?.genre = genre
        updateGenre()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "SaveUnwind" {
            SettingsModelController.saveSettingsData()
            ArtistModelController.importSettings()
            MusicViewController.firstTime = true
        } else {
            if segue.identifier == "SelectGenre" {
                let destinationViewController = segue.destination as? SelectGenreTableViewController
                destinationViewController?.delegate = self
                destinationViewController?.genre = genre
            } else {
                if segue.identifier == "ResetUnwind" {
                    showAlertWithConfirmation(title: "Reset your app", message: "Are you sure you want to reset your data?\nIf you click on Reset, everything will be lost!")
                } else {
                    return
                }
            }
        }
        
    }
    
    func showAlertWithConfirmation(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Reset", style: .destructive, handler: {
            action in
                ArtistModelController.clearData()
                SettingsModelController.saveSettingsData()
        })
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
