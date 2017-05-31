//
//  FeaturesManagerTests.swift
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
import UIKit

import XCTest

//swiftlint:disable file_length
class FeaturesManagerTests: XCTestCase {
    
    private var manager: FeaturesManager!
	private var observersPool: SpyFeatureChangesObserversPool!
	private var featuresListCoordinator: SpyFeaturesListCoordinator!

    override func setUp() {
        super.setUp()
        
		observersPool = SpyFeatureChangesObserversPool()
		featuresListCoordinator = SpyFeaturesListCoordinator()
		manager = FeaturesManager(featureChangesObserversPool: observersPool, featuresListCoordinator: featuresListCoordinator)
    }
    
    override func tearDown() {
        manager = nil
		observersPool = nil
		featuresListCoordinator = nil

        super.tearDown()
    }

	func test_Features_WithoutFeatures_IsEmpty() {
		XCTAssertTrue(manager.featuresStatus.isEmpty)
	}

	func test_Features_OneFeature_HasFeature() {
		let feature = StubFeature()
		feature.isEnabled = true
		manager.add(feature: feature, name: "Feature Test")

		XCTAssertEqual(manager.featuresStatus.first!.name, "Feature Test")
		XCTAssertTrue(manager.featuresStatus.first!.isEnabled)
	}

	func test_Features_ThreeFeatures_HasFeaturesOrdered() {
		let feature1 = StubFeature()
		feature1.isEnabled = true
		let feature2 = StubFeature()
		let feature3 = StubFeature()
		feature3.isEnabled = true
		manager.add(feature: feature2, name: "Feature Test2")
		manager.add(feature: feature3, name: "Feature Test3")
		manager.add(feature: feature1, name: "Feature Test")

		XCTAssertEqual(manager.featuresStatus.first!.name, "Feature Test")
		XCTAssertTrue(manager.featuresStatus.first!.isEnabled)

		XCTAssertEqual(manager.featuresStatus[1].name, "Feature Test2")
		XCTAssertFalse(manager.featuresStatus[1].isEnabled)

		XCTAssertEqual(manager.featuresStatus[2].name, "Feature Test3")
		XCTAssertTrue(manager.featuresStatus[2].isEnabled)
	}

	func test_Add_AddFeaturesToDict() {
		let feature = StubFeature()
		manager.add(feature: feature, name: "Feature Test")

		do {
			try manager.run(featureName: "Feature Test")
			XCTAssertTrue(true)
		} catch {
			XCTFail()
		}
	}

    func test_Run_NoFeaturesAndWrongKey_ThrowsErrorFeatureNotFound() {
        do {
            try manager.run(featureName: "Feature Test")
			XCTFail()
        } catch SwiftyTogglerError.featureNotFound {
            XCTAssertTrue(true)
        } catch {
            XCTFail()
        }
    }
    
    func test_Run_FeaturesAndWrongKey_ThrowsErrorFeatureNotFound() {
        let feature = StubFeature()
        manager.add(feature: feature, name: "test2")

        do {
            try manager.run(featureName: "Feature Test")
			XCTFail()
        } catch SwiftyTogglerError.featureNotFound {
            XCTAssertTrue(true)
        } catch {
            XCTFail()
        }
    }
    
    func test_Run_FeaturesAndRightKeyAndNotEnableFeature_ProxyRunIsNotCalled() {
        let feature = StubFeature()
        manager.add(feature: feature, name: "Feature Test")
        
        do {
            let result = try manager.run(featureName: "Feature Test")
            XCTAssertFalse(result)
            XCTAssertFalse(feature.isMainCalled)
        } catch {
            XCTFail()
        }
    }
    
    func test_Run_FeaturesAndRightKeyAndEnableFeature_ProxyRunIsCalled() {
        let feature = StubFeature()
        feature.isEnabled = true
        manager.add(feature: feature, name: "Feature Test")
        
        do {
            let result = try manager.run(featureName: "Feature Test")
            XCTAssertTrue(feature.isMainCalled)
            XCTAssertTrue(result)
        } catch {
            XCTFail()
        }
    }
    
    func test_Run_AfterRemovingFeature_ThrowsErrorFeatureNotFound() {
        let feature = StubFeature()
        manager.add(feature: feature, name: "Feature Test")
        manager.remove(featureName: "Feature Test")
        
        do {
            try manager.run(featureName: "Feature Test")
			XCTFail()
        } catch SwiftyTogglerError.featureNotFound {
            XCTAssertTrue(true)
        } catch {
            XCTFail()
        }
    }
    
