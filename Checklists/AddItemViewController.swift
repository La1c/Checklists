//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Vladimir on 11.08.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import Foundation
import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    @IBAction func done() {
        
        
        if let text = textField.text {
            print("Text is \(text)")
            
            
        } else {
            print("There is no text!")
        }
    
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldText = textField.text as NSString? {
            let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
            if newText.length > 0{
                doneBarButton.isEnabled = true
            } else{
                doneBarButton.isEnabled = false
            }
        }
        return true
    }
    
    
    
}
