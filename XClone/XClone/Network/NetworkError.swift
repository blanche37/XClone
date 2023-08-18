//
//  NetworkError.swift
//  XClone
//
//  Created by yun on 2023/08/18.
//

import Alamofire

enum NetworkError: Error {
    case afError(AFError)
    case decodingError(DecodingError)
    case unknownError(Error)
    case statusCode(Int)
    case noData
}
