//
//  ApiService+.swift
//  CoursePass
//
//  Created by Jim on 2022/9/21.
//

import Moya
import SwiftyJSON
import Foundation

extension UserApi {
    /// Postman Moke Server 模擬https code 200 401 404 500 503
    struct Test: BaseTargetType {
        typealias ResponseDataType = BaseResponseData<Int>
        
        var baseURL: URL { URL(string: "https://b2981ede-420f-4c26-be55-a231be76a664.mock.pstmn.io")! }
        var path: String { return "503" }
    }
    
}

import Combine

extension APIService {
    
    // 模拟 API 测试用
    func requestTest<Model>(
        code: Int = 200,
        model: Model,
        respone: Bool = true,
        file: String = #file,
        method: String = #function,
        line: Int = #line
    ) -> AnyPublisher<BaseResponseData<Model>, Error> {
        
        return Future<BaseResponseData<Model>, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if respone {
                    promise(.success(BaseResponseData<Model>(status: code, data: model)))
                } else {
                    let error = NSError(
                        domain: "\(file) \(method) \(line) api error",
                        code: 0,
                        userInfo: [:]
                    )
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func onSuccess<apiTarget: ApiTargetType>(_ response: Response, input: apiTarget) {
        
        ifDebug {
//            let text = String(data: response.data, encoding: .utf8) ?? ""
            let json = JSON(response.data)
            if let requestURL = response.request?.url {
                print("response url: \(String(describing: requestURL))")
            }
            print("response: \(String(describing: input)) statusCode: \(response.statusCode)")
            print("json: \(json)")
//            debugPrint("text: \(text)")
//            dump(response,name: "\(response.request)")
        }
    }
    
    func onError(_ error: Error) {
        
        ifDebug {
            
            if let moyaError = error as? MoyaError {
                
                let errorBody = try? moyaError.response?.mapJSON()
                let statusCode = moyaError.response?.statusCode
                print("error: \(moyaError.errorDescription ?? "")\nstatusCode: \(String(describing: statusCode))")
                
                if case .objectMapping(_ , _) = moyaError {
                    print("errorBody: \(String(describing: errorBody))")
//                    ToastView().showView(type: .error,text: "Json解析異常！")
                }
            }
            print("\n error: \(error)")
        }
    }
    
}

extension Error {
    // error中取得 status code
    func getStatusCode() -> Int {
        
        let moyaError: MoyaError? = self as? MoyaError
        
        let json = JSON(moyaError?.response?.data as Any)
        let status = json["status"].intValue
        
        ifDebug {
            print("MoyaError json: \(json) \(status)")
        }
        return status
    }
    
}
