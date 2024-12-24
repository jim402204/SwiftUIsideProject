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
