//
//  APIService+Async.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/16.
//
import Moya
import Foundation

extension APIService {
    
    func requestA<Request: ApiTargetType>(_ request: Request) async throws -> Request.ResponseDataType {
        let target = MultiTarget(request)
        
        do {
            return try await provider.requestAsync(target,to: Request.ResponseDataType.self)
        } catch {
            // 在此处处理错误，例如记录日志或转换错误类型
            self.onError(error)
            throw error // 重新抛出错误以供调用者处理
        }
    }
    
    func requestARow<Request: ApiTargetType>(_ request: Request) async throws -> Response {
        let target = MultiTarget(request)
        do {
            return try await provider.requestAsync(target)
        } catch {
            // 在此处处理错误，例如记录日志或转换错误类型
            self.onError(error)
            throw error // 重新抛出错误以供调用者处理
        }
    }
    
}

extension MoyaProvider {
    /// 发起请求，返回 Moya.Response
    func requestAsync(_ target: Target) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /// 发起请求并直接解码成指定模型
    func requestAsync<T: Decodable>(_ target: Target, to type: T.Type, decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        let response = try await requestAsync(target)
        guard (200...299).contains(response.statusCode) else {
            throw MoyaError.statusCode(response)
        }
        
//        print("requestAsync response.data: \(String(data: response.data, encoding: .utf8) ?? "")")
        
        // 检查数据是否为空或为 "null"
        if response.data.isEmpty || response.data == Data("null".utf8) {
            if let optionalType = T.self as? OptionalProtocol.Type {
                return optionalType.wrappedTypeNilValue as! T
            } else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Response data is null but ResponseDataType is not optional."
                ))
            }
        }
        
        return try decoder.decode(T.self, from: response.data)
    }
}

protocol OptionalProtocol {
    static var wrappedTypeNilValue: Any? { get }
}

extension Optional: OptionalProtocol {
    static var wrappedTypeNilValue: Any? {
        return nil
    }
}

// MARK: - 檢查thread 是否在MainThread

import Dispatch

func checkIfMainThread() {
    if Thread.isMainThread {
        print("thread Running on the main thread.")
    } else {
        print("thread Not running on the main thread.")
    }
}

// MARK: - async do catch 改寫法

// 定义一个函数，接受成功和失败的闭包
func performAsyncOperation<T>(
    operation: @escaping () async throws -> T,
    onSuccess: @escaping (T) -> Void,
    onFailure: ((Error) -> Void)? = nil
) {
    _Concurrency.Task {
        do {
            // 执行异步操作
            let result = try await operation()
            // 在主线程上调用成功闭包
            await MainActor.run {
                onSuccess(result)
            }
        } catch {
            // 在主线程上调用失败闭包
            await MainActor.run {
                onFailure?(error)
            }
        }
    }
}


