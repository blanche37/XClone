//
//  ContainerViewModel.swift
//  XClone
//
//  Created by yun on 2023/08/01.
//

import Foundation
import Combine

enum ChildViewController {
    case timeline, search, community, notification, message
}

protocol ContainerViewModelProtocol {
    var tabBarItemCount: Int { get set }
    var tabBarImageNames: [(String, String)] { get }
    var profileSubject: CurrentValueSubject<Profile?, Never> { get }
    var currentVCSubject: PassthroughSubject<ChildViewController, Never> { get }
    var tabBarActions: [() -> Void] { get }
    func setupCurrentVC(_ vc: ChildViewController)
    func requestProfile() async throws -> Profile
}

final class ContainerViewModel: ContainerViewModelProtocol {
    var tabBarItemCount = 5
    var tabBarImageNames: [(String, String)] = [("house", "house.fill"),
                                                ("magnifyingglass.circle", "magnifyingglass.circle.fill"),
                                                ("person.2", "person.2.fill"),
                                                ("bell", "bell.fill"),
                                                ("envelope", "envelope.fill")]
    lazy var tabBarActions: [() -> Void] = [
        { self.setupCurrentVC(.timeline) },
        { self.setupCurrentVC(.search) },
        { self.setupCurrentVC(.community) },
        { self.setupCurrentVC(.notification) },
        { self.setupCurrentVC(.message) }
    ]
    var profileSubject = CurrentValueSubject<Profile?, Never>(nil)
    var currentVCSubject = PassthroughSubject<ChildViewController, Never>()
    
    init() {
        Task {
            let profile: Profile = try await requestProfile()
            setupProfile(profile)
        }
    }
    
    func setupCurrentVC(_ vc: ChildViewController) {
        currentVCSubject.send(vc)
    }
    
    private func setupProfile(_ profile: Profile) {
        profileSubject.send(profile)
    }
    
    private func decodeProfile(data: Data) async throws -> Profile {
        return try JSONDecoder().decode(Profile.self, from: data)
    }
    func requestProfile() async throws -> Profile {
        return try await APIClient.shared.performRequest(route: APIRouter.getProfile)
    }
}
