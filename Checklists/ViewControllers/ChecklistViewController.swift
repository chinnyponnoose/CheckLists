//
//  ViewController.swift
//  Checklists
//
//  Created by Chinny Ponnooose on 9/13/18.
//  Copyright © 2018 Chinny Ponnooose. All rights reserved.
//

import UIKit

class ChecklistCell :UITableViewCell {
    
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var checkLabel: UILabel!
    
}

class ChecklistViewController: UITableViewController {
    
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    
    func configureCheckmark(for cell: ChecklistCell,
                            with item: ChecklistItem) {
        
        cell.checkLabel.textColor = view.tintColor
        cell.checkLabel.text = item.checked ? "√" : ""
        
    }
    
    func configureText(for cell: ChecklistCell,
                       with item: ChecklistItem) {
        cell.listNameLabel.text = item.text
    }
}

extension ChecklistViewController {
    // MARK:- TableView Delegates
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CellIdentifiers.CheckList, for: indexPath) as! ChecklistCell
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath)  as? ChecklistCell{
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
}
extension ChecklistViewController {
    // MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case SegueIdentifiers.AddItem :
            
            let controller = segue.destination as? ItemDetailViewController
            controller?.delegate = self
            
        case SegueIdentifiers.EditItem:
            
            let controller = segue.destination as? ItemDetailViewController
            controller?.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller?.itemToEdit = checklist.items[indexPath.row]
            }
            
        default:
            break
        }
        
    }
}

extension ChecklistViewController:ItemDetailViewControllerDelegate {
    // MARK:- ItemDetailViewController Delegates
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated:true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated:true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? ChecklistCell{
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated:true)
    }
}
