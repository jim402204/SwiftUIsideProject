//
//  NewPasswordViewModel.swift
//  CoursePass
//
//  Created by 江俊瑩 on 2022/4/12.
//

import SwiftUI

class NewPasswordViewModel: ObservableObject {
    
    @Published var password = ""
    @Published var isNextPage: Bool = false
    var isButtonEnable: Bool { password.trimming().count > 0 }
    var bgColor: Color { isButtonEnable ? Color.app(.primary500) : Color.app(.primary500) }
    
    func callAPI() {
        print("callAPI")
    }
    
    
    
}
