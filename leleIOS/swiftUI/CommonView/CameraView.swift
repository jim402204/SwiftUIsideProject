//
//  CameraView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/26.
//

import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var capturedImageDate: Data?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.capturedImageDate = resizeAndCompressImage(image: image, targetSizeInBytes: 200_000)
//                parent.capturedImageDate = getPNG(image: image)
            }
            parent.isPresented = false // 关闭相机视图
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false // 关闭相机视图
        }
        
        func resizeAndCompressImage(image: UIImage, targetSizeInBytes: Int, maxDimension: CGFloat = 512) -> Data? {
            // 缩小图片到指定最大宽/高
            let resizedImage = resizeImage(image: image, maxDimension: maxDimension)
            
            // 尝试压缩
            var compressionQuality: CGFloat = 0.7
            var compressedData = resizedImage.jpegData(compressionQuality: compressionQuality)
            
            while let data = compressedData, data.count > targetSizeInBytes, compressionQuality > 0.1 {
                compressionQuality -= 0.05
                compressedData = resizedImage.jpegData(compressionQuality: compressionQuality)
            }
            
            // 打印最终结果
            if let finalData = compressedData {
                print("Final compression quality: \(compressionQuality)")
                print("Final data size: \(finalData.count) bytes")
//                return finalData.count <= targetSizeInBytes ? finalData : nil
                return finalData
            } else {
                print("Compression failed")
                return nil
            }
        }
        
        func getPNG(image: UIImage,  maxDimension: CGFloat = 1024) -> Data? {
            // 缩小图片到指定最大宽/高
            let resizedImage = resizeImage(image: image, maxDimension: maxDimension)
            
            return resizedImage.pngData()
        }

        func resizeImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
            let originalSize = image.size
            let aspectRatio = originalSize.width / originalSize.height
            
            var newSize: CGSize
            if originalSize.width > originalSize.height {
                // 宽图片，限制宽度
                newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
            } else {
                // 高图片，限制高度
                newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
            }
            
            let renderer = UIGraphicsImageRenderer(size: newSize)
            return renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: newSize))
            }
        }


    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

//#Preview {
//    CameraView(isPresented: <#Binding<Bool>#>, capturedImage: <#Binding<UIImage?>#>)
//}



