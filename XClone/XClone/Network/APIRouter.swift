//
//  APIRouter.swift
//  XClone
//
//  Created by yun on 2023/08/04.
//

import Alamofire
import Foundation

enum ContentType: String {
    case json                                       = "application/json"
    case wwwFormURLEncoded                          = "x-www-form-urlencoded"
    case authorization                              = "authorization"
    case apiKey                                     = "x_api_key"
    case unspecified                                = ""
}

enum HTTPHeaderField: String {
    case authentication                             = "Authorization"
    case contentType                                = "Content-Type"
    case acceptType                                 = "Accept"
    case acceptEncoding                             = "Accept-Encoding"
    case accessToken                                = "X-WLB-Authorization"
    case apiKey                                     = "x-api-key"
    case userAgent                                  = "User-Agent"
}

protocol Endpoint: URLRequestConvertible {
    var base: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    var contentType: ContentType { get }
}

enum APIRouter {
    case getForyou
    case getProfile
    case getFollowing
    case getRecommend
}

extension APIRouter: Endpoint {
    var contentType: ContentType {
        switch self {
        default:
            return .json
        }
    }
    
    var parameters: Parameters {
        switch self {
        default:
            return [:]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getForyou:
            return .get
        case .getProfile:
            return .get
        case .getFollowing:
            return .get
        case .getRecommend:
            return .get
        }
    }
    
    var base: String {
        return URLs.baseURL
    }
    
    var path: String {
        switch self {
        case .getForyou:
            return "/twits/foryou"
        case .getProfile:
            return "/profile"
        case .getFollowing:
            return "/twits/following"
        case .getRecommend:
            return "/community/recommend"
        }
        
    }
    
    // MARK: URLRequestConvertible
    /// このメソッドはSession().request()もしくはAF.request()で呼ばれます。
    func asURLRequest() throws -> URLRequest {
        let url = try base.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path), cachePolicy: .reloadIgnoringLocalCacheData)
        urlRequest.httpMethod = method.rawValue
        
        if self.parameters.count > 0 {
            urlRequest = try! URLEncoding.default.encode(urlRequest, with: self.parameters)
        }
        return urlRequest
    }
}

