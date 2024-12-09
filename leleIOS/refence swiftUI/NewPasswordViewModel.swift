//
//  NewPasswordViewModel.swift
//  CoursePass
//
//  Created by 江俊瑩 on 2022/4/12.
//

import RxSwift
import SwiftUI

class NewPasswordViewModel: ObservableObject {
    
    @Published var password = ""
    @Published var isNextPage: Bool = false
    var isButtonEnable: Bool { password.trimming().count > 0 }
    var bgColor: Color { isButtonEnable ? Color.app(.primary500) : Color.app(.primary500) }
    
    private let disposeBag = DisposeBag()
    
    func callAPI() {
        print("callAPI")
        
//        APIService.shared.request(RegisterApi.Check(type: .forgotPasswordEmail, email: "email"))
        APIService.shared.requestTest(model: 1)
            .filter { $0.status == 200 }
            .subscribe(onSuccess: { [weak self] respone in
                guard let self = self else { return }

                self.isNextPage = true
            
//                let vc: NewPasswordViewController = UIStoryboard(.newPwd).instantiateViewController()
//                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    
    
}
