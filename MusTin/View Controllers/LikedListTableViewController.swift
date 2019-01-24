//
//  LikedListTableViewController.swift
//  MusTin
//
//  Created by Renaat Haleydt on 19/01/2019.
//  Copyright © 2019 Renaat Haleydt. All rights reserved.
//

import UIKit

class LikedListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(tableView, selector: #selector(UITableView.reloadData), name: ArtistModelController.likedArtistsNotification, object: nil)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50.0
    }

    // Code komt uit handboek van Apple
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return ArtistModelController.likedArtists.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikedArtistCell", for: indexPath) as! LikedArtistTableViewCell

        // Configure the cell...
        let artist = ArtistModelController.likedArtists[indexPath.row]
        cell.update(with: artist)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ArtistModelController.removeLikedArtist(index: indexPath.row)
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade) // Geeft error!
            tableView.reloadData()
        }
    }

}
