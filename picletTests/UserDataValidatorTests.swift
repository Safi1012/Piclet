//
//  UserDataValidatorTests.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import XCTest

class UserDataValidatorTests: XCTestCase {
    
    var networkHandler: NetworkHandler?
    
    override func setUp() {
        super.setUp()

        networkHandler = NetworkHandler()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testContainsSpecialCharacters_0() {
        XCTAssertFalse(UserDataValidator().containsSpecialCharacters("Hallo1234"))
    }
    
    func testContainsSpecialCharacters_1() {
        XCTAssertTrue(UserDataValidator().containsSpecialCharacters("Hallo 1234"))
    }
    
    func testContainsSpecialCharacters_2() {
        XCTAssertFalse(UserDataValidator().containsSpecialCharacters(""))
    }
    
    func testContainsSpecialCharacters_3() {
        XCTAssertTrue(UserDataValidator().containsSpecialCharacters("Ytes.!-03-[]'.;.';''']["))
    }

}



