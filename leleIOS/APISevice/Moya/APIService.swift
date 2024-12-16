//
//  APIService.swift
//  vxu
//
//  Created by 江俊瑩 on 2022/3/4.
//

import Moya
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
    
    private init() {}
    lazy var provider = MoyaProvider<MultiTarget>(session: customSession(), plugins: [MyPlugin()])
    
    
    
    
}

import Combine
import CombineMoya

extension APIService {
    typealias CombinePublisher = AnyPublisher<Moya.Response, MoyaError>
    
    func request<Request: ApiTargetType>(_ request: Request) -> AnyPublisher<Request.ResponseDataType, MoyaError> {
        let target = MultiTarget(request)
        
        return provider.requestPublisher(target)
            .map(Request.ResponseDataType.self)
            .handleEvents(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.onError(error) // 處理錯誤
                }
            })
            .eraseToAnyPublisher() // 將結果轉換為 AnyPublisher
    }
    
    func requestRaw<Request: ApiTargetType>(_ request: Request) -> CombinePublisher {
        let target = MultiTarget(request)
        
        return provider.requestPublisher(target)
            .handleEvents(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.onError(error) // 處理錯誤
                }
            })
            .eraseToAnyPublisher() // 將結果轉換為 AnyPublisher
    }
    /// 自定义错误信息
    static func failWithMoyaError<T>(_ message: String, code: Int = -1) -> AnyPublisher<T, MoyaError> {
        let error = MoyaError.underlying(NSError(domain: "error", code: code, userInfo: [NSLocalizedDescriptionKey: message]), nil)
        return Fail<T, MoyaError>(error: error).eraseToAnyPublisher()
    }
    static func emptyPublisher<T>(type: T.Type = T.self) -> AnyPublisher<T, MoyaError> {
        return Empty<T,MoyaError>().eraseToAnyPublisher()
    }
}

import RxSwift

extension APIService {
    
    func requestRx<Request: ApiTargetType>(_ request: Request, alerts: [ShowAlertMsg] = []) -> Single<Request.ResponseDataType> {
        
        let target = MultiTarget.init(request)
        
        return provider.rx.request(target)
            .map(Request.ResponseDataType.self)
            .do(onError: { error in
                self.onError(error)
            })
            
    }
    /// 直接回respone
    func requestRxRaw<Request: ApiTargetType>(_ request: Request, alerts: [ShowAlertMsg] = []) -> Single<Moya.Response> {
        let target = MultiTarget.init(request)
        
        return provider.rx.request(target)
            .do(onError: { error in
                self.onError(error)
            })
    }
    
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {}

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

        let defaultHeader = HTTPHeaders.default
//        defaultHeader.add(HTTPHeader.userAgent(new))
//        print("configuration defaultHeader: \(defaultHeader)")
        
        configuration.headers = defaultHeader
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout
        return Session(configuration: configuration, startRequestsImmediately: false)
    }
    
}



struct ShowAlertMsg {
    let code: Int
    let message: String
}

extension Moya.Response { //測試時 要有respone 才會進呀
    
}

