//
//  CommunityView.swift
//  XClone
//
//  Created by yun on 2023/08/03.
//

import UIKit

final class CommunityTableViewCell: UITableViewCell {
    private(set) var communityImageView = UIImageView()
    private(set) var communityTitleLabel = UILabel()
    private(set) var memberCountLabel = UILabel()
    
    override func prepareForReuse() {
        communityImageView.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(community: Community) -> Self {
        self.communityTitleLabel.text = community.communityTitle
        self.communityImageView.image = UIImage(named: community.communityImage)
        self.memberCountLabel.text = "멤버 \(community.communityMemberCount)명"
        return self
    }
    
    private func setupViews() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        communityTitleLabel.text = "Taylor Swift"
        memberCountLabel.text = "멤버 1.1만명"
        
        communityImageView.backgroundColor = .white
        communityImageView.layer.cornerRadius = 15
        communityImageView.clipsToBounds = true
        
        communityTitleLabel.textColor = .white
        communityTitleLabel.font = .boldSystemFont(ofSize: 20)
        
        memberCountLabel.textColor = .gray
        
        [communityImageView, communityTitleLabel, memberCountLabel].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            communityImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            communityImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            communityImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            communityImageView.heightAnchor.constraint(equalToConstant: 100),
            communityImageView.widthAnchor.constraint(equalToConstant: 100),
            
            communityTitleLabel.leadingAnchor.constraint(equalTo: communityImageView.trailingAnchor, constant: 10),
            communityTitleLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            
            memberCountLabel.leadingAnchor.constraint(equalTo: communityImageView.trailingAnchor, constant: 10),
            memberCountLabel.topAnchor.constraint(equalTo: self.centerYAnchor)
            
            
        ])
    }
}

import SwiftUI

fileprivate struct Preview: UIViewRepresentable {
    typealias UIViewType = CommunityTableViewCell
    
    func makeUIView(context: Context) -> CommunityTableViewCell {
        
        return CommunityTableViewCell()
    }
    
    func updateUIView(_ uiView: CommunityTableViewCell, context: Context) {
        
    }
}

@available(iOS 13.0.0, *)
struct CommunityTableViewCellPreview: PreviewProvider {
    static var previews: some View {
        Preview()
            .ignoresSafeArea(.all)
            .frame(width: 350, height: 120)
            .background(Color.black)
    }
}
