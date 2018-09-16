//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by chinny ponnoose on 14/09/18.
//  Copyright © 2018 Chinny Ponnooose. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    
    func iconPicker(_ picker: IconPickerViewController,didPick iconName: String)
                    
}

class IconPickerViewController: UITableViewController {
    
    weak var delegate: IconPickerViewControllerDelegate?
    let icons = [ "No Icon", "Appointments", "Birthdays", "Chores", "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips" ]
    
    // MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.IconCell.rawValue, for: indexPath)
        
        let iconName = icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {

        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }
}
