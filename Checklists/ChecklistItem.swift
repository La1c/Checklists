//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Vladimir on 17.02.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import Foundation

class ChecklistItem{
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }
    
}
