//
//  Checklist.swift
//  Checklists
//
//  Created by Vladimir on 07.10.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import UIKit

//NSObject is allowed to use NSCoder
class Checklist: NSObject, NSCoding {
    var iconName:String
    var name = ""
    var items = [ChecklistItem]()
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }
    
    init(name: String, iconName: String? = nil) {
        self.name = name
        self.iconName = iconName ?? "No Icon"
        super.init()
    }
    
    func countUncheckedItems() -> Int{
        var count = 0
        for item in items where !item.checked{
                count += 1
        }
        return count
    }
}
