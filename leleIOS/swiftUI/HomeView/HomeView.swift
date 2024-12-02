//
//  HomeView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/2.
//

import SwiftUI

// 各個頁面的基本結構
struct HomeView: View {
    var body: some View {
        NavigationView {
            Text("首頁內容")
                .navigationTitle("首頁")
        }
    }
}
#Preview {
    HomeView()
}
