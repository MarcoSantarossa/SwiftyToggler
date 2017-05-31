//
//  FeaturesListViewModelTests.swift
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

class FeaturesListViewModelTests: XCTestCase {

	var fmToggler: SpyFeaturesManagerToggler!
	var viewModel: FeaturesListViewModel!

	override func setUp() {
		super.setUp()

		fmToggler = SpyFeaturesManagerToggler()
		viewModel = FeaturesListViewModel(featuresManager: fmToggler, presentingMode: .modal(DummyWindow()))
	}

	override func tearDown() {
		viewModel = nil
		fmToggler = nil
		super.tearDown()
	}

	func test_FeaturesCount_WithoutFeatures_IsZero() {
		XCTAssertEqual(viewModel.featuresCount, 0)
	}

	func test_FeaturesCount_WithTwoFeatures_IsTwo() {
		fmToggler = SpyFeaturesManagerToggler()
		fmToggler.forceTwoFeatures = true
		viewModel = FeaturesListViewModel(featuresManager: fmToggler, presentingMode: .modal(DummyWindow()))

		XCTAssertEqual(viewModel.featuresCount, 2)
	}

	func test_CloseButtonHeight_PresetingModeModal_Returns44() {
		XCTAssertEqual(viewModel.closeButtonHeight, 44)
	}

	func test_CloseButtonHeight_PresetingModeInParentViewNil_ReturnsZero() {
		let fmToggler = SpyFeaturesManagerToggler()
		let viewModel = FeaturesListViewModel(featuresManager: fmToggler, presentingMode: .inParent(DummyViewController(), nil))

		XCTAssertEqual(viewModel.closeButtonHeight, 0)
	}

	func test_CloseButtonHeight_PresetingModeInParentViewNotNil_ReturnsZero() {
		let fmToggler = SpyFeaturesManagerToggler()
		let viewModel = FeaturesListViewModel(featuresManager: fmToggler, presentingMode: .inParent(DummyViewController(), DummyView()))

		XCTAssertEqual(viewModel.closeButtonHeight, 0)
	}

	func test_TitleLabelHeight_PresetingModeModal_Returns50() {
		XCTAssertEqual(viewModel.titleLabelHeight, 50)
	}

	func test_TitleLabelHeight_PresetingModeInParentViewNil_ReturnsZero() {
		let fmToggler = SpyFeaturesManagerToggler()
		let viewModel = FeaturesListViewModel(featuresManager: fmToggler, presentingMode: .inParent(DummyViewController(), nil))

		XCTAssertEqual(viewModel.titleLabelHeight, 0)
	}

	func test_TitleLabelHeight_PresetingModeInParentViewNotNil_ReturnsZero() {
		let fmToggler = SpyFeaturesManagerToggler()
		let viewModel = FeaturesListViewModel(featuresManager: fmToggler, presentingMode: .inParent(DummyViewController(), DummyView()))

		XCTAssertEqual(viewModel.titleLabelHeight, 0)
	}
    
    func test_ShouldShowPlaceholder_WithoutFeatures_IsTrue() {
        XCTAssertTrue(viewModel.shouldShowPlaceholder)
    }
    
    func test_ShouldShowPlaceholder_WithFeatures_IsFalse() {
        fmToggler = SpyFeaturesManagerToggler()
        fmToggler.forceTwoFeatures = true
        viewModel = FeaturesListViewModel(featuresManager: fmToggler, presentingMode: .modal(DummyWindow()))

        XCTAssertFalse(viewModel.shouldShowPlaceholder)
    }
    
	func test_FeatureInfoAt_WithoutFeatures_ReturnsNil() {
		let featureStatus = viewModel.featureStatus(at: IndexPath(row: 0, section: 0))

		XCTAssertNil(featureStatus)
	}

	func test_FeatureInfoAt_WithFeaturesInvalidIndexPath_ReturnsNil() {
		fmToggler = SpyFeaturesManagerToggler()
		fmToggler.forceTwoFeatures = true
		viewModel = FeaturesListViewModel(featuresManager: fmToggler, presentingMode: .modal(DummyWindow()))

		let featureStatus = viewModel.featureStatus(at: IndexPath(row: 3, section: 0))

		XCTAssertNil(featureStatus)
	}

	func test_FeatureInfoAt_WithFeaturesValidIndexPath_ReturnsFeatureInfo() {
		fmToggler = SpyFeaturesManagerToggler()
		fmToggler.forceTwoFeatures = true
		viewModel = FeaturesListViewModel(featuresManager: fmToggler, presentingMode: .modal(DummyWindow()))

		let featureStatus = viewModel.featureStatus(at: IndexPath(row: 1, section: 0))

		XCTAssertEqual(featureStatus!.name, "F2")
		XCTAssertTrue(featureStatus!.isEnabled)
	}

	func test_UpdateFeature_CallsSetEnable() {
		viewModel.updateFeature(name: "F2", isEnabled: true)

		XCTAssertTrue(fmToggler.isSetEnableCall)
		XCTAssertTrue(fmToggler.setEnableIsEnableAgument!)
		XCTAssertEqual(fmToggler.setEnableFeatureNameAgument, "F2")
	}

	func test_CloseButtonDidTap_CallsFeaturesListViewModelNeedsClose() {
		let viewModelDelegate = StubFeaturesListViewModelDelegate()
		viewModel.delegate = viewModelDelegate

		viewModel.closeButtonDidTap()

		XCTAssertTrue(viewModelDelegate.isFeaturesListViewModelNeedsCloseCalled)
	}
}
