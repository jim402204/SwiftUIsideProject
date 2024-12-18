//
//  String+.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/3.
//

import Foundation

//MARK: - 去掉空白

extension String {
    
    func trimming() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    //圖片含有中文處理
    func urlEncode() -> String {
        self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}

extension String {
    /// 提取路径中的第一个非空目录名称
    func firstPathComponent() -> String? {
        // 使用 "/" 分割字符串
        let components = self.split(separator: "/")
        // 返回第一个非空的路径组件
        return components.first.map { String($0) }
    }
}

extension String {
    /// 返回首字母小写的字符串
    func withLowercasedFirstLetter() -> String {
        // 确保字符串非空
        guard !self.isEmpty else { return self }
        
        // 获取第一个字符并将其转换为小写
        let first = self.prefix(1).lowercased()
        
        // 获取剩余的子字符串
        let remainder = self.dropFirst()
        
        // 拼接并返回新的字符串
        return first + remainder
    }
}
