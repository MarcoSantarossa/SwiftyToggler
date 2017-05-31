//
//  FeatureChangesObserversPoolTests.swift
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

class FeatureChangesObserversPoolTests: XCTestCase {
    
    var pool: FeatureChangesObserversPool!
    
    override func setUp() {
        super.setUp()
        
        pool = FeatureChangesObserversPool()
    }
    
    override func tearDown() {
        pool = nil
        
        super.tearDown()
    }
    
    func test_Notify_WithoutRightObservers_DoesNotCallFeatureDidChange() {
        let feature = StubFeature()
        let observer = SpyFeatureChangesObserver()
        pool.addObserver(observer, featureNames: ["Swift"])
        
        pool.notify(for: feature, featureName: "XCTest")
        
        XCTAssertEqual(observer.featureDidChangeCalledCount, 0)
    }
    
	func test_Notify_FeatureNotEnableWithObserver_CallsFeatureDidChange() {
		let feature = StubFeature()
		let observer = SpyFeatureChangesObserver()
		pool.addObserver(observer, featureNames: ["Swift"])

		pool.notify(for: feature, featureName: "Swift")

		XCTAssertEqual(observer.featureDidChangeCalledCount, 1)
		XCTAssertEqual(observer.featureDidChangeNameArgument, "Swift")
		XCTAssertFalse(observer.featureDidChangeIsEnableArgument!)
	}

	func test_Notify_FeatureEnableWithObserver_CallsFeatureDidChange() {
		let feature = StubFeature()
		feature.isEnabled = true
		let observer = SpyFeatureChangesObserver()
		pool.addObserver(observer, featureNames: ["Swift"])

		pool.notify(for: feature, featureName: "Swift")

		XCTAssertEqual(observer.featureDidChangeCalledCount, 1)
		XCTAssertEqual(observer.featureDidChangeNameArgument, "Swift")
		XCTAssertTrue(observer.featureDidChangeIsEnableArgument!)
	}
	
	func test_Notify_ObserverAllFeatures_CallsFeatureDidChange() {
		let feature = StubFeature()
		feature.isEnabled = true
		let observer = SpyFeatureChangesObserver()
		pool.addObserver(observer, featureNames: nil)

		pool.notify(for: feature, featureName: "Swift")
		pool.notify(for: feature, featureName: "Swift 3")

		XCTAssertEqual(observer.featureDidChangeCalledCount, 2)
		XCTAssertEqual(observer.featureDidChangeNameArgument, "Swift 3")
		XCTAssertTrue(observer.featureDidChangeIsEnableArgument!)
	}
	
    func test_Notify_ARightObserverAndAWrongObserver_CallsOneFeatureDidChange() {
        let feature = StubFeature()
        let observer = SpyFeatureChangesObserver()
        let observer2 = SpyFeatureChangesObserver()
        pool.addObserver(observer, featureNames: ["Swift"])
        pool.addObserver(observer2, featureNames: ["XCTest"])
        
        pool.notify(for: feature, featureName: "Swift")
        
        XCTAssertEqual(observer.featureDidChangeCalledCount, 1)
		XCTAssertEqual(observer.featureDidChangeNameArgument, "Swift")

        XCTAssertEqual(observer2.featureDidChangeCalledCount, 0)
    }
    
    func test_Notify_TwoRightObservers_CallsBothFeatureDidChange() {
        let feature = StubFeature()
        let observer = SpyFeatureChangesObserver()
        let observer2 = SpyFeatureChangesObserver()
        pool.addObserver(observer, featureNames: ["Swift"])
        pool.addObserver(observer2, featureNames: ["Swift"])
        
        pool.notify(for: feature, featureName: "Swift")
        
        XCTAssertEqual(observer.featureDidChangeCalledCount, 1)
		XCTAssertEqual(observer.featureDidChangeNameArgument, "Swift")

        XCTAssertTrue(observer2.featureDidChangeCalledCount == 1)
		XCTAssertEqual(observer2.featureDidChangeNameArgument, "Swift")
    }
    
	func test_Notify_ObserverInsertedTwice_CallsFeatureDidChangeOnce() {
		let feature = StubFeature()
		let observer = SpyFeatureChangesObserver()
		pool.addObserver(observer, featureNames: ["Swift"])
		pool.addObserver(observer, featureNames: ["Swift"])

		pool.notify(for: feature, featureName: "Swift")

		XCTAssertEqual(observer.featureDidChangeCalledCount, 1)
		XCTAssertEqual(observer.featureDidChangeNameArgument, "Swift")
	}