	func test_Run_AfterRemovingAnotherFeature_ProxyRunIsCalled() {
		let feature = StubFeature()
		feature.isEnabled = true
		manager.add(feature: feature, name: "Feature Test")
		manager.remove(featureName: "Feature Test_2")

		do {
            let result = try manager.run(featureName: "Feature Test")
            XCTAssertTrue(feature.isMainCalled)
            XCTAssertTrue(result)
		} catch {
			XCTFail()
		}
	}
	
	func test_Run_AfterRemovingAllFeatures_ThrowsErrorFeatureNotFound() {
		let feature = StubFeature()
		manager.add(feature: feature, name: "Feature Test")
		manager.add(feature: feature, name: "Feature Test2")
		manager.removeAll()

		do {
            try manager.run(featureName: "Feature Test")
			XCTFail()
		} catch SwiftyTogglerError.featureNotFound {
			XCTAssertTrue(true)
		} catch {
			XCTFail()
		}
	}

    func test_IsEnable_NoFeaturesAndWrongKey_ThrowsErrorFeatureNotFound() {
        do {
            _ = try manager.isEnabled(featureName: "Feature Test")
			XCTFail()
        } catch SwiftyTogglerError.featureNotFound {
            XCTAssertTrue(true)
        } catch {
            XCTFail()
        }
    }
    
    func test_IsEnable_FeaturesAndWrongKey_ThrowsErrorFeatureNotFound() {
        let feature = StubFeature()
        manager.add(feature: feature, name: "Feature Test")
        
        do {
            _ = try manager.isEnabled(featureName: "Feature Test2")
			XCTFail()
        } catch SwiftyTogglerError.featureNotFound {
            XCTAssertTrue(true)
        } catch {
            XCTFail()
        }
    }
    
    func test_IsEnable_FeaturesAndRightKeyAndNotEnableFeature_ReturnsFalse() {
        let feature = StubFeature()
        manager.add(feature: feature, name: "Feature Test")
        
        do {
            let isEnabled = try manager.isEnabled(featureName: "Feature Test")
            XCTAssertFalse(isEnabled)
        } catch {
            XCTFail()
        }
    }
    
    func test_IsEnable_FeaturesAndRightKeyAndEnableFeature_ReturnsTrue() {
        let feature = StubFeature()
        feature.isEnabled = true
        manager.add(feature: feature, name: "Feature Test")
        
        do {
            let isEnabled = try manager.isEnabled(featureName: "Feature Test")
            XCTAssertTrue(isEnabled)
        } catch {
            XCTFail()
        }
    }
    
    func test_SetEnable_NoFeaturesAndWrongKey_ThrowsErrorFeatureNotFound() {
        do {
            try manager.setEnable(false, featureName: "Feature Test")
			XCTFail()
        } catch SwiftyTogglerError.featureNotFound {
            XCTAssertTrue(true)
        } catch {
            XCTFail()
        }
    }
    
    func test_SetEnable_FeaturesAndWrongKey_ThrowsErrorFeatureNotFound() {
        let feature = StubFeature()
        manager.add(feature: feature, name: "Feature Test")
        
        do {
            try manager.setEnable(false, featureName: "Feature Test2")
			XCTFail()
        } catch SwiftyTogglerError.featureNotFound {
            XCTAssertTrue(true)
        } catch {
            XCTFail()
        }
    }
    
    func test_SetEnable_FeaturesAndRightKeySetTrue_FeatureIsEnabled() {
        let feature = StubFeature()
        manager.add(feature: feature, name: "Feature Test")
        
        do {
            try manager.setEnable(true, featureName: "Feature Test")
            let isEnabled = try manager.isEnabled(featureName: "Feature Test")
            XCTAssertTrue(isEnabled)
        } catch {
            XCTFail()
        }
    }
    
    func test_SetEnable_FeaturesAndRightKeySetFalse_FeatureIsNotEnabled() {
        let feature = StubFeature()
        feature.isEnabled = true
        manager.add(feature: feature, name: "Feature Test")
        
        do {
            try manager.setEnable(false, featureName: "Feature Test")
            let isEnabled = try manager.isEnabled(featureName: "Feature Test")
            XCTAssertFalse(isEnabled)
        } catch {
            XCTFail()
        }
    }
    
