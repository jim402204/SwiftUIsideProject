//
//  FastRegisterPackageView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/26.
//

import SwiftUI

struct FastRegisterPackageView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FastRegisterPackageView()
}


import SwiftUI

struct CameraOutsideView: View {
    @State private var isCameraPresented = false
    @State private var imageData: Data?

    var body: some View {
        VStack(spacing: 20) {
            if let imageData = imageData {
                Image(uiImage: UIImage(data: imageData) ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(10)
            } else {
                Text("No image captured")
                    .foregroundColor(.gray)
            }

            Button(action: {
                isCameraPresented = true
            }) {
                Text("Open Camera")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .sheet(isPresented: $isCameraPresented) {
            CameraView(isPresented: $isCameraPresented, capturedImageDate: $imageData)
        }
    }
}
