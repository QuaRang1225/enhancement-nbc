//
//  WikiWebView.swift
//  project-book-series
//
//  Created by 유영웅 on 3/31/25.
//

import Foundation
import WebKit
import UIKit

//MARK: 이미지 뷰 터치 시 해당 시리즈 웹뷰 표시
class WikiWebView:UIViewController {
    
    var webView: WKWebView!
    let url:URL
    
    init(url:URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
