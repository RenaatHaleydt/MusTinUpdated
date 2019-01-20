//
//  SelectGenreTableViewController.swift
//  MusTin
//
//  Created by Renaat Haleydt on 20/01/2019.
//  Copyright © 2019 Renaat Haleydt. All rights reserved.
//

import UIKit

protocol SelectGenreTableViewControllerDelegate {
    func didSelect(genre: String)
}

class SelectGenreTableViewController: UITableViewController {
    var genre: String?
    var delegate: SelectGenreTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ArtistModelController.getDistinctGenres().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath)

        // Configure the cell...
        let genre = ArtistModelController.getDistinctGenres()[indexPath.row]
        
        cell.textLabel?.text = genre
        
        if genre == self.genre {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        genre = ArtistModelController.getDistinctGenres()[indexPath.row]
        delegate?.didSelect(genre: self.genre!)
        tableView.reloadData()
    }

}
