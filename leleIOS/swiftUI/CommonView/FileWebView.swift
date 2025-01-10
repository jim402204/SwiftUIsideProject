//
//  FileWebView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2025/1/9.
//

import SwiftUI
import WebKit

struct FileWebView: View {
    @State private var progress: Double = 0.0
    let url: URL

    var body: some View {
        VStack {
            // 進度條
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
                .opacity(progress < 1.0 ? 1.0 : 0.0) // 完成時隱藏
            
            // WebView
            LeLeWebView(url: url, progress: $progress)
                .edgesIgnoringSafeArea(.all)
        }
        .navigationBarStyle(title: "")
    }
}

#Preview {
    PreviewTokenView {
        NavigationStack {
            FileWebView(url: URL(string: "https://www.google.com")!)
        }
    }
}
