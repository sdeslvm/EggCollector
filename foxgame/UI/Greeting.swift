import Foundation
import SwiftUI
import WebKit

struct GreetingView: UIViewRepresentable {
    let pageURL: URL
    
    var enableSwipeNavigation: Bool = true

    func makeUIView(context: Context) -> WKWebView {
        
        
        let webBrowser = WKWebView()
        
        webBrowser.allowsBackForwardNavigationGestures = enableSwipeNavigation
        webBrowser.uiDelegate = context.coordinator

        return webBrowser
    }

    func updateUIView(_ webBrowser: WKWebView, context: Context) {
        let urlRequest = URLRequest(url: pageURL)
        
        webBrowser.load(urlRequest)
    }
    
    func makeCoordinator() -> BrowserCoordinator {
        
        BrowserCoordinator(self)
    }
    
    final class BrowserCoordinator: NSObject, WKUIDelegate {
        
        var parentView: GreetingView

        init(_ parentView: GreetingView) {
            
            self.parentView = parentView
        }
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                
                webView.load(navigationAction.request)
            }
            return nil
        }
    }
}

struct GreetingWrapper: View {

    var link: String

    var body: some View {
        if let URLString = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let webPage = URL(string: URLString)
        {
            GreetingView(pageURL: webPage)
        }
    }
}
