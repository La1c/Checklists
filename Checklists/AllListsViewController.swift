//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Vladimir on 07.10.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import UIKit
import RealmSwift

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {

    
    var dataModel:DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataModel.lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellForTableView(tableView: tableView)
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        let remaining = checklist.countUncheckedItems()
        cell.detailTextLabel?.text = checklist.items.count == 0 ? NSLocalizedString("(No items)", comment: "No items in the list") : remaining > 0 ?  "\(remaining) " + NSLocalizedString("Remaining", comment: "Number of remaining items") : NSLocalizedString("All done!", comment: "No unchecked items left")
        cell.imageView!.image = UIImage(named: checklist.iconName)
        return cell
    }
    
    func cellForTableView(tableView: UITableView) -> UITableViewCell{
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            return cell
        }
        
        return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = dataModel.lists[indexPath.row]
        dataModel.indexOfSelectedChecklist = indexPath.row
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        dataModel.remove(list: indexPath)// lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checkListToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist"{
            let controller = segue.destination as! ChecklistViewController
            controller.selectedChecklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist"{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checkListToEdit = nil
        }
    }
    
    
    func listDetailViewControllerDidClancel(controller: ListDetailViewController){
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAdding checklist: Checklist){
        
        dataModel.addChecklist(checklist: checklist)
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishEditing checklist: Checklist){
        dataModel.addChecklist(checklist: checklist)
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self{
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}
