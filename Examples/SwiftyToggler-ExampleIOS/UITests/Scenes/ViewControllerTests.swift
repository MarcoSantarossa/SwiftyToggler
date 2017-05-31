//
//  ViewControllerTests.swift
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

class ViewControllerTests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        XCUIApplication().launch()
    }
    
    func test_ShowModalFeaturesListTap_ShowFeaturesListView() {
        let app = XCUIApplication()
        
        app.buttons["show_modal_features_list"].tap()
        
        let featuresListView = app.otherElements["features_list_view"]
        XCTAssertTrue(featuresListView.exists)
    }
    
    func test_FeaturesListView_BeforeAddingFeatures_IsEmpty() {
        let app = XCUIApplication()
        
        app.buttons["show_modal_features_list"].tap()
        
        let featuresListView = app.otherElements["features_list_view"]
        let tableView = featuresListView.tables["features_list_table_view"]
        XCTAssertEqual(tableView.cells.count, 0)
    }
    
    func test_FeaturesListView_BeforeAddingFeatures_ShowsPlaceholder() {
        let app = XCUIApplication()
        
        app.buttons["show_modal_features_list"].tap()
        
        let featuresListView = app.otherElements["features_list_view"]
        XCTAssertTrue(featuresListView.staticTexts["No Features Available"].exists)
    }
    
    func test_FeaturesListView_FeaturesLoaded_IsNotEmpty() {
        let app = XCUIApplication()
        app.buttons["load_features"].tap()
        
        app.buttons["show_modal_features_list"].tap()
        
        let featuresListView = app.otherElements["features_list_view"]
        let tableView = featuresListView.tables["features_list_table_view"]
        XCTAssertEqual(tableView.cells.count, 1)
    }
    
    func test_FeatureListView_FeaturesLoaded_FirstRowIsCredits() {
        let app = XCUIApplication()
        app.buttons["load_features"].tap()
        
        app.buttons["show_modal_features_list"].tap()
        
        let featuresListView = app.otherElements["features_list_view"]
        let tableView = featuresListView.tables["features_list_table_view"]
        XCTAssertTrue(tableView.cells.element(boundBy: 0).staticTexts["Credits"].exists)
    }
    
	func test_CreditsFeatureSwift_AfterLoadingFeatures_IsDisabled() {
		let app = XCUIApplication()
		app.buttons["load_features"].tap()
		app.buttons["show_modal_features_list"].tap()

		let featureSwitch = app.tables["features_list_table_view"].switches["Credits"]
		guard let isOn = featureSwitch.value as? String else {
			XCTFail()
			return
		}
		XCTAssertEqual(isOn, "0")
	}
	
	func test_CreditsFeatureSwift_AfterLoadingAndEnabledAllFeatures_IsEnabled() {
		let app = XCUIApplication()
		app.buttons["load_enable_features"].tap()
		app.buttons["show_modal_features_list"].tap()

		let featureSwitch = app.tables["features_list_table_view"].switches["Credits"]
		guard let isOn = featureSwitch.value as? String else {
			XCTFail()
			return
		}
		XCTAssertEqual(isOn, "1")
	}
	
	func test_CreditsButton_BeforeAddingFeatures_IsNotVisible() {
		let app = XCUIApplication()
		app.buttons["load_features"].tap()
		app.buttons["show_modal_features_list"].tap()

		XCTAssertFalse(app.navigationBars["SwiftyToggler-Example"].buttons["Credits"].exists)
	}
	
    func test_CreditsButton_FeaturesLoadedCreditsNotEnabled_IsNotVisible() {
        let app = XCUIApplication()
        app.buttons["load_features"].tap()
        app.buttons["show_modal_features_list"].tap()
        
        XCTAssertFalse(app.navigationBars["SwiftyToggler-Example"].buttons["Credits"].exists)
    }
    
	func test_CreditsButton_FeaturesLoadedCreditsEnabled_Visible() {
		let app = XCUIApplication()
		app.buttons["load_features"].tap()
		app.buttons["show_modal_features_list"].tap()

		app.tables["features_list_table_view"].switches["Credits"].tap()
		app.buttons["Close"].tap()

		XCTAssertTrue(app.navigationBars["SwiftyToggler-Example"].buttons["Credits"].exists)
	}

	func test_CreditsButton_FeaturesLoadedCreditsDisabledAfterEnabled_Disappear() {
		let app = XCUIApplication()
		app.buttons["load_features"].tap()
		app.buttons["show_modal_features_list"].tap()

		app.tables["features_list_table_view"].switches["Credits"].tap()
		app.tables["features_list_table_view"].switches["Credits"].tap()
		app.buttons["Close"].tap()

		XCTAssertFalse(app.navigationBars["SwiftyToggler-Example"].buttons["Credits"].exists)
	}

	func test_CreditsButtonTap_OpensCreditsView() {
		let app = XCUIApplication()
		app.buttons["load_enable_features"].tap()

		app.navigationBars["SwiftyToggler-Example"].buttons["Credits"].tap()

		XCTAssertTrue(app.navigationBars["Credits"].exists)
	}

	func test_PushFeaturesListDidTap_OpensFeatureListInNewViewController() {
		let app = XCUIApplication()
		app.buttons["push_features_list"].tap()

		XCTAssertTrue(app.navigationBars["Features List"].exists)
	}
}
