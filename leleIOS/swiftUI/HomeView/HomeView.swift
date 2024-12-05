//
//  HomeView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/2.
//

import SwiftUI

// 各個頁面的基本結構
struct HomeView: View {
    let icons = [
        ("對講", "person.2.fill"),
        ("郵務", "envelope.fill"),
        ("公告", "megaphone.fill"),
        ("報修", "doc.text.fill"),
        ("訪客", "person.crop.circle.fill"),
        ("公設", "calendar"),
        ("投票", "hand.thumbsup.fill"),
        ("規約", "doc.plaintext.fill"),
        ("瓦斯", "flame.fill"),
        ("行事曆", "calendar"),
        ("管理費", "dollarsign.circle.fill"),
        ("安控", "lock.shield.fill"),
        ("相簿", "photo.on.rectangle"),
        ("遠端關懷", "antenna.radiowaves.left.and.right")
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                
                VStack(spacing: 20) {
                    Text("功能選單")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                        ForEach(icons, id: \.0) { icon in
                            NavigationLink(destination: destinationView(for: icon.0)) {
                                VStack {
                                    Image(systemName: icon.1)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.teal)
                                    Text(icon.0)
                                        .foregroundStyle(Color.black.opacity(0.7))
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    )
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .background(Color(.systemGray6))
            .navigationTitle("首頁")
        }
    }
    
    // 根據圖標名稱返回相應的視圖
    @ViewBuilder
    func destinationView(for iconName: String) -> some View {
        switch iconName {
        case "對講":
            Text("對講")
        default:
//            Text("\(iconName) 頁面")
            DetailView()
        }
    }
}
#Preview {
    HomeView()
}


struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("這是詳細頁面")
                .font(.largeTitle)
                .padding()

            Button(action: {
                dismiss() // 點擊按鈕後返回上一頁
            }) {
                Text("返回")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("詳細信息")
        .padding()
    }
}
