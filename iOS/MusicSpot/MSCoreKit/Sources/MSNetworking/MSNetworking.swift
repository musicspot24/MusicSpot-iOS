//
//  MSNetworking.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Combine
import Foundation

import MSLogger

public struct MSNetworking {

    // MARK: Nested Types

    // MARK: Public

    public typealias TimeoutInterval = DispatchQueue.SchedulerTimeType.Stride

    // MARK: Static Properties

    // MARK: - Constants

    public static let dispatchQueueLabel = "com.MSNetworking.MSCoreKit.MusicSpot"

    // MARK: Properties

    public let queue: DispatchQueue

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions.insert(.withFractionalSeconds)
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            let dateString = dateFormatter.string(from: date)
            try container.encode(dateString)
        }
        return encoder
    }()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions.insert(.withFractionalSeconds)
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Date 디코딩 실패: \(dateString)"
            )
        }
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private let session: Session

    // MARK: Lifecycle

    // MARK: - Initializer

    public init(session: Session) {
        self.session = session
        queue = DispatchQueue(label: MSNetworking.dispatchQueueLabel, qos: .background)
    }

    // MARK: Functions

    /// ``Router``를 사용해 HTTP 네트워킹을 수행합니다. Combine을 사용합니다.
    /// - Parameters:
    ///   - type: 결과로 받을 값의 타입. `String.self`의 형태로 제공합니다.
    ///   - router: 네트워킹에 대한 정보를 담은 ``Router``
    ///   - timeoutInterval: 네트워킹에 대한 타임아웃 시간
    /// - Returns: 결과값과 에러를 담은 AnyPublisher
    public func request<T: Decodable>(
        _ type: T.Type,
        router: Router,
        timeoutInterval: TimeoutInterval = .seconds(3)
    )
        -> AnyPublisher<T, Error>
    {
        guard let request = router.makeRequest(encoder: encoder) else {
            return Fail(error: MSNetworkError.invalidRouter).eraseToAnyPublisher()
        }

        return session
            .dataTaskPublisher(for: request)
            .timeout(timeoutInterval, scheduler: queue)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse else {
                    throw MSNetworkError.unknownResponse
                }
                guard 200..<300 ~= response.statusCode else {
                    throw MSNetworkError.invalidStatusCode(
                        statusCode: response.statusCode,
                        description: response.description
                    )
                }
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    /// ``Router``를 사용해 HTTP 네트워킹을 수행합니다. Swift Concurrency을 사용합니다.
    /// - Parameters:
    ///   - type: 결과로 받을 값의 타입. `String.self`의 형태로 제공합니다.
    ///   - router: 네트워킹에 대한 정보를 담은 ``Router``
    ///   - timeoutInterval: 네트워킹에 대한 타임아웃 시간
    /// - Returns: 결과값과 에러를 담은 Result
    public func request<T: Decodable>(
        _: T.Type,
        router: Router,
        timeoutInterval: TimeoutInterval = .seconds(3)
    )
        async -> Result<T, Error>
    {
        guard let request = router.makeRequest(encoder: encoder) else {
            return .failure(MSNetworkError.invalidRouter)
        }

        do {
            return try await withThrowingTaskGroup(of: Result<T, Error>.self) { group in
                defer { group.cancelAll() }

                group.addTask {
                    let (data, response) = try await session.data(for: request, delegate: nil)
                    try Task.checkCancellation()

                    guard let response = response as? HTTPURLResponse else {
                        throw MSNetworkError.unknownResponse
                    }

                    guard 200..<300 ~= response.statusCode else {
                        let errorResponse = try decoder.decode(ErrorResponseDTO.self, from: data)
                        throw MSNetworkError.invalidStatusCode(
                            statusCode: errorResponse.statusCode,
                            description: errorResponse.message
                        )
                    }

                    do {
                        let decodedResult = try decoder.decode(T.self, from: data)
                        return .success(decodedResult)
                    } catch {
                        throw error
                    }
                }

                group.addTask {
                    try await Task.sleep(nanoseconds: UInt64(timeoutInterval.magnitude))
                    try Task.checkCancellation()
                    #if DEBUG
                    MSLogger.make(category: .network).warning("네트워킹 타임아웃: \(timeoutInterval.magnitude)ns")
                    #endif
                    throw MSNetworkError.timeout
                }

                guard let result = try await group.next() else {
                    throw MSNetworkError.unknownChildTask
                }
                return result
            }
        } catch {
            return .failure(error)
        }
    }

    // MARK: Private

}
