//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Chinny Ponnooose on 9/13/18.
//  Copyright © 2018 Chinny Ponnooose. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {
    
   var dataModel: DataModel!
    //as if now we are using the data model in plist format.In future we can change the data model by  a protocol
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: SegueIdentifiers.ShowChecklist, sender: checklist)
        }
    }
    
}

extension AllListsViewController {
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        
        let cellIdentifier = CellIdentifiers.AllList
        let cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        return cell ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
    }
}

extension AllListsViewController {
    // MARK: - Table view data source and delegates
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        // Update cell informaiton
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel?.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel?.text = Subtitle.None
        } else if count == 0 {
            cell.detailTextLabel?.text = Subtitle.AllDone
        } else {
            cell.detailTextLabel?.text = "\(count) Remaining"
        }
        cell.imageView?.image = UIImage(named: checklist.iconName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: SegueIdentifiers.ShowChecklist, sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        dataModel.saveChecklists()
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.ListDetail) as? ListDetailViewController else {
            return
        }
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        navigationController?.pushViewController(controller, animated: true)
    }
}
extension AllListsViewController {
    // MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case SegueIdentifiers.ShowChecklist :
            
            let controller = segue.destination as? ChecklistViewController
            controller?.checklist = sender as? Checklist
            
        case SegueIdentifiers.AddChecklist:
            
            let controller = segue.destination as? ListDetailViewController
            controller?.delegate = self
            
        default:
            break
        }
    }
}


extension AllListsViewController: ListDetailViewControllerDelegate {
    // MARK:- List Detail View Controller Delegates
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    
}


extension AllListsViewController:UINavigationControllerDelegate {
    // MARK:- UINavigationController Delegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}