	func test_SetEnable_FeaturesAndRightKey_CallsNotify() {
		let feature = StubFeature()
		feature.isEnabled = true
		manager.add(feature: feature, name: "Feature Test")
		let observer = SpyFeatureChangesObserver()
		manager.addChangesObserver(observer, featureNames: ["Feature Test", "Feature Test2"])

		do {
			try manager.setEnable(false, featureName: "Feature Test")

			XCTAssertTrue(observersPool.isNotifyCalled)
			XCTAssertTrue(observersPool.notifyArgumentFeature === feature)
			XCTAssertEqual(observersPool.notifyArgumentFeatureName, "Feature Test")
		} catch {
			XCTFail()
		}
	}

	func test_SetEnable_AFeatureAndObserverAllFeatures_CallsNotify() {
		let feature = StubFeature()
		feature.isEnabled = true
		manager.add(feature: feature, name: "Feature Test")
		let observer = SpyFeatureChangesObserver()
		manager.addChangesObserver(observer)

		do {
			try manager.setEnable(false, featureName: "Feature Test")

			XCTAssertTrue(observersPool.isNotifyCalled)
			XCTAssertTrue(observersPool.notifyArgumentFeature === feature)
			XCTAssertEqual(observersPool.notifyArgumentFeatureName, "Feature Test")
		} catch {
			XCTFail()
		}
	}

	func test_SetEnable_TrueAndDefaultShouldRunWhenEnabled_ProxyRunIsNotCalled() {
		let feature = StubFeature()
		feature.isEnabled = false
		manager.add(feature: feature, name: "Feature Test")

		do {
			try manager.setEnable(true, featureName: "Feature Test")

			XCTAssertFalse(feature.isMainCalled)
		} catch {
			XCTFail()
		}
	}

    func test_SetEnable_TrueAndShouldRunWhenEnabledTrue_ProxyRunIsCalled() {
        let feature = StubFeature()
        feature.isEnabled = false
        manager.add(feature: feature, name: "Feature Test", shouldRunWhenEnabled: true)
        
        do {
            try manager.setEnable(true, featureName: "Feature Test")
            
            XCTAssertTrue(feature.isMainCalled)
        } catch {
            XCTFail()
        }
    }
    
    func test_SetEnable_TrueAndShouldRunWhenEnabledUpdatedToTrue_ProxyRunIsCalled() {
        let feature = StubFeature()
        feature.isEnabled = false
        manager.add(feature: feature, name: "Feature Test")
        
        do {
            try manager.update(featureName: "Feature Test", shouldRunWhenEnabled: true)

            try manager.setEnable(true, featureName: "Feature Test")
            
            XCTAssertTrue(feature.isMainCalled)
        } catch {
            XCTFail()
        }
    }
    
    func test_SetEnable_TrueAndShouldRunWhenEnabledUpdatedToFalse_ProxyRunIsNotCalled() {
        let feature = StubFeature()
        feature.isEnabled = false
        manager.add(feature: feature, name: "Feature Test", shouldRunWhenEnabled: true)

        do {
            try manager.update(featureName: "Feature Test", shouldRunWhenEnabled: false)
            
            try manager.setEnable(true, featureName: "Feature Test")
            
            XCTAssertFalse(feature.isMainCalled)
        } catch {
            XCTFail()
        }
    }
    
    func test_AddChangesObserver_OneFeature_CallsAddObserver() {
		let feature = StubFeature()
		feature.isEnabled = true
		manager.add(feature: feature, name: "Feature Test")
		let observer = SpyFeatureChangesObserver()

		manager.addChangesObserver(observer, featureName: "Feature Test")

		XCTAssertTrue(observersPool.isAddObserverCalled)
		XCTAssertTrue(observersPool.addObserverArgumentObserver === observer)

		guard let addObserverArgumentFeatureNames = observersPool.addObserverArgumentFeatureNames else {
			XCTFail()
			return
		}
		XCTAssertEqual(addObserverArgumentFeatureNames, ["Feature Test"])
	}

