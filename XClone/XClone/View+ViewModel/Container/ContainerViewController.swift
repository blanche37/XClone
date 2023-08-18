//
//  ViewController.swift
//  XClone
//
//  Created by yun on 2023/08/01.
//

import UIKit
import Combine
import CombineCocoa

final class ContainerViewController: UIViewController {
    private var currentViewController: UIViewController?
    private let viewModel: ContainerViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private let underView = UIView()
    private let frontView = UIView() // underView의 이벤트를 받지 않게 하기 위해서 존재
    private(set) var navigationView: XNavigationView?

    private(set) var contentView = UIView()
    private var tabBarView: TabBarView!
    private let newTwitButton = UIButton()
    private let profileView = ProfileView()
    
    // MARK: Initializer
    init(viewModel: ContainerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(viewModel: ContainerViewModel())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let tabBarView = TabBarView(itemCount: viewModel.tabBarItemCount, imageNames: viewModel.tabBarImageNames, actions: viewModel.tabBarActions) else {
            return
        }
        
        self.tabBarView = tabBarView
        bindToViewModel()
        setupViews()
        viewModel.setupCurrentVC(.timeline)
        frontView.isHidden = true
    }
    
    private func setupViews() {
        contentView.backgroundColor = .black
        newTwitButton.backgroundColor = .systemBlue
        newTwitButton.setImage(UIImage(systemName: "plus"), for: .normal)
        newTwitButton.tintColor = .white // 틴트컬러가 그래서 뭔데 ?
        newTwitButton.layer.cornerRadius = 25
        frontView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpFrontView))
        frontView.addGestureRecognizer(tapGesture)
        
        [profileView, underView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [contentView, tabBarView, newTwitButton, frontView].forEach {
            underView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileView.trailingAnchor.constraint(equalTo: underView.leadingAnchor),
            profileView.topAnchor.constraint(equalTo: view.topAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            profileView.widthAnchor.constraint(equalToConstant: view.frame.width / 4 * 3),
            
            underView.topAnchor.constraint(equalTo: view.topAnchor),
            underView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            underView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            underView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: underView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: underView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: underView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: underView.bottomAnchor),
            
            newTwitButton.heightAnchor.constraint(equalToConstant: 50),
            newTwitButton.widthAnchor.constraint(equalToConstant: 50),
            newTwitButton.trailingAnchor.constraint(equalTo: underView.trailingAnchor, constant: -15),
            newTwitButton.bottomAnchor.constraint(equalTo: tabBarView.topAnchor, constant: -10),
            
            tabBarView.leadingAnchor.constraint(equalTo: underView.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: underView.trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: underView.bottomAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: 100),
            
            frontView.topAnchor.constraint(equalTo: underView.topAnchor),
            frontView.bottomAnchor.constraint(equalTo: underView.bottomAnchor),
            frontView.leadingAnchor.constraint(equalTo: underView.leadingAnchor),
            frontView.trailingAnchor.constraint(equalTo: underView.trailingAnchor)
        ])
        
    }
    
    private func bindToViewModel() {
        viewModel.profileSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profile in
                guard let self = self else { return }
                self.navigationView?.setProfileImage(imageName: profile?.smallImage ?? "")
                self.profileView.nicknameLabel.text = profile?.name
                self.profileView.profileImageView.image = UIImage(named: profile?.smallImage ?? "")
                self.profileView.mentionIdLabel.text = profile?.mentionId
            }
            .store(in: &cancellables)
        
        viewModel.currentVCSubject
            .flatMap { [weak self] vc -> Just<UIViewController> in
                self?.removeCurrentVC(currentVC: self?.currentViewController)
                
                switch vc {
                case .timeline:
                    self?.buildTimelineNavigationBar()
                    return Just(TimelineViewController())
                case .search:
                    self?.buildSearchNavigationBar()
                    return Just(SearchViewController())
                case .community:
                    self?.buildCommunityNavigationBar()
                    return Just(CommunityViewController())
                case .notification:
                    return Just(NotificationViewController())
                case .message:
                    return Just(MessageViewController())
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (vc: UIViewController) in
                guard let self = self else { return }
                self.addChild(vc)
                self.contentView.addSubview(vc.view)
                vc.view.frame = self.contentView.bounds
                vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                vc.didMove(toParent: self)
                self.currentViewController = vc
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .profileImageTapped)
            .sink { [weak self] _ in
                self?.displayProfileView()
                self?.frontView.isHidden = false
            }
            .store(in: &cancellables)
        
                NotificationCenter.default.publisher(for: .displayBar)
                    .sink { [weak self] _ in
                        self?.displayBar()
                    }
                    .store(in: &cancellables)

                NotificationCenter.default.publisher(for: .hideBar)
                    .sink { [weak self] _ in
                        self?.hideBar()
                    }
                    .store(in: &cancellables)
    }
    
    private func removeCurrentVC(currentVC: UIViewController?) {
        currentVC?.willMove(toParent: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()
    }
    
    // MARK: Animation
    private func displayProfileView() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            [profileView, underView].forEach {
                $0.transform = CGAffineTransform(translationX: self.view.frame.width / 4 * 3, y: 0)
            }
        }
    }
    
    private func hideProfileView() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            [profileView, underView].forEach {
                $0.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }
    }
    
    private func displayBar() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut]) { [weak self] in
            self?.navigationView?.transform = CGAffineTransform(translationX: 0, y: 0)
            self?.tabBarView?.transform = CGAffineTransform(translationX: 0, y: 0)
            self?.newTwitButton.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    private func hideBar() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut]) { [weak self] in
            self?.navigationView?.transform = CGAffineTransform(translationX: 0, y: -150)
            self?.tabBarView?.transform = CGAffineTransform(translationX: 0, y: 100)
            self?.newTwitButton.transform = CGAffineTransform(translationX: 0, y: 50)

        }
    }
    
    // MARK: Build NavigationBar
    private func buildTimelineNavigationBar() {
        let imageView = UIImageView(image: UIImage(named: "Twitter-X-White-Logo-PNG"))
        guard let buttonStackView = XNavigationButtonStackView(
            buttonCount: 2,
            buttonTitles: ["For you", "Following"],
            buttonActions: [
                {
                    NotificationCenter.default.post(name: .foryou, object: nil)
                }
                ,
                {
                    NotificationCenter.default.post(name: .following, object: nil)
                }
            ])
        else {
            return
        }
        
        if navigationView?.superview != nil {
            navigationView?.removeFromSuperview()
        }
        
        navigationView = NavigationBarBuilder()
            .setTitleView(imageView, true)
            .setBottomView(buttonStackView)
            .build()
        
        guard let navigationView = navigationView else {
            return
        }
        
        underView.addSubview(navigationView)
        underView.bringSubviewToFront(frontView)
        
        navigationView.setProfileImage(imageName: viewModel.profileSubject.value?.smallImage ?? "")
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: underView.topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: underView.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: underView.trailingAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func buildCommunityNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Community"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        navigationView?.removeFromSuperview()
        
        navigationView = NavigationBarBuilder()
            .setTitleView(titleLabel, false)
            .build()
        
        guard let navigationView = navigationView else {
            return
        }
        underView.addSubview(navigationView)
        underView.bringSubviewToFront(frontView)
        
        navigationView.setProfileImage(imageName: viewModel.profileSubject.value?.smallImage ?? "")
        navigationView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: underView.topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: underView.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: underView.trailingAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func buildSearchNavigationBar() {
        let searchView = SearchView()
        
        navigationView?.removeFromSuperview()
        
        navigationView = NavigationBarBuilder()
            .setTitleView(searchView, false)
            .build()
        
        guard let navigationView = navigationView else {
            return
        }
        underView.addSubview(navigationView)
        underView.bringSubviewToFront(frontView)
        
        navigationView.setProfileImage(imageName: viewModel.profileSubject.value?.smallImage ?? "")
        navigationView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: underView.topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: underView.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: underView.trailingAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    @objc private func touchUpProfileImage() {
        displayProfileView()
    }
    
    @objc private func touchUpFrontView() {
        hideProfileView()
        frontView.isHidden = true
    }
}
