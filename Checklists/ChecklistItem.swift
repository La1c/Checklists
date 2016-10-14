//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Vladimir on 17.02.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding{
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
    override init(){
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    
}