	func test_AddChangesObserver_FeatureArray_CallsAddObserver() {
		let feature = StubFeature()
		feature.isEnabled = true
		manager.add(feature: feature, name: "Feature Test")
		let observer = SpyFeatureChangesObserver()

		manager.addChangesObserver(observer, featureNames: ["Feature Test", "Feature Test2"])

		XCTAssertTrue(observersPool.isAddObserverCalled)
		XCTAssertTrue(observersPool.addObserverArgumentObserver === observer)

		guard let addObserverArgumentFeatureNames = observersPool.addObserverArgumentFeatureNames else {
			XCTFail()
			return
		}
		XCTAssertEqual(addObserverArgumentFeatureNames, ["Feature Test", "Feature Test2"])
	}

    func test_RemoveChangesObserver_FeatureNamesDefault_CallsRemoveObserverWithFeatureNamesNil() {
        let feature = StubFeature()
        feature.isEnabled = true
        manager.add(feature: feature, name: "Feature Test")
        let observer = SpyFeatureChangesObserver()
        manager.addChangesObserver(observer, featureNames: ["Feature Test", "Feature Test2"])
        
        manager.removeChangesObserver(observer)
        
        XCTAssertTrue(observersPool.isRemoveObserverCalled)
        XCTAssertTrue(observersPool.removeObserverArgumentObserver === observer)
        XCTAssertNil(observersPool.removeObserverArgumentFeatureNames)
    }
    
    func test_RemoveChangesObserver_ValidFeatureNames_CallsRemoveObserverWithFeatureNames() {
        let feature = StubFeature()
        feature.isEnabled = true
        manager.add(feature: feature, name: "Feature Test")
        let observer = SpyFeatureChangesObserver()
        manager.addChangesObserver(observer, featureNames: ["Feature Test", "Feature Test2"])
        
        manager.removeChangesObserver(observer, featureNames: ["Feature Test", "Feature Test2"])
        
        XCTAssertTrue(observersPool.isRemoveObserverCalled)
        XCTAssertTrue(observersPool.removeObserverArgumentObserver === observer)
        
        guard let removeObserverArgumentFeatureNames = observersPool.removeObserverArgumentFeatureNames else {
            XCTFail()
            return
        }
        XCTAssertEqual(removeObserverArgumentFeatureNames, ["Feature Test", "Feature Test2"])
    }

	func test_PresentModalFeaturesList_CallsCoordinatorStartWithModalMode() {
		do {
			try manager.presentModalFeaturesList()
		} catch {
			XCTFail()
		}

		XCTAssertTrue(featuresListCoordinator.isStartCalled)
	}
	
	func test_PresentModalFeaturesList_DefaultWindowValue_WindowHasFrameLikeScreen() {
		do {
			try manager.presentModalFeaturesList()
		} catch {
			XCTFail()
		}

		guard let startArgumentPresentigMode = featuresListCoordinator.startArgumentPresentigMode,
			case PresentingMode.modal(let parentWindow) = startArgumentPresentigMode else {
			XCTFail()
			return
		}
		XCTAssertEqual(parentWindow.frame, UIScreen.main.bounds)
	}
    
    func test_PresentModalFeaturesList_AWindowValue_UsesWindowOfArgument() {
        let window = UIWindow()
        do {
            try manager.presentModalFeaturesList(in: window)
        } catch {
            XCTFail()
        }
        
        guard let startArgumentPresentigMode = featuresListCoordinator.startArgumentPresentigMode else {
            XCTFail()
            return
        }
        XCTAssertEqual(startArgumentPresentigMode, PresentingMode.modal(window))
    }
    
    func test_PresentFeaturesList_ParentViewDefaultValueNil_PresentigModeHasViewNil() {
        let parentViewController = UIViewController()
        
        manager.presentFeaturesList(in: parentViewController)
        
        guard let startArgumentPresentigMode = featuresListCoordinator.startArgumentPresentigMode else {
            XCTFail()
            return
        }
        XCTAssertEqual(startArgumentPresentigMode, PresentingMode.inParent(parentViewController, nil))
    }
    
    func test_PresentFeaturesList_ParentViewNotNil_PresentigModeHasView() {
        let parentViewController = UIViewController()
        let view = UIView()
        
        manager.presentFeaturesList(in: parentViewController, view: view)
        
        guard let startArgumentPresentigMode = featuresListCoordinator.startArgumentPresentigMode else {
            XCTFail()
            return
        }
        XCTAssertEqual(startArgumentPresentigMode, PresentingMode.inParent(parentViewController, view))
    }
}
