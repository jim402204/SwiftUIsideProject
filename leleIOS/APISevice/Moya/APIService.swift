//
//  APIService.swift
//  vxu
//
//  Created by 江俊瑩 on 2022/3/4.
//

import Moya
import RxSwift
import SwiftyJSON
import RxMoya

protocol BaseResponseCode {
    var status: Int { get set }
}

struct BaseResponseData<T: Codable>: Codable, BaseResponseCode {
    var status: Int
    var data: T?
    // error message
    var msg: String?
    // 不要加error 回傳格式不固定
}

var apiService = APIService.shared

final class APIService {
    static let shared = APIService()
    
    init() {} //開放對外是因為 需要用con
    lazy var provider = MoyaProvider<MultiTarget>(session: customSession(), plugins: [MyPlugin()])
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func request<Request: ApiTargetType>(_ request: Request, alerts: [ShowAlertMsg] = []) -> Single<Request.ResponseDataType> {
        
        let target = MultiTarget.init(request)
        
        return provider.rx.request(target)
            .map(Request.ResponseDataType.self, using: decoder)
            .do(onError: { error in
                self.onError(error)
            })
            
    }
    /// 直接回respone
    func requestRaw<Request: ApiTargetType>(_ request: Request, alerts: [ShowAlertMsg] = []) -> Single<Moya.Response> {
        let target = MultiTarget.init(request)
        
        return provider.rx.request(target)
            .do(onError: { error in
                self.onError(error)
            })
    }
    
    /// 直接回respone  客制訊息用
    func requestNoHandle<Request: ApiTargetType>(_ request: Request) -> Single<Moya.Response> {
        let target = MultiTarget.init(request)
        
        return provider.rx.request(target)
    }
    
    
}

import Alamofire
import Foundation

extension APIService {
    func customSession<T: ApiTargetType>(request: T) -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = request.timeout
        configuration.timeoutIntervalForResource = request.timeout
        return Session(configuration: configuration, startRequestsImmediately: false)
    }
    // 一般使用統一
    func customSession(timeout: Double = 20) -> Session {
        let configuration = URLSessionConfiguration.default

        var defaultHeader = HTTPHeaders.default
//        defaultHeader.add(HTTPHeader.userAgent(new))
//        print("configuration defaultHeader: \(defaultHeader)")
        
        configuration.headers = defaultHeader
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout
        return Session(configuration: configuration, startRequestsImmediately: false)
    }
    
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {

    
 
}

struct ShowAlertMsg {
    let code: Int
    let message: String
}

extension Moya.Response { //測試時 要有respone 才會進呀

   
    
      
    
}

