//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Vladimir on 11.08.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidClancel(controller: ItemDetailViewController)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var prioritySegmentControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var datePickerCell: UITableViewCell!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    var dueDate = Date()
    var datePickerVisible = false
    var priority = Priority.none


    @IBAction func priorityValueChanged(_ sender: UISegmentedControl) {
        priority = Priority(rawValue: sender.titleForSegment(at: sender.selectedSegmentIndex)!) ?? Priority.none
    }
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()
        
        if switchControl.isOn{
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound], completionHandler: {_,_ in })
        }
    }
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    @IBAction func done() {
        if let item = itemToEdit{
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.priority = priority
            item.scheduleNotification()
            delegate?.itemDetailViewController(controller: self, didFinishEditingItem: item)
            
        }else{
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.priority = priority
            item.scheduleNotification()
            
            delegate?.itemDetailViewController(controller: self, didFinishAddingItem: item)
        }
    }
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidClancel(controller: self)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 2 && indexPath.row == 1{
            return indexPath
        }else{
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit{
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
            textField.delegate = self
            priority = item.priority
        }
        
        updateDueDateLabel()
        updatePrioritySegmentControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = newText.length > 0
        
        return true
    }
    
    func updatePrioritySegmentControl(){
        switch priority {
        case .none:
            prioritySegmentControl.selectedSegmentIndex = 0
        case .normal:
            prioritySegmentControl.selectedSegmentIndex = 1
        case .high:
            prioritySegmentControl.selectedSegmentIndex = 2
        case .veryHigh:
            prioritySegmentControl.selectedSegmentIndex = 3
        }
    }
    
    func updateDueDateLabel(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    func showDatePicker(){
        datePickerVisible = true
        
        let indexPathDateRow = IndexPath(row: 1, section: 2)
        let indexPathDatePicker = IndexPath(row: 2, section: 2)
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow){
            dateCell.detailTextLabel!.textColor = view.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        datePicker.setDate(dueDate, animated: false)
    }
    
    func hideDatePicker(){
        if datePickerVisible{
            datePickerVisible = false
            
            let indexPathRow = IndexPath(row:1, section: 2)
            let indexPathDatePicker = IndexPath(row:2, section: 2)
            
            if let cell = tableView.cellForRow(at: indexPathRow){
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 && indexPath.row == 2{
            return datePickerCell
        } else{
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 && datePickerVisible{
            return 3
        } else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 2{
            return 217
        } else{
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        
        if indexPath.section == 2 && indexPath.row == 1{
            if !datePickerVisible{
                showDatePicker()
            }else{
                hideDatePicker()
            }
            
        }
    }
    
    //FIXME: -should hide datePicker but it doesn't
    func textFieldDidBeginEditing(_ textField: UITextField) {
            hideDatePicker()
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 2 && indexPath.row == 2{
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        
    }
}
