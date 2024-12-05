//
//  UserInfoCardView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/4.
//

import SwiftUI

struct UserInfoCardView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        VStack(spacing: 0) {
            // 用戶基本信息
            HStack {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .frame(width: 40, height: 25)
                    .foregroundColor(.teal)
                
                VStack(alignment: .leading) {
                    Text(viewModel.userName)
                        .font(.title2)
                        .bold()
                    Text(viewModel.accountID)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            .background(Color.white)
            
            // 個人設置選項
            VStack(spacing: 0) {
    
                NavigationLink(destination: Text("個人資料")) {
                    ProfileOptionView(title: "個人資料")
                }
                Divider()
                
                NavigationLink(destination: Text("變更密碼")) {
                    ProfileOptionView(title: "變更密碼")
                }
                Divider()
                
                NavigationLink(destination: Text("已登入的裝置")) {
                    ProfileOptionView(title: "已登入的裝置")
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
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    UserInfoCardView(viewModel: ProfileViewModel())
}
