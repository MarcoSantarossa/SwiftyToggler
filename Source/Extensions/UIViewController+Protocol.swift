//
//  UIViewController+Protocol.swift
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

import UIKit

protocol UIViewControllerProtocol: class {
    var viewType: UIViewProtocol { get }

    func addChildViewController(_ childController: UIViewControllerProtocol)
    func addFillerChildViewController(_ childController: UIViewControllerProtocol, toView: UIViewProtocol?)
    func didMove(toParentViewController parent: UIViewControllerProtocol?)
}

extension UIViewController: UIViewControllerProtocol {
    var viewType: UIViewProtocol {
        return self.view
    }

    func addFillerChildViewController(_ childController: UIViewControllerProtocol, toView: UIViewProtocol? = nil) {
        addChildViewController(childController)
        var parentView: UIViewProtocol = childController.viewType
        if let toView = toView {
            parentView = toView
        }
        viewType.addFillerSubview(parentView)
        childController.didMove(toParentViewController: self)
    }

    func addChildViewController(_ childController: UIViewControllerProtocol) {
        guard let childController = childController as? UIViewController else { return }
        addChildViewController(childController)
    }

    func didMove(toParentViewController parent: UIViewControllerProtocol?) {
        didMove(toParentViewController: parent as? UIViewController)
    }
}
