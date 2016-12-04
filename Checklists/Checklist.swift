//
//  Checklist.swift
//  Checklists
//
//  Created by Vladimir on 07.10.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import UIKit
import RealmSwift

class Checklist: Object {
    dynamic var iconName = "Folder"
    dynamic var name = ""
    var items = List<ChecklistItem>()
    
    func countUncheckedItems() -> Int{
        var count = 0
        for item in items where !item.checked{
                count += 1
        }
        return count
    }
}
