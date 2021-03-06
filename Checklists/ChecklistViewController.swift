//
//  ViewController.swift
//  Checklists
//
//  Created by Vladimir on 01.02.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import UIKit
import RealmSwift

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var selectedChecklist: Checklist!
    var tasks: Results<ChecklistItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedChecklist.name
        reloadTasks()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        configureTextForTheCell(cell, withChecklistItem: tasks[indexPath.row])
 
        configureCheckmarkForCell(cell, withChecklistItem: tasks[indexPath.row])
        
        configureSubtitleForCell(cell, withChecklistItem: tasks[indexPath.row])
        return cell
    }
    
    func configureCheckmarkForCell(_ cell: UITableViewCell,
                                   withChecklistItem item: ChecklistItem){
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
        
        label.textColor = view.tintColor
    }
    
    func configureTextForTheCell(_ cell: UITableViewCell,
                                 withChecklistItem item: ChecklistItem){
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func configureSubtitleForCell(_ cell: UITableViewCell,
                                  withChecklistItem item: ChecklistItem){
        let label = cell.viewWithTag(1002) as! UILabel
        switch item.priority {
        case "":
            label.text = NSLocalizedString("No priority", comment: "No priority set for an item")
        default:
            label.text = item.priority
            label.textColor = view.tintColor
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if let cell = tableView.cellForRow(at: indexPath){
           
            let item = tasks[(indexPath as NSIndexPath).row]
            item.toggleChecked()
            
            configureCheckmarkForCell(cell, withChecklistItem: tasks[(indexPath as NSIndexPath).row])
            }
        
        tableView.deselectRow(at: indexPath, animated: true)
        //saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                                               forRowAt indexPath: IndexPath) {
        
       let ind = selectedChecklist.items.index(of: tasks[indexPath.row])
        try! uiRealm.write{
            if let ind = ind{
                selectedChecklist.items.remove(objectAtIndex: ind)
            }
        }
      //  tasks.remove(objectAtIndex: (indexPath as NSIndexPath).row)
        
        let indexPaths = [indexPath]
        
        tableView.deleteRows(at: indexPaths, with: .automatic)
        //saveChecklistItems()
    }
    
    func itemDetailViewControllerDidClancel(controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        try! uiRealm.write{
            selectedChecklist.items.append(item)
        }
            reloadTasks()
            tableView.reloadData()
        
        
//        checklist.sortByPriority()
        
        
        //saveChecklistItems()
        dismiss(animated: true, completion: nil)
       
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
 //       checklist.sortByPriority()
        reloadTasks()
        tableView.reloadData()
        
        //saveChecklistItems()
        dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem"{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        }
        
        if segue.identifier == "EditItem"{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = selectedChecklist.items[indexPath.row]
            }
        }
        
    }

}

extension ChecklistViewController{
    func reloadTasks(){
        tasks = selectedChecklist.items.sorted(byProperty: "priority", ascending: false)
    }
}

