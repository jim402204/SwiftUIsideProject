//
//  ProfileView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/2.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 個人信息卡片
                    VStack(spacing: 0) {
                        // 用戶基本信息
                        HStack {
                            Image(systemName: "person.3.fill")
                                .resizable()
                                .frame(width: 40, height: 25)
                                .foregroundColor(.teal)
                            
                            VStack(alignment: .leading) {
                                Text("王大明1")
                                    .font(.title2)
                                    .bold()
                                Text("0987654321")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        
                        // 個人設置選項
                        VStack(spacing: 0) {
                            // 限本人接受包裹通知
//                            HStack {
//                                Text("限本人接受包裹通知")
//                                Spacer()
//                                Toggle("", isOn: $viewModel.receiveNotifications)
//                            }
//                            .padding()
//                            
//                            Divider()
                            
                            // 其他選項
                            NavigationLink(destination: Text("個人資料")) {
                                HStack {
                                    Text("個人資料")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                            
                            Divider()
                            
                            NavigationLink(destination: Text("變更密碼")) {
                                HStack {
                                    Text("變更密碼")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                            
                            Divider()
                            
                            NavigationLink(destination: Text("已登入的裝置")) {
                                HStack {
                                    Text("已登入的裝置")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                            
                            Divider()
                            
                            Button(action: {
                                viewModel.logout()
                            }) {
                                HStack {
                                    Text("登出")
                                    Spacer()
                                    Image(systemName: "arrow.right.square")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                        }
                        .background(Color.white)
                    }
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    
                    // 社區資訊卡片
                    VStack(spacing: 0) {
                        Text("社區資訊")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(UIColor.systemGroupedBackground))
                        
                        VStack(spacing: 0) {
                            NavigationLink(destination: Text("家家測試社區")) {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.blue)
                                    Text("家家測試社區")
                                        .foregroundColor(.blue)
                                    Text("現居")
                                        .font(.caption)
                                        .padding(.horizontal, 5)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(4)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                            
                            Divider()
                            
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.gray)
                                Text("新北市 三重區")
                                Spacer()
                            }
                            .padding()
                            
                            Divider()
                            
                            HStack {
                                Image(systemName: "house.fill")
                                    .foregroundColor(.gray)
                                Text("A1棟1號1樓")
                                Spacer()
                            }
                            .padding()
                            
                            Divider()
                            
                            NavigationLink(destination: Text("點數管理")) {
                                HStack {
                                    Text("點數管理")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                        }
                        .background(Color.white)
                    }
                    .cornerRadius(10)
                    .shadow(radius: 1)
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("個人")
            .navigationBarItems(trailing: 
                Button(action: {
                    // 處理信息按鈕點擊
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.primary)
                }
            )
        }
        .onAppear {
            viewModel.setAppState(appState)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AppState())
    }
}
