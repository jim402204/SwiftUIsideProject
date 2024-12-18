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

import Foundation

struct DateUtils {
    /// 返回共享的 DateFormatter
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // 確保格式一致性
        formatter.timeZone = TimeZone.current // 設置為當前時區
        return formatter
    }()
    
    /// 將 ISO8601 日期字符串轉換為指定格式的日期字符串
    static func formatISO8601Date(
        _ isoDate: String,
        from inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
        to format: String = "yyyy-MM-dd HH:mm"
    ) -> String {
        dateFormatter.dateFormat = inputFormat // ISO8601 格式
        guard let date = dateFormatter.date(from: isoDate) else {
            print("无法解析 ISO8601 日期字符串 \(isoDate)")
            return isoDate // 如果無法解析，返回原字符串
        }
        
        dateFormatter.dateFormat = format // 設置目標格式
        return dateFormatter.string(from: date)
    }
}
