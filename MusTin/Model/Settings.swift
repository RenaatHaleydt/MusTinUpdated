//
//  Settings.swift
//  MusTin
//
//  Created by Renaat Haleydt on 20/01/2019.
//  Copyright © 2019 Renaat Haleydt. All rights reserved.
//

import Foundation

class Settings: Codable {
    
    var genre: String
    
    init(gen: String) {
        self.genre = gen
    }
}
