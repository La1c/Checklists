//
//  ViewController.swift
//  Checklists
//
//  Created by Vladimir on 01.02.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    var items: [ChecklistItem]
    
    required init? (coder aDecoder: NSCoder)
    {
        items = [ChecklistItem]()
        let row0item = ChecklistItem()
        row0item.text = "Walk the dog"
        row0item.checked = false
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "Brush my teeth"
        row1item.checked = false
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "Learn iOS development"
        row2item.checked = false
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "Soccer practice"
        row3item.checked = false
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item.text = "Eat ice cream"
        row4item.checked = false
        items.append(row4item)
        
        let row5item = ChecklistItem()
        row5item.text = "Eat more ice cream"
        row5item.checked = false
        items.append(row5item)
        
        let row6item = ChecklistItem()
        row6item.text = "Eat even more ice cream!"
        row6item.checked = false
        items.append(row6item)
        
        super.init(coder: aDecoder)
    }
    
    @IBAction func addItem(){
        let newRowIndex = items.count
        let item = ChecklistItem()
        item.text = "I am a new item"
        item.checked = true
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows( at: indexPaths, with: .automatic)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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

        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
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
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                                               forRowAt indexPath: IndexPath) {
        items.remove(at: (indexPath as NSIndexPath).row)
        
        let indexPaths = [indexPath]
        
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }


}

