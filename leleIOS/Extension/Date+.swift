//
//  Date+.swift
//  LeleTest
//
//  Created by 江俊瑩 on 2024/11/25.
//

import Foundation

extension Date {
    /// 返回當前日期的 ISO 8601 格式，帶有毫秒部分
    func toISO8601String() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
    
}
