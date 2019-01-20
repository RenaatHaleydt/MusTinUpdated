//
//  SettingsTableViewController.swift
//  MusTin
//
//  Created by Renaat Haleydt on 20/01/2019.
//  Copyright © 2019 Renaat Haleydt. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    var settings: Settings?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var genreText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateGUI()
    }
    
    func updateGUI() {
        settings = SettingsModelController.settings
        genreText.text = settings?.genre
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        SettingsModelController.settings = Settings(gen: genreText.text!)
        SettingsModelController.saveSettingsData()
    }

}
