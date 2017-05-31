//
//  FeaturesListViewModel.swift
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

final class FeaturesListViewModel: FeaturesListViewModelProtocol {

	private struct Constants {
		static let defaultCloseButtonHeight: CGFloat = 44
		static let defaultTitleLabelHeight: CGFloat = 50
	}

	weak var delegate: FeaturesListViewModelDelegate?

	var featuresCount: Int {
		return featuresStatus.count
	}
	var titleLabelHeight: CGFloat {
		guard case PresentingMode.modal(_) = self.presentingMode else { return 0 }
		return Constants.defaultTitleLabelHeight
	}
	var closeButtonHeight: CGFloat {
		guard case PresentingMode.modal(_) = self.presentingMode else { return 0 }
		return Constants.defaultCloseButtonHeight
	}
    var shouldShowPlaceholder: Bool {
        return featuresCount == 0
    }
    fileprivate let featuresManager: FeaturesManagerTogglerProtocol
	fileprivate let featuresStatus: [FeatureStatus]

	private let presentingMode: PresentingMode

    init(featuresManager: FeaturesManagerTogglerProtocol = FeaturesManager.shared,
         presentingMode: PresentingMode) {
		self.featuresManager = featuresManager
		self.presentingMode = presentingMode
		self.featuresStatus = featuresManager.featuresStatus
    }
}

extension FeaturesListViewModel: FeaturesListViewModelUIBindingProtocol {
	func featureStatus(at indexPath: IndexPath) -> FeatureStatus? {
		guard indexPath.row < featuresStatus.count else { return nil }
		return featuresStatus[indexPath.row]
	}

	func updateFeature(name: String, isEnabled: Bool) {
		try? featuresManager.setEnable(isEnabled, featureName: name)
	}

	func closeButtonDidTap() {
		delegate?.featuresListViewModelNeedsClose()
	}
}
