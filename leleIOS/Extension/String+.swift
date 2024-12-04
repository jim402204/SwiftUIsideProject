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
