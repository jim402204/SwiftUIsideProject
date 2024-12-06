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
        ("雲對講", "phone.bubble.fill"),
        ("郵務管理", "envelope.fill"),
        ("社區公告", "megaphone.fill"),
        ("報修", "doc.text.fill"),
        ("住戶意見", "bubble.left.and.bubble.right.fill"),
        ("訪客", "person.crop.circle.fill"),
        ("公設", "building.columns.fill"),
        ("投票", "hand.thumbsup.fill"),
        ("規約", "doc.plaintext.fill"),
        ("瓦斯", "flame.fill"),
        ("行事曆", "calendar"),
        ("管理費", "dollarsign.circle.fill"),
        ("安控", "lock.shield.fill"),
        ("相簿", "photo.on.rectangle"),
        ("遠端關懷", "antenna.radiowaves.left.and.right"),
        ("社區百問", "questionmark.circle.fill")
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                
                VStack(spacing: 20) {
                    
                    HStack {
                        
//                        Text(UserDefaultsHelper.userBuilding.name)
//                            .lineLimit(1)
                        
                        Text("功能選單")
                            
                        Spacer()
                    }
//                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
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
                            .applyShadow()
                    )
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationBarStyle(title: "首頁")
//            .navigationBarHidden(true)
        }
    }
    
    // 根據圖標名稱返回相應的視圖
    @ViewBuilder
    func destinationView(for iconName: String) -> some View {
        switch iconName {
        case "郵務":
            PostalServiceView()
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
        .padding()
//        .navigationTitle("詳細信息")
        .navigationBarStyle(title: "詳細信息")
        
    }
}
