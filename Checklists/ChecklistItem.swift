//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Vladimir on 17.02.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import Foundation
import UserNotifications
import RealmSwift

class ChecklistItem: Object{
   dynamic var text = ""
   dynamic var checked = false
   dynamic var shouldRemind = false
   dynamic var dueDate = Date()
   dynamic var itemID: Int = 0
   dynamic var priority = Priority.none.rawValue
    
    func toggleChecked(){
        try! uiRealm.write {
            checked = !checked
        }
        
    }
        
    deinit {
        removeNotification()
    }
    
    func scheduleNotification(){
        removeNotification()
        if shouldRemind && dueDate > Date(){
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month,.day,.hour,.minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: String(itemID), content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    
    func removeNotification(){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [String(itemID)])
    }
    
}
