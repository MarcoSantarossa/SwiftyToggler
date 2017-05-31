//
//  PresentingModeTests.swift
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

class PresentingModeTests: XCTestCase {

	func test_Equal_BothModalWithSameWindow_ReturnsTrue() {
		let window = DummyWindow()
		XCTAssertTrue(PresentingMode.modal(window) == PresentingMode.modal(window))
	}

	func test_Equal_BothModalDifferentWindows_ReturnsFalse() {
		XCTAssertFalse(PresentingMode.modal(DummyWindow()) == PresentingMode.modal(DummyWindow()))
	}

	func test_Equal_OneModalOneInParent_ReturnsFalse() {
		XCTAssertFalse(PresentingMode.modal(DummyWindow()) == PresentingMode.inParent(DummyViewController(), DummyView()))
	}

	func test_Equal_OneModalOneInParentWithViewNil_ReturnsFalse() {
		XCTAssertFalse(PresentingMode.modal(DummyWindow()) == PresentingMode.inParent(DummyViewController(), nil))
	}

	func test_Equal_BothInParentWithSameObjects_ReturnsTrue() {
		let viewController = DummyViewController()
		let view = DummyView()
		XCTAssertTrue(PresentingMode.inParent(viewController, view) == PresentingMode.inParent(viewController, view))
	}

	func test_Equal_BothInParentWithSameViewControllerViewNil_ReturnsTrue() {
		let viewController = DummyViewController()
		XCTAssertTrue(PresentingMode.inParent(viewController, nil) == PresentingMode.inParent(viewController, nil))
	}

	func test_Equal_BothInParentWithSameViewControllerDifferentViews_ReturnsFalse() {
		let viewController = DummyViewController()
		XCTAssertFalse(PresentingMode.inParent(viewController, DummyView()) == PresentingMode.inParent(viewController, DummyView()))
	}

	func test_Equal_BothInParentWithSameViewControllerOneViewNil_ReturnsFalse() {
		let viewController = DummyViewController()
		XCTAssertFalse(PresentingMode.inParent(viewController, DummyView()) == PresentingMode.inParent(viewController, nil))
	}

	func test_Equal_BothInParentWithDifferentViewControllersSameView_ReturnsFalse() {
		let view = DummyView()
		XCTAssertFalse(PresentingMode.inParent(DummyViewController(), view) == PresentingMode.inParent(DummyViewController(), view))
	}

	func test_Equal_BothInParentWithDifferentViewControllersDifferentViews_ReturnsFalse() {
		XCTAssertFalse(PresentingMode.inParent(DummyViewController(), DummyView()) == PresentingMode.inParent(DummyViewController(), DummyView()))
	}

	func test_Equal_BothInParentWithDifferentViewControllersAViewNil_ReturnsFalse() {
		XCTAssertFalse(PresentingMode.inParent(DummyViewController(), DummyView()) == PresentingMode.inParent(DummyViewController(), nil))
	}
}
