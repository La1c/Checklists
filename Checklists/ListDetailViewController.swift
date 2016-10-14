//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Vladimir on 14.10.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class{
    func listDetailViewControllerDidClancel(controller: ListDetailViewController)
    func listDetailViewController(controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}


class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    var checkListToEdit: Checklist?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checkListToEdit{
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    
    @IBAction func done() {
        if let checklist = checkListToEdit{
            checklist.name = textField.text!
            delegate?.listDetailViewController(controller: self, didFinishEditing: checklist)
        }else{
            let checklist = Checklist(name: textField.text!)
            delegate?.listDetailViewController(controller: self, didFinishAdding: checklist)
        }
    }
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidClancel(controller: self)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = newText.length > 0
        return true
    }

}