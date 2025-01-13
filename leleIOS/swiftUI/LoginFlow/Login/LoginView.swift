//
//  LoginView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/3.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = LoginViewModel()
    @State private var showRoleSelection = false
    
    var body: some View {
        
        VStack(spacing: 20) {
            // Logo和標題
            HStack(spacing: 10) {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.teal)
                
                Text("樂樂")
                    .appFont(.largeTitle)
                    .foregroundColor(.gray)
            }
            .padding(.top, 50)
            .onAppear {
                viewModel.setApp(state: appState)
            }
            .overlay {
                VStack(spacing: 10) {
                    Button("角色切換") {
                        showRoleSelection = true
                    }
                    .confirmationDialog("選擇角色", isPresented: $showRoleSelection) {
                        ForEach(UserRole.allCases) { role in
                            Button(role.rawValue) {
                                UserDefaultsHelper.userRole = role
                            }
                        }
                        Button("取消", role: .cancel) {}
                    }
                    Spacer()
                }
//                .hidden()
            }
            
            // 輸入表單
            VStack(spacing: 15) {
                // 手機號碼輸入框
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.gray)
                    TextField("請輸入手機號碼", text: $viewModel.phoneNumber)
                        .keyboardType(.numberPad)
                }
                .padding()
                .roundedBackground()
                .frame(height: 50)
                
                // 密碼輸入框
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                    Group {
                        if viewModel.isPasswordVisible {
                            TextField("請輸入密碼", text: $viewModel.password)
                        } else {
                            SecureField("請輸入密碼", text: $viewModel.password)
                        }
                    }
                    
                    Button(action: {
                        viewModel.isPasswordVisible.toggle()
                    }) {
                        Image(systemName: viewModel.isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .roundedBackground()
                .frame(height: 50)
            }
            
            // 登入按鈕
            Button {
                viewModel.login()
            } label: {
                Text("登入")
                    .appFont(.title2)
                    .modifier(BaseButtonStyle(height: 44))
            }
            
            // 底部按鈕
            HStack {
                
                Button(action: {
                    viewModel.handleRegister()
                }) {
                    Text("註冊帳號")
                        .modifier(BaseButtonStyle(height: 44))
                        .fixedSize(horizontal: true, vertical: false)
                }
                
                Spacer()
                
                Button("忘記密碼") {
                    viewModel.handleForgotPassword()
                }
                .foregroundColor(.teal)
                .padding(.horizontal, 15)
            }
            .appFont(.title2)
            
            Spacer()
            
            // 版本號
            Text("樂樂 v1.0.0")
                .appFont(.size(16))
                .foregroundColor(.black)
                .padding(.bottom)
        }
        .padding(.horizontal)
        
        .background(
            Image("cityBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.3)
        )
        .alert("錯誤", isPresented: $viewModel.showError) {
            Button("確定", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
        .navigationDestination(isPresented: $viewModel.pushToRegister) {
            RegisterView()
        }
        .navigationDestination(isPresented: $viewModel.pushToForgotPassword) {
            ForgotPasswordView()
        }
    }
    
}

#Preview {
//    NavigationStack {
        LoginView()
            .environmentObject(AppState())
//    }
}
