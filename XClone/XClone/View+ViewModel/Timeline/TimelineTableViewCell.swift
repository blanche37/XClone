//
//  TimelineTableViewCell.swift
//  XClone
//
//  Created by yun on 2023/08/02.
//

import UIKit

final class TimelineTableViewCell: UITableViewCell {
    let profileImageView = UIImageView()
    let nickNameLabel = UILabel()
    let verifiedSymbolImageView = UILabel()
    let tagNameLabel = UILabel()
    let dateLabel = UILabel()
    let menuButton = UIButton()
    let contentLabel = UILabel()
    let contentImageView = UIImageView()
    private let commentButton = UIButton()
    private let repostButton = UIButton()
    private let heartButton = UIButton()
    private let viewCountButton = UIButton()
    private let exportButton = UIButton()
    private lazy var  bottomStackView = UIStackView(arrangedSubviews: [commentButton, repostButton, heartButton, viewCountButton, exportButton])
    private lazy var constraintsWhenContentImageDoesntExist: [NSLayoutConstraint] = {
        return [contentLabel.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -10)]
    }()
    
    private lazy var constraintsWhenContentImageExist: [NSLayoutConstraint] = {
       return [
        contentLabel.bottomAnchor.constraint(equalTo: contentImageView.topAnchor, constant: -10),
        contentImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        contentImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        contentImageView.heightAnchor.constraint(equalTo: contentImageView.widthAnchor, multiplier: 1/2),
        contentImageView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -10)
       ]
    }()
    
    func setContentImageViewConstraints(isImageExist: Bool) {
        if isImageExist {
            NSLayoutConstraint.deactivate(constraintsWhenContentImageDoesntExist)
            NSLayoutConstraint.activate(constraintsWhenContentImageExist)
        } else {
            NSLayoutConstraint.deactivate(constraintsWhenContentImageExist)
            NSLayoutConstraint.activate(constraintsWhenContentImageDoesntExist)
        }
    }
    
    func configureCell(twit: Twit) -> Self {
        self.profileImageView.image = UIImage(named: twit.profileImage ?? "")
        self.nickNameLabel.text = twit.nickName
        self.contentLabel.text = twit.content
        self.tagNameLabel.text = twit.mentionId
        if twit.contentImage != nil {
            self.setContentImageViewConstraints(isImageExist: true)
            self.contentImageView.image = UIImage(named: twit.contentImage ?? "")
        } else {
            self.setContentImageViewConstraints(isImageExist: false)
        }

        return self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentImageView.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // TODO: Delete
        profileImageView.backgroundColor = .white
        nickNameLabel.text = "Elon Musk" // 삭제
        verifiedSymbolImageView.backgroundColor = .white
        tagNameLabel.text = "@Elon Musk" // 삭제
        tagNameLabel.textColor = .white
        dateLabel.text = "・3일"
        contentLabel.text = "I❤️Canada" // 삭제
        
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        nickNameLabel.textColor = .white
        nickNameLabel.font = .boldSystemFont(ofSize: 15)
        tagNameLabel.textColor = .gray
        tagNameLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .gray
        dateLabel.font = .systemFont(ofSize: 13)
        menuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        menuButton.tintColor = .gray
        contentLabel.textColor = .white
        contentLabel.font = .systemFont(ofSize: 13)
        contentLabel.numberOfLines = 0
        contentImageView.layer.cornerRadius = 10
        contentImageView.clipsToBounds = true
        contentImageView.contentMode = .scaleAspectFill
        commentButton.setImage(UIImage(systemName: "message"), for: .normal)
        repostButton.setImage(UIImage(systemName: "arrow.2.squarepath"), for: .normal)
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        viewCountButton.setImage(UIImage(systemName: "chart.bar.xaxis"), for: .normal)
        exportButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)

//        commentButton.addAction(UIAction { _ in
//            print("touched")
//        }, for: .touchUpInside)
//        menuButton = UIMenu
        let buttonArr = [commentButton, repostButton, heartButton, viewCountButton, exportButton]
        buttonArr.forEach {
            $0.tintColor = .gray
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .equalCentering
        
        [profileImageView, nickNameLabel, verifiedSymbolImageView, tagNameLabel, dateLabel, menuButton, contentLabel, contentImageView, bottomStackView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            
            nickNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nickNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            //            verifiedSymbolImageView.leadingAnchor.constraint(equalTo: nickNameLabel.trailingAnchor, constant: 5),
            //            verifiedSymbolImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 11),
            //            verifiedSymbolImageView.heightAnchor.constraint(equalToConstant: 15),
            //            verifiedSymbolImageView.widthAnchor.constraint(equalToConstant: 15),
            
            tagNameLabel.leadingAnchor.constraint(equalTo: nickNameLabel.trailingAnchor, constant: 5),
            tagNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 11),
            dateLabel.leadingAnchor.constraint(equalTo: tagNameLabel.trailingAnchor, constant: 5),
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 11),
            
            menuButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 11),
            menuButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            contentLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            contentLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 3),
            
            bottomStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            bottomStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            bottomStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            bottomStackView.heightAnchor.constraint(equalToConstant: 10),
            
            commentButton.heightAnchor.constraint(equalToConstant: 10),
            commentButton.widthAnchor.constraint(equalToConstant: 13),

            repostButton.heightAnchor.constraint(equalToConstant: 10),
            repostButton.widthAnchor.constraint(equalToConstant: 13),

            heartButton.heightAnchor.constraint(equalToConstant: 10),
            heartButton.widthAnchor.constraint(equalToConstant: 13),

            viewCountButton.heightAnchor.constraint(equalToConstant: 10),
            viewCountButton.widthAnchor.constraint(equalToConstant: 13),

            exportButton.heightAnchor.constraint(equalToConstant: 10),
            exportButton.widthAnchor.constraint(equalToConstant: 13)
        ])
        
        NSLayoutConstraint.activate(constraintsWhenContentImageDoesntExist)
    }
}

import SwiftUI

fileprivate struct Preview: UIViewRepresentable {
    typealias UIViewType = TimelineTableViewCell
    
    func makeUIView(context: Context) -> TimelineTableViewCell {
        return TimelineTableViewCell()
    }
    
    func updateUIView(_ uiView: TimelineTableViewCell, context: Context) {
        
    }
}

@available(iOS 13.0.0, *)
struct TimelineCellPreview: PreviewProvider {
    static var previews: some View {
        Preview()
            .ignoresSafeArea(.all)
            .background(Color.black)
            .frame(height: 100)
    }
}
