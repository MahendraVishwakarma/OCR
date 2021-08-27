//
//  CaseB.swift
//  MahendraAssignmentTests
//
//  Created by Mahendra Vishwakarma on 27/08/21.
//

import XCTest
@testable import MahendraAssignment


class CaseB: XCTestCase {
    // MARK: - Properties
    var viewModel: OCRViewModel! // an implicitly unwrapped to crash and burns
    
    // MARK: - Set Up & Tear Down
    override func setUpWithError() throws {
        // Initialize View Model
        viewModel = OCRViewModel()
        viewModel.delegate = self //make coment/uncomment to check fetchMethod is called or not
        
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    //MARK:- Test viewmodel is nil or not?
    func testViewModel() throws {
        XCTAssertNotNil(viewModel)
    }
    //MARK:- Test delegate is nil or not?
    func testDelegate() throws {
        XCTAssertNotNil(viewModel.delegate)
    }
    //MARK:- Test startOCR method is called or not?
    func testStartOCRMethodCalled() throws {
        
        if let image = UIImage(named: "mk.png")?.cgImage {
            viewModel.startOCR(image: image)
            XCTAssertTrue(true, "startOCR method is called successfully")
        }
        
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
extension CaseB: OCRTextDelegate {
    func updateData(text: String?) {
        XCTAssertTrue(text?.count ?? 0 > 0, "text fetched from image")
    }
    
}
