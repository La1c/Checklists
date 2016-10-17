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
    var name = ""
    var items = [ChecklistItem]()
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
    }
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
