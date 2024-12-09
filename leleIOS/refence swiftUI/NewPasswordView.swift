//
//  TestView.swift
//  CoursePass
//
//  Created by 江俊瑩 on 2022/4/11.
//

import SwiftUI

struct NewPasswordView: View {
    let config: HostingConfiguration
    
    @ObservedObject var viewModel = NewPasswordViewModel()
    
    var body: some View {
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
        
//        NavigationView() {
        ZStack {
            
            Color.clear
                .background(LinearGradient(colors:
                                            [Color(UIColor(hex: "FFF6C6")),
                                             Color(UIColor(hex: "EBDBFF"))],
                                           startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea(.container, edges: [.top,.bottom])
            
            VStack(alignment: .leading, spacing: 0) {
                
                Spacer().frame(height: 96)
                
                Text("忘記密碼").titleText()
                    .transformEnvironment(\.font) { value in
                        
                    }
                
                Spacer().frame(height: 16)
                
                TextField("Email", text: $viewModel.password)
                    .appFont(.size(16))
                    .keyboardType(.asciiCapable)
                    .textFieldStyle(.custom(height: 32, cornerRadius: 5))
//                    .padding(-10)
//                    .textFieldStyle(.roundedBorder)
                    
                Spacer()
                
                NavigationLink(isActive: $viewModel.isNextPage) {
                    Text("第二頁")
                } label: {
                    Text("下一頁")
                        .confirmStyle(bgColor: viewModel.bgColor)
                    //只有擋在裡面才會擋住 Navigation跳轉
                        .onTapGesture {
                            viewModel.callAPI()
                        }
                        .onLongPressGesture(perform: {})
                }
                //必須黨在NavigationLink 才行
                .allowsHitTesting(viewModel.isButtonEnable)
                
                Spacer().frame(height: 24)
            }
            .padding([.leading,.trailing], 16)
            .frame(maxWidth: .infinity,alignment: .leading)
            .environment(\.font, .caption)
            .ignoresSafeArea(.container, edges: .top)
            //關閉鍵盤上推
//            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onAppear { print("onAppear") }
            
        }
        //關閉鍵盤上推
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
//        }//
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        NewPasswordView(config: HostingConfiguration())
    }
}

class HostingConfiguration {
    weak var hostingVC: UIViewController?    // << wraps reference
}

//忽略鍵盤推高
//https://stackoverflow.com/questions/63968241/swiftui-in-ios14-keyboard-avoidance-issues-and-ignoressafearea-modifier-issues
