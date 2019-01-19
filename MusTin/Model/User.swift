//
//  User.swift
//  MusTin
//
//  Created by Renaat Haleydt on 19/01/2019.
//  Copyright © 2019 Renaat Haleydt. All rights reserved.
//

import Foundation

class User {
    var unPlayedArtists: [Artist] = []
    var playedArtists: [Artist] = []
    
    init(unPlayed: [Artist], played: [Artist]) {
        self.unPlayedArtists = unPlayed
        self.playedArtists = played
    }
}
