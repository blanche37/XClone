//
//  XNavigationView2.swift
//  XClone
//
//  Created by yun on 2023/08/02.
//

import UIKit
import Combine
import CombineCocoa

final class NavigationBarBuilder {
    private let navigationBar = XNavigationView()
    
    func setTitleView(_ view: UIView, _ haveIntrinsicContentSize: Bool) -> Self {
        self.navigationBar.titleViewHasIntrinsicContentSize = haveIntrinsicContentSize
        self.navigationBar.titleView = view
        return self
    }
    
    func setRightView(_ view: UIView) -> Self {
        self.navigationBar.rightView = view
        return self
    }
    
    func setBottomView(_ view: UIView) -> Self {
        self.navigationBar.bottomView = view
        return self
    }
    
    func build() -> XNavigationView {
        return navigationBar
    }
}

// TODO: 현재 텝바의 아이템이 변경되면 , 네비게이션뷰도 빌더로 새로 만들어야함.
final class XNavigationView: UIVisualEffectView {
    private let profileImageView = UIImageView()
    private var cancellables = Set<AnyCancellable>()
    var titleViewHasIntrinsicContentSize: Bool!
    var titleView: UIView? { didSet { setupTitleView(haveIntrinsicContentSize: titleViewHasIntrinsicContentSize) } }
    var rightView: UIView? { didSet { setupRightView() } }
    var bottomView: UIView? { didSet { setupBottomView() } }
    var underlineView = UIView()
    
    init() {
        let blurEffect = UIBlurEffect(style: .dark)
        super.init(effect: blurEffect)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProfileImage(imageName: String) {
        self.profileImageView.image = UIImage(named: imageName)
    }
    
    @objc private func showDetailProfile() {
        NotificationCenter.default.post(name: .profileImageTapped, object: nil)
    }
    
    private func setupViews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDetailProfile))
        profileImageView.addGestureRecognizer(tapGesture)
        
        profileImageView.backgroundColor = .white
        profileImageView.layer.cornerRadius = 15
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        underlineView.backgroundColor = .gray
        
        
        [profileImageView, underlineView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 30.0),
            profileImageView.widthAnchor.constraint(equalToConstant: 30.0),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            
            underlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func setupTitleView(haveIntrinsicContentSize: Bool) {
        guard let titleView = titleView else { return }
        contentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        // TODO: layout
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 30.0)
        ])
        
        if haveIntrinsicContentSize {
            titleView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        }
    }
    
    private func setupRightView() {
        guard let rightView = rightView else { return }
        contentView.addSubview(rightView)
        rightView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rightView.heightAnchor.constraint(equalToConstant: 40.0),
            rightView.widthAnchor.constraint(equalToConstant: 40.0),
            rightView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupBottomView() {
        guard let bottomView = bottomView else { return }
        contentView.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomView.heightAnchor.constraint(equalToConstant: 50),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -80),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0.5)
        ])
    }
}

import SwiftUI

fileprivate struct Preview: UIViewRepresentable {
    typealias UIViewType = XNavigationView
    
    func makeUIView(context: Context) -> XNavigationView {
        let view = UIView()
        let view2 = UIView()
        let view3 = UIView()
        view.backgroundColor = .white
        view2.backgroundColor = .white
        view3.backgroundColor = .white
        return NavigationBarBuilder().setTitleView(view, true).setRightView(view2).setBottomView(view3).build()
    }
    
    func updateUIView(_ uiView: XNavigationView, context: Context) {
        
    }
}

@available(iOS 13.0.0, *)
struct XNaigationPreView: PreviewProvider {
    static var previews: some View {
        VStack {
            Preview()
                .frame(width: 400, height: 150, alignment: .center)
                .background(Color.black)
            Spacer()
        }
    }
}













