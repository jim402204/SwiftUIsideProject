//
//  testInsturctment.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2025/1/3.
//

import SwiftUI

struct DetailView666: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @State var testMemeryVeiwModel = TestMemeryVeiwModel()
    
    var body: some View {
        VStack {
            Text("這是詳細頁面")
                .appFont(.largeTitle)
                .padding()

            Button(action: {
                dismiss() // 點擊按鈕後返回上一頁
            }) {
                Text("返回")
                    .appFont(.title2)
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


import Observation

@Observable
class TestMemeryVeiwModel {
    
    init() {
        
        
    }
    
}

extension TestMemeryVeiwModel {
    
    func testTimeProfiler() {
        // 模拟性能瓶颈
        DispatchQueue.global().async {
            self.performHeavyComputation2()
        }
    }
    
    // 一个高耗时的计算函数
    func performHeavyComputation() {
        print("Starting heavy computation...")
        let array = (1...10_000_000).map { _ in Int.random(in: 0...10_000) }
        let sortedArray = array.sorted()
        print("Computation done. Sorted array count: \(sortedArray.count)")
    }
    
    func performHeavyComputation2() {
        print("Starting optimized computation...")
        let array = (1...10_000_000).map { _ in Int.random(in: 0...10_000) }
        
        // 并行排序优化
        let sortedArray: () = DispatchQueue.concurrentPerform(iterations: 2) { _ in
            array.sorted()
        }
        
        print("Computation done. Sorted array count: \(array.count)")
    }
}

extension TestMemeryVeiwModel {
    
    func testM() {
        // 开始测试
        print("Starting memory-intensive task...")
//        processImagesWithoutAutoreleasepool()
        processImagesWithAutoreleasepool()
        
//        processImagesWithGCDWorkItem()
//        processImagesWithoutGCDWorkItem()
    }
    
    // 使用 autoreleasepool 管理内存
    func processImagesWithAutoreleasepool() {
        
        DispatchQueue.global().async {
            
            for i in 1...500 { // 假设有 500 张图片
                autoreleasepool {
                    // 模拟加载图片（生成占位符图片）
                    if let image = self.generatePlaceholderImage(size: CGSize(width: 3000, height: 3000)) {
                        print("Processed image: image_\(i).jpg, size: \(image.size)")
                    }
                }
            }
            
        }
    }

    // 不使用 autoreleasepool 的对照测试
    func processImagesWithoutAutoreleasepool() {
        
        DispatchQueue.global().async {
            for i in 1...500 { // 假设有 500 张图片
                // 模拟加载图片（生成占位符图片）
                if let image = self.generatePlaceholderImage(size: CGSize(width: 3000, height: 3000)) {
                    print("Processed image: image_\(i).jpg, size: \(image.size)")
                }
            }
        }
    }

    // 占位符图片生成函数（模拟大图片加载）
    func generatePlaceholderImage(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.red.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // 使用 GCD 自定义队列的 .workItem 来管理内存
    func processImagesWithGCDWorkItem() {
        // 自定义并发队列，设置自动释放池频率为 .workItem
        let imageProcessingQueue = DispatchQueue(
            label: "com.example.imageProcessingQueue",
            attributes: .concurrent,
            autoreleaseFrequency: .workItem
        )

        for i in 1...500 { // 假设有 500 张图片
            imageProcessingQueue.async {
                // 模拟加载图片（生成占位符图片）
                if let image = self.generatePlaceholderImage(size: CGSize(width: 3000, height: 3000)) {
                    print("Processed image: image_\(i).jpg, size: \(image.size)")
                }
            }
        }
    }

    // 不使用 GCD 的对照测试
    func processImagesWithoutGCDWorkItem() {
        let imageProcessingQueue = DispatchQueue(
            label: "com.example.imageProcessingQueue",
            attributes: .concurrent
        )

        for i in 1...500 { // 假设有 500 张图片
            imageProcessingQueue.async {
                // 模拟加载图片（生成占位符图片）
                if let image = self.generatePlaceholderImage(size: CGSize(width: 3000, height: 3000)) {
                    print("Processed image: image_\(i).jpg, size: \(image.size)")
                }
            }
        }
    }
    
}



