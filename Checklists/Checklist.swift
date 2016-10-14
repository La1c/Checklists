//
//  Checklist.swift
//  Checklists
//
//  Created by Vladimir on 07.10.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import UIKit

//NSObject is allowed to use NSCoder
class Checklist: NSObject {
    var name = ""
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
