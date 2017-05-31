//
//  FeaturesListCoordinatorTests.swift
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

class FeaturesListCoordinatorTests: XCTestCase {

	private var coordinator: FeaturesListCoordinator!

    override func setUp() {
        super.setUp()

		coordinator = FeaturesListCoordinator()
	}
    
    override func tearDown() {
		coordinator = nil

		super.tearDown()
    }

	func test_Init_WindowIsNil() {
		XCTAssertNil(coordinator.window)
	}

	func test_Start_PresentModal_SetsRightWindowRootViewController() {
		let window = SpyWindow()

		do {
			try coordinator.start(presentingMode: .modal(window))
		} catch {
			XCTFail()
		}

		XCTAssertTrue(window.isSetRootViewControllerTypeCalled)

		guard let viewController = window.setRootViewControllerTypeArgument as? FeaturesListViewController else {
			XCTFail()
			return
		}
		XCTAssertTrue(viewController.viewModel is FeaturesListViewModel)
	}

    func test_Start_PresentModal_CallsWindowMakeKeyAndVisible() {
        let window = SpyWindow()
        
        do {
            try coordinator.start(presentingMode: .modal(window))
        } catch {
            XCTFail()
        }
        
        XCTAssertTrue(window.isMakeKeyAndVisibleCalled)
    }
    
    func test_Start_PresentModal_SetBackgroundColorWhite() {
        let window = SpyWindow()
        
        do {
            try coordinator.start(presentingMode: .modal(window))
        } catch {
            XCTFail()
        }
        
        XCTAssertTrue(window.isSetBackgroundColorCalled)
        XCTAssertEqual(window.setBackgroundColorArgument, UIColor.white)
    }
    
	func test_Start_PresentModalAlreadyPresented_ThrowsError() {
		let window = SpyWindow()

		do {
			try coordinator.start(presentingMode: .modal(window))
			try coordinator.start(presentingMode: .modal(window))
			XCTFail()
		} catch SwiftyTogglerError.modalFeaturesListAlreadyPresented {
			XCTAssertTrue(true)
		} catch {
			XCTFail()
		}
	}
    
    func test_Start_PresentModal_PropertyWindowIsSet() {
        let window = SpyWindow()
        
        do {
            try coordinator.start(presentingMode: .modal(window))
            
            XCTAssertTrue(window === coordinator.window)
        } catch {
            XCTFail()
        }
    }
    
    func test_Start_InParent_ParentViewNil_AddFillerChildViewControllerIsCalled() {
        let parentViewController = SpyViewController()
        
        do {
            try coordinator.start(presentingMode: .inParent(parentViewController, nil))
            
            XCTAssertTrue(parentViewController.isAddFillerChildViewControllerCalled)
        } catch {
            XCTFail()
        }
    }
    
    func test_Start_InParent_ParentViewNil_AddFillerChildViewControllerViewArgumentIsNil() {
        let parentViewController = SpyViewController()
        
        do {
            try coordinator.start(presentingMode: .inParent(parentViewController, nil))
            
            XCTAssertNil(parentViewController.addFillerChildViewControllerViewArgument)
        } catch {
            XCTFail()
        }
    }
    
    func test_Start_InParent_ParentViewNil_AddFillerChildViewControllerViewArgumentIsNotNil() {
        let parentViewController = SpyViewController()
        let parentView = SpyView()
        
        do {
            try coordinator.start(presentingMode: .inParent(parentViewController, parentView))
            
            XCTAssertTrue(parentViewController.addFillerChildViewControllerViewArgument === parentView)
        } catch {
            XCTFail()
        }
    }
    
    func test_Start_InParent_AddFillerChildViewControllerVCArgumentIsFeaturesListViewController() {
        let parentViewController = SpyViewController()
        
        do {
            try coordinator.start(presentingMode: .inParent(parentViewController, nil))
            
            guard let viewController = parentViewController.addFillerChildViewControllerVCArgument as? FeaturesListViewController else {
                XCTFail()
                return
            }
            XCTAssertTrue(viewController.viewModel is FeaturesListViewModel)
        } catch {
            XCTFail()
        }
    }

	func test_FeaturesListViewModelNeedsClose_WindowNil_WindowsRemainsNil() {
		coordinator.featuresListViewModelNeedsClose()

		XCTAssertNil(coordinator.window)
	}

	func test_FeaturesListViewModelNeedsClose_ValidWindow_CallsWindowIsHidden() {
		let window = SpyWindow()

		do {
			try coordinator.start(presentingMode: .modal(window))

			XCTAssertTrue(window === coordinator.window)
		} catch {
			XCTFail()
		}

		coordinator.featuresListViewModelNeedsClose()

		XCTAssertTrue(window.isSetIsHiddenCalled)
		XCTAssertTrue(window.setIsHiddenArgument ?? false)
	}

	func test_FeaturesListViewModelNeedsClose_ValidWindow_DestroyRootViewController() {
		let window = SpyWindow()

		do {
			try coordinator.start(presentingMode: .modal(window))

			XCTAssertTrue(window === coordinator.window)
		} catch {
			XCTFail()
		}

		coordinator.featuresListViewModelNeedsClose()

		XCTAssertTrue(window.isSetRootViewControllerTypeCalled)
		XCTAssertNil(window.setRootViewControllerTypeArgument)
	}

	func test_FeaturesListViewModelNeedsClose_ValidWindow_DestroyWindow() {
		let window = SpyWindow()

		do {
			try coordinator.start(presentingMode: .modal(window))

			XCTAssertTrue(window === coordinator.window)
		} catch {
			XCTFail()
		}

		coordinator.featuresListViewModelNeedsClose()

		XCTAssertNil(coordinator.window)
	}
}
