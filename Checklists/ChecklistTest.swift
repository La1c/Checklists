//
//  ChecklistTest.swift
//  Checklists
//
//  Created by Vladimir on 04.12.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import XCTest
//import RealmSwift

@testable import Checklists


class ChecklistTest: XCTestCase {
    
    var checklist: Checklist!
    
    override func setUp() {
        super.setUp()
        
        let watchItem = ChecklistItem() //this one is completed and two others are not
        watchItem.checked = true
        watchItem.priority = Priority.none.rawValue
        watchItem.itemID = 1
        watchItem.text = "Watch a movie"
        
        let readItem = ChecklistItem()
        readItem.checked = false
        readItem.priority = Priority.none.rawValue
        readItem.itemID = 2
        readItem.text = "Read a book"
        
        
        let walkItem = ChecklistItem()
        walkItem.checked = false
        walkItem.priority = Priority.none.rawValue
        walkItem.itemID = 3
        walkItem.text = "Walk"
        
        
        checklist = Checklist()
        checklist.name = "To Do"
        checklist.items.append(objectsIn: [watchItem, readItem, walkItem])
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        checklist = nil
    }
    
    func testNumberOfUncheckedItemsInTheList(){
        let remainingItems = checklist.countUncheckedItems()
        XCTAssertTrue(remainingItems == 2)
    }
    
    
    func testNumberOfUncheckedItemsInTheListChanged(){
        try! uiRealm.write{
            checklist.items[1].checked = true
        }
        let remainingItems = checklist.countUncheckedItems()
        XCTAssertTrue(remainingItems == 1)
    }
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
