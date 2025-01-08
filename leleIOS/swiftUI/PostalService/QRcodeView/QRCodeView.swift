//
//  QRCcodeView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2025/1/7.
//

import SwiftUI

struct QRCodeScanView: View {
    @StateObject private var viewModel = QRCodeScanViewModel()
    @State private var inputCode: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer().frame(height: 20)
            
            Text("請管理室人員掃描條碼\n開通身份/領取包裹/寄放物品")
                .multilineTextAlignment(.center)
            
            if let qrCodeImage = viewModel.qrCodeImage {
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
            } else {
                Image(systemName: "qrcode")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding()
            }
            
            Toggle("調整調整", isOn: $viewModel.isBrightness)
                .frame(width: 150)
                .onChange(of: viewModel.isBrightness) {
                    viewModel.handleBrightnessChange(isOn: $1)
                }
            
//            TextField("輸入開通序號", text: $inputCode)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//            
//            Button(action: {
//                
//            }) {
//                Text("序號開通")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.teal)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .appFont(.title2)

            Spacer()
        }
        .padding(.horizontal)
        .padding()
        .navigationBarStyle(title: "掃碼專區", hasTitleIcon: false)
    }
}

#Preview {
    NavigationStack {
        QRCodeScanView()
    }
}
