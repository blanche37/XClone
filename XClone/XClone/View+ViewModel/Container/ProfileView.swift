//
//  ProfileView.swift
//  XClone
//
//  Created by yun on 2023/08/07.
//

import UIKit

final class ProfileView: UIView {
    private(set) var profileImageView = UIImageView()
    private let addAccountButton = UIButton()
    private(set) var nicknameLabel = UILabel()
    private(set) var mentionIdLabel = UILabel()
    private let followingCountLabel = UILabel()
    private let followingLabel = UILabel()
    private let followerCountLabel = UILabel()
    private let followerLabel = UILabel()
    private let profileButton = UIButton()
    private let blueButton = UIButton()
    private let bookmarkButton = UIButton()
    private let listButton = UIButton()
    private let spaceButton = UIButton()
    private let adsRevenueSharingButton = UIButton()
    private let dividerView = UIView()
    private let settingsButton = UIButton()
    private let settingsImageButton = UIButton()
    private lazy var settingsStackView = UIStackView(arrangedSubviews: [settingsButton, settingsImageButton])
    private let settingsAndPrivacyButton = UIButton()
    private let customerCenterButton = UIButton()
    private let buyButton = UIButton()
    private lazy var settingsAndPrivacyStackView = UIStackView(arrangedSubviews: [settingsAndPrivacyButton, customerCenterButton, buyButton])
    private let displayModeButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func touchUpStackView() {
        settingsImageButton.isSelected.toggle()
        
        if settingsImageButton.isSelected {
            settingsImageButton.tintColor = .systemBlue
            settingsImageButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            settingsAndPrivacyStackView.isHidden = false
            // 노말로 설정한이유. isEnable <- false이기때문에 상호작용을 받지않아. selected상태가 되지 않음
        } else {
            settingsImageButton.tintColor = .white
            settingsImageButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            settingsAndPrivacyStackView.isHidden = true
        }
    }
    
