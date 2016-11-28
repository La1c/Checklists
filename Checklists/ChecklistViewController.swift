//
//  ViewController.swift
//  Checklists
//
//  Created by Vladimir on 01.02.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklist: Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        configureTextForTheCell(cell, withChecklistItem: checklist.items[(indexPath as NSIndexPath).row])
 
        configureCheckmarkForCell(cell, withChecklistItem: checklist.items[(indexPath as NSIndexPath).row])
        
        configureSubtitleForCell(cell, withChecklistItem: checklist.items[(indexPath as NSIndexPath).row])
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
        case .none:
            label.text = "No priority"
        default:
            label.text = item.priority.rawValue
            label.textColor = view.tintColor
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if let cell = tableView.cellForRow(at: indexPath){
           
            let item = checklist.items[(indexPath as NSIndexPath).row]
            item.toggleChecked()
            
            configureCheckmarkForCell(cell, withChecklistItem: checklist.items[(indexPath as NSIndexPath).row])
            }
        
        tableView.deselectRow(at: indexPath, animated: true)
        //saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                                               forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: (indexPath as NSIndexPath).row)
        
        let indexPaths = [indexPath]
        
        tableView.deleteRows(at: indexPaths, with: .automatic)
        //saveChecklistItems()
    }
    
    func itemDetailViewControllerDidClancel(controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        checklist.items.append(item)
        checklist.sortByPriority()
        tableView.reloadData()
        
        //saveChecklistItems()
        dismiss(animated: true, completion: nil)
       
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        checklist.sortByPriority()
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
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
        
    }

}

