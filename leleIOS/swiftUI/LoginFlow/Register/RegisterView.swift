//
//  Register.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/3.
//

import SwiftUI
import Combine

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    
    let iconSize: CGFloat = 32
    let itemFrame: CGFloat = 50
    
    var body: some View {
        
        ScrollView {
            
            Spacer().frame(height: 20)
            
            VStack(alignment: .center, spacing: 20) {
                
                Image("banner")
                    .resizable()
                    .frame(width: 160, height: 50)
                
                VStack(spacing: 15) {
                    
                    RoundedTextFieldView(
                        text: $viewModel.realName,
                        placeholder: "請輸入您的姓名",
                        iconName: "person.fill",
                        iconSize: iconSize,
                        itemFrame: itemFrame
                    )
                    
                    RoundedTextFieldView(
                        text: $viewModel.email,
                        placeholder: "請輸入您的Email",
                        iconName: "envelope.fill",
                        keyboardType: .emailAddress,
                        iconSize: iconSize,
                        itemFrame: itemFrame
                    )
                    
                    RoundedTextFieldView(
                        text: $viewModel.phoneNumber,
                        placeholder: "輸入您的手機號碼",
                        iconName: "phone.fill",
                        keyboardType: .phonePad,
                        iconSize: iconSize,
                        itemFrame: itemFrame,
                        shouldLimit: true
                    )
                    
                    HStack(spacing: 0) {
                        Image(systemName: "lock.fill")
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(.gray)
                        TextField("輸入驗證碼", text: $viewModel.verificationCode)
                            .padding(8)
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
                        
                        Button("取得驗證碼") {
                            viewModel.getVerificationCode()
                        }
                        .disabled(!viewModel.isValidButtonEnable)
                        .foregroundColor(
                            viewModel.isValidButtonEnable ? .init(uiColor: .systemBlue) : .gray
                        )
                        .padding(.trailing, 8)
                    }
                    .padding(.horizontal, 8)
                    .frame(height: itemFrame)
                    .roundedBackground()
                    
                    HStack(spacing: 0) {
                        Image(systemName: "lock.fill")
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(.gray)
                        if isPasswordVisible {
                            TextField("請輸入密碼", text: $viewModel.password)
                                .keyboardType(.asciiCapable)
                        } else {
                            SecureField("請輸入密碼", text: $viewModel.password)
                        }
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                    .padding(.horizontal, 8)
                    .frame(height: itemFrame)
                    .roundedBackground()
                    
                    HStack(spacing: 0) {
                        Image(systemName: "lock.fill")
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(.gray)
                        if isConfirmPasswordVisible {
                            TextField("請再次輸入密碼", text: $viewModel.confirmPassword)
                                .keyboardType(.asciiCapable)
                        } else {
                            SecureField("請再次輸入密碼", text: $viewModel.confirmPassword)
                        }
                        Button(action: {
                            isConfirmPasswordVisible.toggle()
                        }) {
                            Image(systemName: isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                    .padding(.horizontal, 8)
                    .frame(height: itemFrame)
                    .roundedBackground()
                }
                
                Button {
                    viewModel.registerAPI()
                } label: {
                    Text("註冊")
                        .appFont(.title2)
                        .modifier(
                            BaseButtonStyle(
                                height: 44,
                                backgroundColor: viewModel.registerColor
                            )
                        )
                }
                .disabled(!viewModel.isRegisterButtonEnable)
                .animation(.easeInOut, value: viewModel.isValidButtonEnable)
            }
            .padding()
            .navigationBarStyle(title: "註冊帳號")
        }
        .onTapGesture {
            hideKeyboard()
        }
        
    }//body
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}


// MMARK: - RoundedTextFieldView

struct RoundedTextFieldView: View {
    @Binding var text: String
    let placeholder: String
    let iconName: String
    var keyboardType: UIKeyboardType = .default
    let iconSize: CGFloat
    let itemFrame: CGFloat
    var shouldLimit: Bool = false
    var limitCount = 10
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: iconName)
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(.gray)
            TextField(placeholder, text: $text)
                .padding(8)
                .keyboardType(keyboardType)
                .limitInputLength(value: $text, length: limitCount, shouldLimit: shouldLimit)
//                .limitInputLength(value: $text, length: 10)
        }
        .padding(.horizontal, 8)
        .frame(height: itemFrame)
        .roundedBackground()
    }
}




