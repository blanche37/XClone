//
//  APIClient.swift
//  XClone
//
//  Created by yun on 2023/08/04.
//
import Alamofire
import Foundation

protocol APIClientProtocol {
    func performRequest(url: URLConvertible) async throws -> Data
    func performRequest<T: Decodable>(route: Endpoint) async throws -> T
    func performRequestArray<T: Decodable>(route: Endpoint) async throws -> [T]
}

final class APIClient: APIClientProtocol {
    static let shared = APIClient()
    
    func performRequest(url: URLConvertible) async throws -> Data {
        let response = await AF
            .request(url)
            .serializingData()
            .response
        guard let statusCode = response.response?.statusCode else { throw NetworkError.statusCode(0) }
        
        switch statusCode {
        case 200..<300:
            if let data = response.data {
                return data
            } else {
                throw NetworkError.noData
            }
        default:
            throw NetworkError.statusCode(statusCode)
        }
    }
    
    func performRequest<T: Decodable>(route: Endpoint) async throws -> T {
        let response = await AF
            .request(route)
            .serializingDecodable(T.self)
            .response
        guard let statusCode = response.response?.statusCode else { throw NetworkError.statusCode(0) }

        switch statusCode {
        case 200..<300:
            if let decodable = response.value {
                return decodable
            } else {
                throw NetworkError.noData
            }
        default:
            throw NetworkError.statusCode(statusCode)
        }
    }
    
    func performRequestArray<T: Decodable>(route: Endpoint) async throws -> [T] {
        let response = await AF
            .request(route)
            .serializingDecodable([T].self)
            .response
        guard let statusCode = response.response?.statusCode else { throw NetworkError.statusCode(0) }

        switch statusCode {
        case 200..<300:
            if let decodable = response.value {
                return decodable
            } else {
                throw NetworkError.noData
            }
        default:
            throw NetworkError.statusCode(statusCode)
        }
    }
}
