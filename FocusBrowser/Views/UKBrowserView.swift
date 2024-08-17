//
//  BrowserView.swift
//  FocusBrowser
//
//  Created by John Choi on 8/17/24.
//

import SwiftUI

struct UKBrowserView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "browser", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: BrowserViewController.storyboardIdentifier) as! BrowserViewController
        viewController.title = "Browser"
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Update the view controller if needed
    }
}
