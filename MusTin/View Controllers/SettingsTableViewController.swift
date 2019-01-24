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

        settings = SettingsModelController.settings
        
        updateGUI()
    }
    
    
    @IBAction func resetApp(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
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
        
        if segue.identifier == "saveUnwind" {
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
                    _ = SettingsModelController.init()
                    ArtistModelController.clearData()
                    _ = ArtistModelController.init()
                    
                    MusicViewController.firstTime = true
                    
                } else {
                    return
                }
            }
        }
        
    }

}
