//
//  XTabBarView.swift
//  XClone
//
//  Created by yun on 2023/08/02.
//

import UIKit

final class TabBarView: UIVisualEffectView {
    private let itemCount: Int
    private let imageNames: [(String, String)]
    private let actions: [() -> Void]
    private let buttonStackView = UIStackView()
    private var buttons = [UIButton]()
    
    init?(itemCount: Int, imageNames: [(String, String)], actions: [() -> Void]) {
        if itemCount != imageNames.count || itemCount <= 0 {
            return nil
        }
        self.itemCount = itemCount
        self.imageNames = imageNames
        self.actions = actions
        let blurEffect = UIBlurEffect(style: .dark)
        super.init(effect: blurEffect)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .equalCentering
        self.tintColor = .white
        
        for index in 0..<itemCount {
            let button = UIButton()
            let (normal, selected) = imageNames[index]
            
            self.buttons.append(button)
            
            button.setImage(UIImage(systemName: normal), for: .normal)
            button.setImage(UIImage(systemName: selected), for: .selected)
            button.addAction(UIAction { [weak self] _ in
                self?.buttons.forEach {
                    $0.isSelected = false
                }
                button.isSelected = true
                self?.actions[index]()
            }, for: .touchUpInside) // TODO: 이거 분리 비효율적
            buttonStackView.addArrangedSubview(button)
        }
        
        buttons.first?.isSelected = true
        
        contentView.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
}

import SwiftUI

fileprivate struct Preview: UIViewRepresentable {
    typealias UIViewType = TabBarView

    func makeUIView(context: Context) -> TabBarView {
        return TabBarView(itemCount: 5, imageNames: [("house", "house.fill"),
                                                      ("magnifyingglass.circle", "magnifyingglass.circle.fill"),
                                                      ("person.2", "person.2.fill"),
                                                      ("bell", "bell.fill"),
                                                      ("envelope", "envelope.fill")], actions: [{ }, { }, { }, { }, { }])!
    }

    func updateUIView(_ uiView: TabBarView, context: Context) {

    }
}

@available(iOS 13.0.0, *)
struct XTabBarPreView: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            HStack {
                Spacer().frame(width:20)
                Preview()
                    .frame(width: .infinity, height: 100, alignment: .center)
                Spacer().frame(width:20)
            }
            .background(Color.black)
        }
    }
}
