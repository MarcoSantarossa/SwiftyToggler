//
//  FeatureTests.swift
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

class FeatureTests: XCTestCase {
    
    func test_Init_PayloadNil_PayloadIsNil() {
        let feature = Feature<Any>(payload: nil)
        
        XCTAssertNil(feature.payload)
    }
    
    func test_Init_GenericTypeString_PayloadIsString() {
        let feature = Feature(payload: "payload")
        guard let payload = feature.payload else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(type(of: payload) == String.self)
    }
    
    func test_Init_ValidPayload_PayloadIsSet() {
        let feature = Feature(payload: "payload")
        guard let payload = feature.payload else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(payload, "payload")
    }
    
    func test_Init_DefaultIsEnable_IsEnableIsFalse() {
        let feature = Feature<Any>(payload: nil)
        
        XCTAssertFalse(feature.isEnabled)
    }
    
    func test_Init_IsEnableTrue_IsEnableIsTrue() {
        let feature = Feature<Any>(payload: nil, isEnabled: true)
        
        XCTAssertTrue(feature.isEnabled)
    }
    
    func test_Main_ThrowsFatalError() {
        let feature = Feature(payload: "payload")
        
        expectFatalError(expectedMessage: "Feature base class: main method not implemented") {
            feature.main()
        }
    }
}
