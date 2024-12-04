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
    
    var body: some View {
//        NavigationStack {
            VStack(spacing: 20) {
                // Logo和標題
                HStack(spacing: 10) {
                    Image(systemName: "person.3.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.teal)
                    
                    Text("樂樂")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
                .padding(.top, 50)
                .onAppear {
                    viewModel.setApp(state: appState)
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
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
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
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .frame(height: 50)
                }
                
                // 登入按鈕
                Button {
                    viewModel.login()
                } label: {
                    Text("登入")
                        .font(.title2)
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
                .font(.title2)
                
                Spacer()
                
                // 版本號
                Text("樂樂 LeLeLink V1.0.0")
                    .font(.system(size: 16))
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
            .navigationDestination(isPresented: $viewModel.navigateToRegister) {
                 RegisterView()
            }
            .navigationDestination(isPresented: $viewModel.navigateToForgotPassword) {
                 ForgotPasswordView()
            }
        }
//    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}
