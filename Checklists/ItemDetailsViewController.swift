//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Vladimir on 11.08.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import Foundation
import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidClancel(controller: ItemDetailViewController)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?

    @IBAction func done() {
        if let item = itemToEdit{
            item.text = textField.text!
            delegate?.itemDetailViewController(controller: self, didFinishEditingItem: item)
        }else{
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            delegate?.itemDetailViewController(controller: self, didFinishAddingItem: item)
        }
    }
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidClancel(controller: self)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit{
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldText = textField.text as NSString? {
            let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
            doneBarButton.isEnabled = newText.length > 0
        }
        return true
    }
    
    
    
    
}
