//
//  picletUITests.swift
//  picletUITests
//
//  Created by Filipe Santos Correa on 18/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import XCTest

class picletUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false

        if #available(iOS 9.0, *) {
            XCUIApplication().launch()
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateAccount() {
        
        if #available(iOS 9.0, *) {
            XCUIApplication().launch()
            
            let app = XCUIApplication()
            let usernameTextField = app.textFields["Username"]
            usernameTextField.tap()
            usernameTextField.typeText("fgh")
            app.buttons["Create account"].tap()
            
            XCTAssertEqual(app.alerts.element.exists, true)
            app.alerts["Username invalid"].collectionViews.buttons["OK"].tap()
            XCTAssertEqual(app.alerts.element.exists, false)
        }
        
    }
    
}
