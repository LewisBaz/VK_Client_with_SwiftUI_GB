//
//  WebLoginViewController.swift
//  VK App
//
//  Created by Lev Bazhkov on 18.06.2021.
//

import UIKit
import WebKit

final class WebLoginViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authentication()
    }
    
    private func authentication() {
        var urlComponents = URLComponents()
                    urlComponents.scheme = "https"
                    urlComponents.host = "oauth.vk.com"
                    urlComponents.path = "/authorize"
                    urlComponents.queryItems = [
                        URLQueryItem(name: "client_id", value: "7883017"),
                        URLQueryItem(name: "display", value: "mobile"),
                        URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                        URLQueryItem(name: "scope", value: "270342"),
                        URLQueryItem(name: "response_type", value: "token"),
                        URLQueryItem(name: "v", value: "5.131")
                    ]
        
                    let request = URLRequest(url: urlComponents.url!)
        
                    webView.load(request)
    }
}

extension WebLoginViewController {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let parameters = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        let token = parameters["access_token"]
        let userId = parameters["user_id"]
        
        //print(token as Any)
        
        decisionHandler(.cancel)
        Session.shared.token = token!
        Session.shared.userId = userId ?? "0"
        
        //print(token as Any)
        
        performSegue(withIdentifier: "showFriendsSegue", sender: nil)
    }
}
