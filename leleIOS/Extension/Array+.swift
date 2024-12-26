//
//  Array+.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/23.
//

import Foundation

extension Array where Element: Equatable {
    
    mutating func remove (element: Element) {
        if let i = self.firstIndex(of: element) {
            self.remove(at: i)
        }
    }
}

extension Array {
    
    subscript(safe idx: Int) -> Element? {
        
        return indices ~= idx ? self[idx] : nil
    }
}


extension Encodable {
    /// 直接将Struct或Class转成Dictionary
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
