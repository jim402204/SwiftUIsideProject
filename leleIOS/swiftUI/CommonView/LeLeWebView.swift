//
//  LeLeWebView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2025/1/10.
//

import SwiftUI
import WebKit

struct LeLeWebView: UIViewRepresentable {
    let url: URL
    @Binding var progress: Double // 綁定外部進度數據

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.addObserver(context.coordinator, forKeyPath: "estimatedProgress", options: .new, context: nil) // 監控加載進度
        
        // 保存對 WebView 的引用
        context.coordinator.webView = webView
        
//        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        let request = URLRequest(url: url)
        webView.load(request)
//        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        //progress 會持續刷新swfitUI
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: LeLeWebView
        weak var webView: WKWebView?

        init(_ parent: LeLeWebView) {
            self.parent = parent
        }

        // 監控進度變化
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "estimatedProgress", let webView = object as? WKWebView {
                DispatchQueue.main.async {
                    self.parent.progress = webView.estimatedProgress // 更新進度
                }
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("頁面加載完成：\(webView.url?.absoluteString ?? "未知網址")")
            
            // 檢查頁面內容是否成功加載
            webView.evaluateJavaScript("document.body.innerHTML") { (html, error) in
                if let html = html as? String, html.isEmpty {
                    print("頁面內容空白，嘗試重新加載")
                    webView.reload() // 重試加載
                } else {
                    print("頁面內容成功加載")
                }
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("頁面加載失敗：\(error.localizedDescription)")
        }

        deinit {
            // 確保從觀察者中移除 WebView
            webView?.removeObserver(self, forKeyPath: "estimatedProgress")
        }
    }
}


//#Preview {
//    LeLeWebView(url: <#URL#>)
//}