////
////  XNavigationView.swift
////  XClone
////
////  Created by yun on 2023/08/02.
////
//
//import UIKit
//
//fileprivate final class NavigationButton: UIView {
//    private let button = UIButton()
//    private let statusView = UIView()
//    private let title: String?
//
//    init(title: String?) {
//        self.title = title
//        super.init(frame: .zero)
//        setupViews()
//        self.backgroundColor = .clear
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func selectButton() {
//        button.isSelected = true
//    }
//
//    func deselectButton() {
//        button.isSelected = false
//    }
//
//    private func setupViews() {
//        button.setTitle(title, for: .normal)
//        button.setTitleColor(.gray, for: .normal)
//        button.setTitleColor(.darkGray, for: .highlighted)
//        button.setTitleColor(.white, for: .selected) // TODO: 수정필요
//
//        statusView.backgroundColor = .systemBlue
//
//        [button, statusView].forEach {
//            self.addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
//
//        let viewDictionary: [String: Any] = ["button": button, "status": statusView]
//        var hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[button]|", metrics: nil, views: viewDictionary)
//        hConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[status]|", metrics: nil, views: viewDictionary)
//        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[button]-10-[status(5)]|", metrics: nil, views: viewDictionary)
//
//        [hConstraints, vConstraints].forEach {
//            self.addConstraints($0)
//        }
//    }
//}
//
//final class XNavigationView: UIView {
//    private let profileImageView = UIImageView()
//    private let xLogoImageView = UIImageView()
//    private lazy var recommendButton = NavigationButton(title: "추천")
//    private lazy var followedButton = NavigationButton(title: "팔로우 중")
//    private let underlineView = UIView()
//
//    init() {
//        super.init(frame: .zero)
//        setupViews()
//    }
//
//    func selectRecommendButton() {
//        recommendButton.selectButton()
//        followedButton.deselectButton()
//    }
//
//    func selectFollowedButton() {
//        followedButton.selectButton()
//        recommendButton.deselectButton()
//    }
//
//    func setProfileImage(imageName: String) {
//        self.profileImageView.image = UIImage(named: imageName)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupViews() {
//        self.backgroundColor = UIColor.black.withAlphaComponent(0.3) // TODO: 나중에 수정
//
//        profileImageView.backgroundColor = .white
//        profileImageView.layer.cornerRadius = 20
//
//        xLogoImageView.backgroundColor = .clear
//        xLogoImageView.image = UIImage(named: "Twitter-X-White-Logo-PNG")
//
//        underlineView.backgroundColor = .gray
//        [profileImageView, xLogoImageView, recommendButton, followedButton, underlineView].forEach {
//            self.addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
//
//        NSLayoutConstraint.activate([
//            profileImageView.heightAnchor.constraint(equalToConstant: 40.0),
//            profileImageView.widthAnchor.constraint(equalToConstant: 40.0),
//            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//
//            xLogoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            xLogoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            xLogoImageView.heightAnchor.constraint(equalToConstant: 30.0),
//            xLogoImageView.widthAnchor.constraint(equalToConstant: 30.0),
//
//            recommendButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80),
//            recommendButton.bottomAnchor.constraint(equalTo: underlineView.topAnchor),
//
//            followedButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -80),
//            followedButton.bottomAnchor.constraint(equalTo: underlineView.topAnchor),
//
//            underlineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            underlineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            underlineView.heightAnchor.constraint(equalToConstant: 1.0),
//            underlineView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
//        ])
//    }
//}
//
////import SwiftUI
////
////struct Preview: UIViewRepresentable {
////    typealias UIViewType = XNavigationView
////
////    func makeUIView(context: Context) -> XNavigationView {
////        return XNavigationView()
////    }
////
////    func updateUIView(_ uiView: XNavigationView, context: Context) {
////
////    }
////}
////
////@available(iOS 13.0.0, *)
////struct ViewPreView: PreviewProvider {
////    static var previews: some View {
////        VStack {
////            Preview()
////                .frame(width: 400, height: 150, alignment: .center)
////                .background(Color.black)
////            Spacer()
////        }
////    }
////}
//
