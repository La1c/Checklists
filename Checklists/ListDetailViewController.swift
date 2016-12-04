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
    
    var iconName = "Folder"
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    var checkListToEdit: Checklist?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checkListToEdit{
            title = NSLocalizedString("Edit Checklist", comment: "Edit checklist screen title")
            textField.text = checklist.name
            doneBarButton.isEnabled = true
            try! uiRealm.write {
                checklist.iconName = iconName
            }            
        }
        
         iconImageView.image = UIImage(named: iconName)
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    
    @IBAction func done() {
        if let checklist = checkListToEdit{
            try! uiRealm.write {
                checklist.name = textField.text!
                checklist.iconName = iconName
            }
            delegate?.listDetailViewController(controller: self, didFinishEditing: checklist)
        }else{
            
            var checklist:Checklist?
            try! uiRealm.write {
                checklist = Checklist()
                checklist!.name = textField.text!
                checklist!.iconName = iconName
            }
            if let checklist = checklist {delegate?.listDetailViewController(controller: self, didFinishAdding: checklist)}
        }
    }
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidClancel(controller: self)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1{
            return indexPath
        } else{
            return nil
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = newText.length > 0
        return true
    }
}


//MARK: -prepare for segue
extension ListDetailViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon"{
            let vc = segue.destination as! IconPickerViewController
            vc.delegate = self
        }
    }
}

extension ListDetailViewController: IconPickerViewControllerDelegate{
    func iconPicker(picker: IconPickerViewController, didPick iconName: String) {
        iconImageView.image = UIImage(named: iconName)
        self.iconName = iconName
        let _ = navigationController?.popViewController(animated: true)
    }
}
