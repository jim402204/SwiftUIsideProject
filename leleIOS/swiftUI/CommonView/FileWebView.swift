//
//  FileWebView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2025/1/9.
//

import SwiftUI
import WebKit

struct FileWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = true // 啟用滾動
        webView.scrollView.bounces = false
        webView.navigationDelegate = context.coordinator

        // 設置縮放
        webView.configuration.preferences.javaScriptEnabled = true
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // 設置內容自適應大小
            webView.evaluateJavaScript("""
            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=yes';
            document.getElementsByTagName('head')[0].appendChild(meta);
            """, completionHandler: nil)
        }
    }
}

struct Conten11View: View {
    var body: some View {
        FileWebView(url: URL(string: "https://example.com/sample.xlsx")!)
            .edgesIgnoringSafeArea(.all) // 全屏顯示
    }
}
