//
//  CaseA.swift
//  MahendraAssignmentTests
//
//  Created by Mahendra Vishwakarma on 27/08/21.
//

import XCTest
@testable import MahendraAssignment

class CaseA: XCTestCase {
    // MARK: - Properties
    var viewModel: EventViewModel! // an implicitly unwrapped to crash and burns
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // Initialize View Model
        viewModel = EventViewModel()
        
    }
    
    //MARK:- Test viewmodel is nil or not?
    func testViewModel() throws {
        XCTAssertNotNil(viewModel)
    }
    
    //MARK:- Test getEvent method is called or not?
    func testGetEventMethodCalled() throws {
        
        _ = viewModel.getEvents()
        XCTAssertTrue(true, "getEvents method is called successfully")
        
    }
    //MARK:- Test user list array is nil or not?
    func testUserList() throws {
        XCTAssertNil(viewModel.totalEvents, "event list is nil")
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
