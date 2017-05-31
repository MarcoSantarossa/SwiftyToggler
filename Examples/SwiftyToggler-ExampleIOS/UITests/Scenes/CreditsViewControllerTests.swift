//
//  CreditsViewControllerTests.swift
//
//  Copyright (c) 2017 Marco Santarossa (https://marcosantadev.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import XCTest

class CreditsViewControllerTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        app.buttons["load_enable_features"].tap()

		app.navigationBars["SwiftyToggler-Example"].buttons["Credits"].tap()
    }
    
    func test_NavigationBarTitle_IsVisible() {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.navigationBars["Credits"].exists)
    }
    
    func test_Title_IsVisible() {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.staticTexts["SwiftyToggler"].exists)
    }
    
    func test_TextView_IsVisible() {
        let app = XCUIApplication()
        app.textViews["credits_textview"].tap()
        
        guard let textViewText = app.textViews["credits_textview"].value as? String else {
            XCTFail()
            return
        }
        XCTAssertTrue(textViewText.hasPrefix("This library has been created by Marco Santarossa (https://marcosantadev.com)."))
    }
}