    private func setupViews() {        
        followingCountLabel.text = "0" // remove
        followingLabel.text = "following"
        followerCountLabel.text = "103,000,121" // remove
        followerLabel.text = "follower"
        
        profileImageView.backgroundColor = .white
        profileImageView.layer.cornerRadius = 15
        profileImageView.clipsToBounds = true
        
        addAccountButton.setImage(UIImage(systemName: "person.crop.circle.badge.plus"), for: .normal)
        addAccountButton.tintColor = .white
        
        nicknameLabel.textColor = .white
        nicknameLabel.font = .boldSystemFont(ofSize: 20)
        
        mentionIdLabel.textColor = .gray
        
        followingCountLabel.textColor = .white
        followingLabel.textColor = .gray
        followerCountLabel.textColor = .white
        followerLabel.textColor = .gray
        
        profileButton.setTitle("  프로필", for: .normal)
        profileButton.setImage(UIImage(systemName: "person"), for: .normal)
        profileButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        profileButton.tintColor = .white
        
        blueButton.setTitle("  Blue", for: .normal)
        blueButton.setImage(UIImage(systemName: "checkmark.seal"), for: .normal)
        blueButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        blueButton.tintColor = .white
        
        bookmarkButton.setTitle("  북마크", for: .normal)
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        bookmarkButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        bookmarkButton.tintColor = .white
        
        listButton.setTitle("  리스트", for: .normal)
        listButton.setImage(UIImage(systemName: "list.bullet.rectangle.portrait"), for: .normal)
        listButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        listButton.tintColor = .white
        
        spaceButton.setTitle("  스페이스", for: .normal)
        spaceButton.setImage(UIImage(systemName: "cube"), for: .normal)
        spaceButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        spaceButton.tintColor = .white
        
        adsRevenueSharingButton.setTitle("  수익 창출", for: .normal)
        adsRevenueSharingButton.setImage(UIImage(systemName: "dollarsign.square"), for: .normal)
        adsRevenueSharingButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        adsRevenueSharingButton.tintColor = .white
        
        dividerView.backgroundColor = .gray
   
        settingsStackView.axis = .horizontal
        settingsStackView.distribution = .equalCentering // 이게 뭐야 ?
        settingsStackView.spacing = 0
        
        settingsButton.setTitle("설정 및 지원", for: .normal)
        settingsButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        settingsButton.isEnabled = false
        
        settingsAndPrivacyStackView.isHidden = true
        
        settingsImageButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        settingsImageButton.tintColor = .white
        settingsImageButton.isEnabled = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpStackView))
        settingsStackView.addGestureRecognizer(tapGesture)
        
        settingsAndPrivacyButton.setTitle("  설정 및 개인정보 보호", for: .normal)
        settingsAndPrivacyButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsAndPrivacyButton.tintColor = .white
        settingsAndPrivacyButton.titleLabel?.font = .systemFont(ofSize: 15)
        
        customerCenterButton.setTitle("  고객센터", for: .normal)
        customerCenterButton.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        customerCenterButton.tintColor = .white
        customerCenterButton.titleLabel?.font = .systemFont(ofSize: 15)
        
        buyButton.setTitle("  구매", for: .normal)
        buyButton.setImage(UIImage(systemName: "cart"), for: .normal)
        buyButton.tintColor = .white
        buyButton.titleLabel?.font = .systemFont(ofSize: 15)
        
        settingsAndPrivacyStackView.axis = .vertical
        settingsAndPrivacyStackView.alignment = .leading
        settingsAndPrivacyStackView.distribution = .equalCentering
        
        displayModeButton.setImage(UIImage(systemName: "moon.stars"), for: .normal)
        displayModeButton.tintColor = .white
        
        [settingsButton, settingsImageButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [profileImageView, addAccountButton, nicknameLabel, mentionIdLabel, followingCountLabel, followingLabel, followerCountLabel, followerLabel, profileButton, blueButton, bookmarkButton, listButton, spaceButton, adsRevenueSharingButton, dividerView, settingsStackView, settingsAndPrivacyStackView, displayModeButton]
            .forEach {
                self.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            
            addAccountButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            addAccountButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            addAccountButton.heightAnchor.constraint(equalToConstant: 30),
            addAccountButton.widthAnchor.constraint(equalToConstant: 30),
            
            nicknameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            nicknameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            
            mentionIdLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            mentionIdLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 5),
            
            followingCountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            followingCountLabel.topAnchor.constraint(equalTo: mentionIdLabel.bottomAnchor, constant: 10),
            
            followingLabel.leadingAnchor.constraint(equalTo: followingCountLabel.trailingAnchor, constant: 3),
            followingLabel.topAnchor.constraint(equalTo: mentionIdLabel.bottomAnchor, constant: 10),
            
            followerCountLabel.leadingAnchor.constraint(equalTo: followingLabel.trailingAnchor, constant: 10),
            followerCountLabel.topAnchor.constraint(equalTo: mentionIdLabel.bottomAnchor, constant: 10),
            
            followerLabel.leadingAnchor.constraint(equalTo: followerCountLabel.trailingAnchor, constant: 3),
            followerLabel.topAnchor.constraint(equalTo: mentionIdLabel.bottomAnchor, constant: 10),
            
            profileButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            profileButton.topAnchor.constraint(equalTo: followerLabel.bottomAnchor, constant: 20),
            
            blueButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            blueButton.topAnchor.constraint(equalTo: profileButton.bottomAnchor, constant: 20),
            
            bookmarkButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            bookmarkButton.topAnchor.constraint(equalTo: blueButton.bottomAnchor, constant: 20),
            
            listButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            listButton.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor, constant: 20),
            
            spaceButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            spaceButton.topAnchor.constraint(equalTo: listButton.bottomAnchor, constant: 20),
            
            adsRevenueSharingButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            adsRevenueSharingButton.topAnchor.constraint(equalTo: spaceButton.bottomAnchor, constant: 20),
            
            dividerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            dividerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            dividerView.topAnchor.constraint(equalTo: adsRevenueSharingButton.bottomAnchor, constant: 20),
            dividerView.heightAnchor.constraint(equalToConstant: 0.5),
            
            settingsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            settingsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            settingsStackView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 20),
            
            settingsAndPrivacyStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            settingsAndPrivacyStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            settingsAndPrivacyStackView.topAnchor.constraint(equalTo: settingsStackView.bottomAnchor, constant: 15),
            settingsAndPrivacyStackView.heightAnchor.constraint(equalToConstant: 100),
            
            displayModeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            displayModeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30)
        ])
    }
}

import SwiftUI

fileprivate struct Preview: UIViewRepresentable {
    typealias UIViewType = ProfileView
    
    func makeUIView(context: Context) -> ProfileView {
        
        return ProfileView()
    }
    
    func updateUIView(_ uiView: ProfileView, context: Context) {
        
    }
}

@available(iOS 13.0.0, *)
struct ProfileViewPreview: PreviewProvider {
    static var previews: some View {
            Preview()
            .ignoresSafeArea(.all)
            .frame(width: 350, height: 700)
            .background(Color.black)
    }
}
