//
//  CommunityViewModel.swift
//  XClone
//
//  Created by yun on 2023/08/03.
//

import Foundation
import Combine

protocol CommunityViewModelProtocol {
    var communitySubject: CurrentValueSubject<[Community], Never> { get }
}

final class CommunityViewModel: CommunityViewModelProtocol {
    private let client: APIClientProtocol
    
    init(client: APIClientProtocol) {
        self.client = client
        
        Task {
            let communities = try await getCommunities()
            setupCommunities(communities)
        }
    }
    
    convenience init() {
        self.init(client: APIClient())
    }
    
    var communitySubject = CurrentValueSubject<[Community], Never>([])
    
    private func setupCommunities(_ communities: [Community]) {
        communitySubject.send(communities)
    }
    
    private func getCommunities() async throws -> [Community] {
        return try await client.performRequest(route: APIRouter.getRecommend)
    }
    
    
}
