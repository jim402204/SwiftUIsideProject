//
//  Publisher+.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/16.
//
import Combine

extension Publisher {
    func sink(
        onSuccess: @escaping (Output) -> Void,
        onFailure: ((Failure) -> Void)? = nil,
        onCompletion: (() -> Void)? = nil
    ) -> AnyCancellable {
        return self.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                onFailure?(error) // 调用 onFailure 闭包，如果存在的话
            case .finished:
                onCompletion?() // 调用 onCompletion 闭包，如果存在的话
            }
        }, receiveValue: { value in
            onSuccess(value)
        })
    }
}

extension Publisher {
    func cFlatMapLatest<T: Publisher>(
        _ transform: @escaping (Output) -> T
    ) -> AnyPublisher<T.Output, Failure> where T.Failure == Failure {
        map(transform) // 将上游的每个值映射为新的 Publisher
            .switchToLatest() // 自动取消之前的流，切换到最新的流
            .eraseToAnyPublisher()
    }
}
