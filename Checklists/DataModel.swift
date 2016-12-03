//
//  DataModel.swift
//  Checklists
//
//  Created by Vladimir on 17.10.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import Foundation
import RealmSwift

class DataModel{
    var lists:Results<Checklist>!
    
    
    var indexOfSelectedChecklist:Int{
        get{
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    required init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    func registerDefaults(){
        let dictionary: [String: Any] = ["ChecklistIndex": -1,
                                         "FirstTime": true,
                                         "ChecklistItemID": 0]
        UserDefaults.standard.register(defaults: dictionary)
        
    }
    
    
    func saveChecklists(){
        
        try! uiRealm.write{
            uiRealm.add(lists, update: false)
        }
    }
    
    func addChecklist(checklist: Checklist){
        try! uiRealm.write {
            uiRealm.add(checklist, update: false)
        }
        
        loadChecklists()
    }
    
    func loadChecklists(){
        
        lists = uiRealm.objects(Checklist.self).sorted(byProperty: "name")
    }
    
    func remove(list at: IndexPath){
        try! uiRealm.write({ () -> Void in
            uiRealm.delete(lists[at.row])
        })
         loadChecklists()
    }
    
    func handleFirstTime(){
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime{
            let checklist = Checklist()
            checklist.name = NSLocalizedString("List", comment: "Default list name for the first app lauch")
            checklist.iconName = "Folder"
            try! uiRealm.write {
                uiRealm.add(checklist)
                }
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    func sortChecklists(){
       lists = lists.sorted(byProperty: "name")
    }
    
    static func nextChecklistItemID() -> Int{
        
        
        
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }

}
