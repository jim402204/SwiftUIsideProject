//
//  MyPlugin.swift
//  CoursePass
//
//  Created by 江俊瑩 on 2022/4/7.
//

import Moya
import SwiftyJSON
import Foundation

class MyPlugin: PluginType {
/*    
    要concurrent時可以用
    static let concurrentQueue = DispatchQueue(label: "conRequestsQueue", attributes: .concurrent)
    MyPlugin.concurrentQueue.async(qos: .userInteractive, flags: .barrier) { }
*/
    // 全局串行队列，用于同步访问 activeRequests
    static let queue = DispatchQueue(label: "requestsQueue")
    // APIService 使用並非只有單例 可用UUID() 確認
    static var activeRequests = [String: Int]()
    
    init() {}
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
//        let text = String(data: request.httpBody ?? Data(), encoding: .utf8)
//        print("request: \(request.url) \nhttpBody: \(text)")
        return request
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        
        ifDebug {
            print("\n\(target)")
            print("request headers: \(String(describing: target.headers ?? [:]))\n")
        }
        
        hudShow(request, target: target)
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        hudDismiss(target: target)
        
        logAndErrorHandling(result)
        
    }
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        return result
    }
    
    
}

// MARK: - error handling

extension MyPlugin {
    /// log 跟 錯誤處理show toast
    func logAndErrorHandling(_ result: Result<Response, MoyaError>) {
        

        switch result {
        case .success(let response):
            
            let statusCode = response.statusCode
        
            ifDebug {
                let json = JSON(response.data)
                if let requestURL = response.request?.url {
                    print("response url: \(String(describing: requestURL))")
                }
                print("statusCode: \(statusCode)")
                print("json: \(json)")
            }
            
        case .failure(let moyaError):
            
            dump(moyaError,name: "moyaError")
            let errorBody = try? moyaError.response?.mapJSON()
            print("error josn: \(String(describing: errorBody))")
            
            switch moyaError {
            case .statusCode(let response):
                print("error statusCode: \(String(describing: response))")
            case .underlying(let underlyingError as NSError, _):
                print("underlyingError: \(String(describing: underlyingError.localizedDescription))")
                
                if let afError = underlyingError.asAFError {
                    if case .sessionTaskFailed(error: let error) = afError {
                        let nsError = error as NSError
                        if nsError.domain == NSURLErrorDomain {
                            print("這是一個網絡相關的錯誤")
                            if nsError.code == NSURLErrorTimedOut {
                                // Handle timeout here
                                print("请求超时")
//                                ToastView().showView(type: .error, text: "請求超時！")
                            } else {
                                print("這是一個網絡相關的錯誤")
//                                ToastView().showView(type: .error,text: "網路異常！")
                            }
                        }
                    }
                }
                
            default: break
            }
        }
        
        
    }
}

// MARK: - show/hide laoding view
private extension MyPlugin {
    
    func hudShow(_ request: RequestType, target: TargetType) {
        
        guard target.headers?[needShowHub] == nil  else { return }
        
//        hud.show()
        hudAnimateLog()

        MyPlugin.queue.async {
            let requestID = "\(target.method.rawValue)-\(target.path)"
            // 增加請求計數
            MyPlugin.activeRequests[requestID, default: 0] += 1
        }
    }
    
    func hudDismiss(target: TargetType) {
        
        guard target.headers?[needShowHub] == nil  else { return }
        
        MyPlugin.queue.async {
            let requestID = "\(target.method.rawValue)-\(target.path)"
            // 減少請求計數
            if let currentCount = MyPlugin.activeRequests[requestID], currentCount > 1 {
                MyPlugin.activeRequests[requestID] = currentCount - 1
            } else {
                MyPlugin.activeRequests.removeValue(forKey: requestID)
            }
        }
        
        if requestIsEmpty() {
//            hud.dismiss()
        }
        hudAnimateLog()
    }
    
    // 檢查是否還有活動的請求
    func requestIsEmpty() -> Bool {
        return MyPlugin.queue.sync {
            return MyPlugin.activeRequests.isEmpty
        }
    }
    
    func hudAnimateLog() {
        
//        DispatchQueue.main.asyncAfter(deadline: .now(), execute: DispatchWorkItem(block: {
//            print("\(#function): \(hud.isAnimating)")
//        }))
    }
    
}

//https://www.gushiciku.cn/pl/aCgJ/zh-tw
//https://juejin.cn/post/7041831520155205640
//步驟1： PluginType process 把success 401回傳error 並修改Response 把json code 填入statusCode (只有error 才會觸發retry)

//步驟2: RequestInterceptor adapt 加入新的token retry判斷401 request.retryCount == 0 (不然會一直retry) new 新的 MoyaProvider<MultiTarget> call refreshToken api
