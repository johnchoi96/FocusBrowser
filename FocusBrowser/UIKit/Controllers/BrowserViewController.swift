//
//  BrowserViewController.swift
//  FocusBrowser
//
//  Created by John Choi on 8/12/23.
//  Copyright © 2023 John Choi. All rights reserved.
//

import UIKit
import WebKit
import SwiftMessages

/// Controller for the private browser.
class BrowserViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    static let storyboardIdentifier = "browserViewController"

    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var webkit: WKWebView!
    
    @IBOutlet weak var loadProgressView: UIProgressView!

    var addressFieldContent: String!

    let networkService = NetworkService.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addressField.delegate = self
        addressField.autocorrectionType = .no
        addressField.text = addressFieldContent
        webkit.navigationDelegate = self
        webkit.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: K.homepageUrl)
        let request = URLRequest(url: url!)
        webkit?.load(request)
        webkit.allowsBackForwardNavigationGestures = true
        
        loadProgressView.isHidden = true

        // SwiftMessages setup
        SwiftMessages.pauseBetweenMessages = 1
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            loadProgressView.progress = Float(webkit.estimatedProgress)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let input = textField.text else {
            return true
        }
        var address = input
        if !address.hasPrefix("https://") {
            address = "https://\(address)"
        }
        let url = URL(string: address)
        var request: URLRequest
        print("https://www.google.com/search?q=\(input.searchToken())")
        if let url = url, address.contains(".") {
            request = URLRequest(url: url)
        } else {
            let newAddress = "https://www.google.com/search?q=\(input.searchToken())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let newUrl = URL(string: newAddress!)
            request = URLRequest(url: newUrl!)
        }
        webkit?.load(request)
        
        textField.resignFirstResponder()
        return true
    }

    @IBAction func reloadPressed(_ sender: UIBarButtonItem) {
        webkit.reload()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let urlString = webView.url?.absoluteString else {
            webView.stopLoading()
            print("Loading denied")
            title = webView.title
            loadProgressView.isHidden = true
            return
        }
        if !networkService.shouldLoadUrl(absolutePath: urlString) {
            // network request rejected
            webView.stopLoading()
            print("Loading denied: \(urlString)")
            displayNetworkDeniedMessage(absolutePath: urlString)
            title = webView.title
            loadProgressView.isHidden = true
            return
        }
        addressField.text = webView.url?.absoluteString
    }

    private func displayNetworkDeniedMessage(absolutePath: String) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.info)
        view.button?.isHidden = true
        view.titleLabel?.text = "Loading denied!"
        view.bodyLabel?.text = absolutePath
        // Hide when message view tapped
        view.tapHandler = { _ in
            self.didAllowUrl(url: absolutePath)
        }
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 20

        SwiftMessages.show(view: view)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        loadProgressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        loadProgressView.isHidden = false
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        webkit.goBack()
    }
    
    @IBAction func frontButtonPressed(_ sender: UIBarButtonItem) {
        webkit.goForward()
    }

    @IBAction func copyURLPressed(_ sender: UIBarButtonItem) {
        UIPasteboard.general.string = webkit.url?.absoluteString

        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.success)
        view.button?.isHidden = true
        view.titleLabel?.text = "Copied!"
        view.bodyLabel?.isHidden = true

        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 20

        SwiftMessages.show(view: view)
    }

    @IBAction func networkRequestPressed(_ sender: UIBarButtonItem) {
        super.performSegue(withIdentifier: K.Segues.privateToRequestList, sender: networkService)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.privateToRequestList {
            let vc = segue.destination as? NetworkRequestHistoryViewController
            vc?.networkService = sender as? NetworkService
            vc?.delegate = self
        }
    }
}

extension BrowserViewController: DeniedNetworkRequestDelegate {

    func didAllowUrl(url: String) {
        // allow this domain from the url
        networkService.allowDomain(absolutePath: url)
        // load
        let url = URL(string: url)
        webkit.load(URLRequest(url: url!))
    }
}
