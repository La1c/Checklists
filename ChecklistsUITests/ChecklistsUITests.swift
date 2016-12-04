//
//  ChecklistsUITests.swift
//  ChecklistsUITests
//
//  Created by Vladimir on 04.12.16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

import XCTest

class ChecklistsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        
        
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddingNewList(){
        
        let app = XCUIApplication()
        let expectedNumberOfLists = app.tables.cells.count + 1
        app.navigationBars["Checklists"].buttons["Add"].tap()
        app.tables.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element.typeText("List")
        app.navigationBars["Add Checklist"].buttons["Done"].tap()
        
        
        XCTAssertEqual(app.tables.cells.count, expectedNumberOfLists)
        
    }
    
    
    func testCreatingNewItem(){
         let app = XCUIApplication()
         app.tables.cells.element(boundBy: 0).staticTexts["List"].tap()
        let expectedNumberOfLists = app.tables.cells.count + 1
        app.navigationBars["List"].buttons["Add"].tap()
        app.tables.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element.typeText("Item")
        app.navigationBars["Add Item"].buttons["Done"].tap()
        
        XCTAssertEqual(app.tables.cells.count, expectedNumberOfLists)
        
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
