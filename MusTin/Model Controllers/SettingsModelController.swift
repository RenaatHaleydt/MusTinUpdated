//
//  SettingsModelController.swift
//  MusTin
//
//  Created by Renaat Haleydt on 20/01/2019.
//  Copyright © 2019 Renaat Haleydt. All rights reserved.
//

import Foundation

class SettingsModelController {
    static var settings: Settings?
    
    init() {
        SettingsModelController.settings = Settings(gen: "Not Set")
    }
    
    static func saveSettingsData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL =  documentsDirectory.appendingPathComponent("settings").appendingPathExtension("plist")
        
        let propertyListEncoder = PropertyListEncoder()
        let encodedSettings = try? propertyListEncoder.encode(SettingsModelController.settings)
        
        try? encodedSettings?.write(to: archiveURL, options: .noFileProtection)// .noFileProtection is om de documents later te kunnen wijzigen
    }
    
    static func fetchSavedSettingsData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL =  documentsDirectory.appendingPathComponent("settings").appendingPathExtension("plist")
        
        let propertyListDecoder = PropertyListDecoder()
        if let fetchedSettings = try? Data(contentsOf: archiveURL), let decodedSettings = try? propertyListDecoder.decode(Settings.self, from: fetchedSettings) {
            SettingsModelController.settings = decodedSettings
        }
    }
}
