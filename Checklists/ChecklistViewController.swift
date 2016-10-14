//
//  ViewController.swift
//  Checklists
//
//  Created by Vladimir on 01.02.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    var items: [ChecklistItem]
    var checklist: Checklist!
    
    required init? (coder aDecoder: NSCoder)
    {
        items = [ChecklistItem]()
        super.init(coder: aDecoder)
        loadChecklistItems()
    }
    

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
        return items.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        configureTextForTheCell(cell, withChecklistItem: items[(indexPath as NSIndexPath).row])
 
        configureCheckmarkForCell(cell, withChecklistItem: items[(indexPath as NSIndexPath).row])
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
    }
    
    func configureTextForTheCell(_ cell: UITableViewCell,
                                 withChecklistItem item: ChecklistItem){
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if let cell = tableView.cellForRow(at: indexPath){
           
            let item = items[(indexPath as NSIndexPath).row]
            item.toggleChecked()
            
            configureCheckmarkForCell(cell, withChecklistItem: items[(indexPath as NSIndexPath).row])
            }
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                                               forRowAt indexPath: IndexPath) {
        items.remove(at: (indexPath as NSIndexPath).row)
        
        let indexPaths = [indexPath]
        
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveChecklistItems()
    }
    
    func itemDetailViewControllerDidClancel(controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows( at: indexPaths, with: .automatic)
        
        saveChecklistItems()
        dismiss(animated: true, completion: nil)
       
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        if let ind = items.index(of: item){
            let indexPath = IndexPath(row: ind, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureTextForTheCell(cell, withChecklistItem: item)
            }
        }
        saveChecklistItems()
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
                controller.itemToEdit = items[indexPath.row]
            }
        }
        
    }
    
    func documentsDirectory() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String{
        return (documentsDirectory() as NSString).appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
        
    }
    
    func loadChecklistItems(){
        let path = dataFilePath()
        if FileManager.default.fileExists(atPath: path){
            if let data = NSData(contentsOfFile: path){
                let archiver = NSKeyedUnarchiver(forReadingWith: data as Data)
                items = archiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
                archiver.finishDecoding()
            }
        }
    }


}