	func test_Notify_ObserverAllFeaturesInsertedTwice_CallsFeatureDidChangeOnce() {
		let feature = StubFeature()
		let observer = SpyFeatureChangesObserver()
		pool.addObserver(observer, featureNames: nil)
		pool.addObserver(observer, featureNames: nil)

		pool.notify(for: feature, featureName: "Swift")

		XCTAssertEqual(observer.featureDidChangeCalledCount, 1)
		XCTAssertEqual(observer.featureDidChangeNameArgument, "Swift")
	}
	
	func test_Notify_ObserverAllFeaturesAndObserverSpecificFeature_CallsFeatureDidChangeOnce() {
		let feature = StubFeature()
		let observer = SpyFeatureChangesObserver()
		pool.addObserver(observer, featureNames: nil)
		pool.addObserver(observer, featureNames: ["Swift"])

		pool.notify(for: feature, featureName: "Swift")

		XCTAssertEqual(observer.featureDidChangeCalledCount, 1)
		XCTAssertEqual(observer.featureDidChangeNameArgument, "Swift")
	}
	
	func test_Notify_ObserverAllFeaturesAndObserverSpecificAnotherFeature_CallsFeatureDidChangeOnce() {
		let feature = StubFeature()
		let observer = SpyFeatureChangesObserver()
		pool.addObserver(observer, featureNames: nil)
		pool.addObserver(observer, featureNames: ["Swift 2"])

		pool.notify(for: feature, featureName: "Swift")

		XCTAssertEqual(observer.featureDidChangeCalledCount, 1)
		XCTAssertEqual(observer.featureDidChangeNameArgument, "Swift")
	}
	
    func test_Notify_AfterRemovingLastObserverForFeature_DoesNotCallFeatureDidChange() {
        let feature = StubFeature()
        let observer = SpyFeatureChangesObserver()
        pool.addObserver(observer, featureNames: ["Swift"])
        pool.removeObserver(observer, featureNames: ["Swift"])
        
        pool.notify(for: feature, featureName: "Swift")
        
        XCTAssertEqual(observer.featureDidChangeCalledCount, 0)
    }
    
    func test_Notify_AfterRemovingAnObserverForFeature_DoesNotCallFeatureDidChange() {
        let feature = StubFeature()
        let observer = SpyFeatureChangesObserver()
        let observer2 = SpyFeatureChangesObserver()
        pool.addObserver(observer, featureNames: ["Swift"])
        pool.addObserver(observer2, featureNames: ["Swift"])
        pool.removeObserver(observer, featureNames: ["Swift"])
        
        pool.notify(for: feature, featureName: "Swift")
        
        XCTAssertEqual(observer.featureDidChangeCalledCount, 0)
    }
    
    func test_Notify_AfterRemovingObserverForAnotherFeature_CallsFeatureDidChangeForRightObserver() {
        let feature = StubFeature()
        let observer = SpyFeatureChangesObserver()
        pool.addObserver(observer, featureNames: ["Swift", "XCTest"])
        pool.removeObserver(observer, featureNames: ["Swift"])
        
        pool.notify(for: feature, featureName: "XCTest")
        
        XCTAssertEqual(observer.featureDidChangeCalledCount, 1)
		XCTAssertEqual(observer.featureDidChangeNameArgument, "XCTest")
    }
    
    func test_Notify_AfterRemovingObserverForAllFeatures_DoesNotCallFeatureDidChange() {
        let feature = StubFeature()
        let observer = SpyFeatureChangesObserver()
        pool.addObserver(observer, featureNames: ["Swift", "XCTest"])
        pool.removeObserver(observer, featureNames: nil)
        
        pool.notify(for: feature, featureName: "XCTest")
        
        XCTAssertEqual(observer.featureDidChangeCalledCount, 0)
    }
    
    func test_Notify_AfterRemovingInvalidFeatureName_CallsFeatureDidChange() {
        let feature = StubFeature()
        let observer = SpyFeatureChangesObserver()
        pool.addObserver(observer, featureNames: ["Swift", "XCTest"])
        pool.removeObserver(observer, featureNames: ["TDD"])
        
        pool.notify(for: feature, featureName: "XCTest")
        
        XCTAssertEqual(observer.featureDidChangeCalledCount, 1)
    }

    func test_Notify_AfterRemovingANotAddedObserver_DoesNotCallFeatureDidChange() {
        let feature = StubFeature()
        let observer = SpyFeatureChangesObserver()
        pool.removeObserver(observer, featureNames: nil)
        
        pool.notify(for: feature, featureName: "XCTest")
        
        XCTAssertEqual(observer.featureDidChangeCalledCount, 0)
    }
    
}
