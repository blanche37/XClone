//
//  TimelineViewModel.swift
//  XClone
//
//  Created by yun on 2023/08/01.
//

import Combine
import UIKit
import Alamofire

protocol TimelineViewModelProtocol {
    var tableViewPreviousOffset: CGFloat? { get set }
    var twitSubject: CurrentValueSubject<[Twit], Never> { get }
    func setupTwits(_ twits: [Twit])
    func decodeTwits(data: Data) async throws -> [Twit]
    func requestForyou() async throws -> [Twit]
    func requestFollowing() async throws -> [Twit]
    func getImage(url: URLConvertible) async throws -> UIImage?
}

final class TimelineViewModel: TimelineViewModelProtocol {
    var tableViewPreviousOffset: CGFloat?
    private(set) var twitSubject = CurrentValueSubject<[Twit], Never>([])
    
    init() {
        Task {
            let twits: [Twit] = try await requestForyou()
            setupTwits(twits)
        }
    }
    
    func setupTwits(_ twits: [Twit]) {
        twitSubject.send(twits)
    }
    
    func decodeTwits(data: Data) async throws -> [Twit] {
        return try JSONDecoder().decode([Twit].self, from: data)
    }
    
    func requestForyou() async throws -> [Twit] {
        return try await APIClient.shared.performRequestArray(route: APIRouter.getForyou)
    }
    
    func requestFollowing() async throws -> [Twit] {
        return try await APIClient.shared.performRequestArray(route: APIRouter.getFollowing)
    }
    
    func getImage(url: URLConvertible) async throws -> UIImage? {
        let data = try await APIClient.shared.performRequest(url: url)
        print(data)
        return UIImage(data: data)
    }
}
