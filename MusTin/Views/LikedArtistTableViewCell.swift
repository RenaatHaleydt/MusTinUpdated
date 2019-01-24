//
//  LikedArtistTableViewCell.swift
//  MusTin
//
//  Created by Renaat Haleydt on 19/01/2019.
//  Copyright © 2019 Renaat Haleydt. All rights reserved.
//

import UIKit

class LikedArtistTableViewCell: UITableViewCell {
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumTitleAndYearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    func update(with artist: Artist) {
        artistNameLabel.text = artist.name
        albumTitleAndYearLabel.text = artist.getAlbumString()
        genreLabel.text = artist.album.genre
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
