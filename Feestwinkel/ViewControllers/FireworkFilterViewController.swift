//
//  FireworkFilterViewController.swift
//  Feestwinkel
//
//  Created by Jeremie Van de Walle on 21/12/17.
//  Copyright © 2017 Jeremie Van de Walle. All rights reserved.
//

import UIKit

class FireworkFilterViewController : UITableViewController {
    
    var filters = [
        "Naam A - Z",
        "Naam Z - A",
        "Prijs laag - hoog",
        "Prijs hoog - laag",
        "Type"
    ]
    var selectedFilterIndex: Int?
    var selectedFilter: String? {
        didSet {
            if let selectedFilter = selectedFilter,
                let index = filters.index(of: selectedFilter) {
                selectedFilterIndex = index
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "didSelectFilter",
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) else {
                return
        }
        
        let index = indexPath.row
        selectedFilter = filters[index]
    }
    
    override var prefersStatusBarHidden : Bool { return false }
}

extension FireworkFilterViewController {
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath)
        cell.textLabel?.text = filters[indexPath.row]
        
        if indexPath.row == selectedFilterIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        if let index = selectedFilterIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedFilter = filters[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
}

