//
//  FeatureProxyTests.swift
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

@testable import SwiftyToggler

import XCTest

class FeatureProxyTests: XCTestCase {
    
    private var feature: StubFeature!
    private var proxy: FeatureProxy!

    override func setUp() {
        super.setUp()

        feature = StubFeature()
        proxy = FeatureProxy(feature: feature, shouldRunWhenEnabled: false)
    }
    
    override func tearDown() {
        proxy = nil
        feature = nil
        
        super.tearDown()
    }
    
    func test_Init_FeatureIsSet() {
        XCTAssertTrue(proxy.feature === feature)
    }
    
    func test_IsFeatureEnable_FeatureNotEnable_IsFalse() {
        XCTAssertFalse(proxy.isFeatureEnable)
    }
    
    func test_IsFeatureEnable_FeatureEnable_IsTrue() {
        feature.isEnabled = true
        
        XCTAssertTrue(proxy.isFeatureEnable)
    }
    
    func test_IsFeatureEnable_SetTrue_ReturnsTrue() {
        proxy.isFeatureEnable = true
        
        XCTAssertTrue(proxy.isFeatureEnable)
    }
    
    func test_IsFeatureEnable_SetTrue_FeatureIsEnable() {
        proxy.isFeatureEnable = true
        
        XCTAssertTrue(feature.isEnabled)
    }
    
    func test_IsFeatureEnable_SetFalse_ReturnsFalse() {
        feature.isEnabled = true

        proxy.isFeatureEnable = false
        
        XCTAssertFalse(proxy.isFeatureEnable)
    }
    
    func test_IsFeatureEnable_SetFalse_FeatureIsNotEnable() {
        feature.isEnabled = true

        proxy.isFeatureEnable = false
        
        XCTAssertFalse(feature.isEnabled)
    }

	func test_IsFeatureEnable_SetTrueWithShouldRunWhenEnabledFalse_MainIsNotCalled() {
		proxy.isFeatureEnable = true

		XCTAssertFalse(feature.isMainCalled)
	}

    func test_IsFeatureEnable_SetTrueWithShouldRunWhenEnabledTrue_MainIsCalled() {
        proxy.shouldRunWhenEnabled = true
        proxy.isFeatureEnable = true
        
        XCTAssertTrue(feature.isMainCalled)
    }
    
    func test_IsFeatureEnable_AlreadyTrueSetTrueAndShouldRunWhenEnabledTrue_MainIsNotCalled() {
        proxy.shouldRunWhenEnabled = true
        feature.isEnabled = true
        
        proxy.isFeatureEnable = true
        
        XCTAssertFalse(feature.isMainCalled)
    }
    
    func test_IsFeatureEnable_SetFalse_DisposeIsCalled() {
        feature.isEnabled = true
        
        proxy.isFeatureEnable = false
        
        XCTAssertTrue(feature.isDisposeCalled)
    }
    
    func test_IsFeatureEnable_SetTrue_DisposeIsNotCalled() {
        feature.isEnabled = false
        
        proxy.isFeatureEnable = true
        
        XCTAssertFalse(feature.isDisposeCalled)
    }
    
    func test_Run_FeatureNotEnable_MainIsNotCalled() {
        proxy.run()
        
        XCTAssertFalse(feature.isMainCalled)
    }
    
    func test_Run_FeatureNotEnable_ReturnsFalse() {
        let result = proxy.run()
        
        XCTAssertFalse(result)
    }
    
    func test_Run_FeatureEnable_MainIsCalled() {
        feature.isEnabled = true
        
        proxy.run()
        
        XCTAssertTrue(feature.isMainCalled)
    }
    
    func test_Run_FeatureEnable_ReturnsTrue() {
        feature.isEnabled = true
        
        let result = proxy.run()
        
        XCTAssertTrue(result)
    }
}
