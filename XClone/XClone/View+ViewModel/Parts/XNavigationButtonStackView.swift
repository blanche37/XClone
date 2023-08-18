//
//  XNavigationButton.swift
//  XClone
//
//  Created by yun on 2023/08/03.
//

import UIKit

final class XNavigationButtonStackView: UIStackView {
    private let buttonCount: Int
    private let buttonTitles: [String]
    private let buttonActions: [() -> Void]
    
    init?(buttonCount: Int, buttonTitles: [String], buttonActions: [() -> Void]) {
        
        if buttonCount <= 0
            || buttonCount != buttonTitles.count
            || buttonCount != buttonActions.count { return nil }
        
        self.buttonCount = buttonCount
        self.buttonTitles = buttonTitles
        self.buttonActions = buttonActions
        super.init(frame: .zero)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.axis = .horizontal
        self.distribution = .equalCentering
        
        for index in 0..<buttonCount {
            let buttonTitle = buttonTitles[index]
            let buttonAction = buttonActions[index]
            let button = XNavigationButton(title: buttonTitle, action: buttonAction)
            
            if index == 0 {
                button.selectButton()
            }
            
            button.addAction {
                self.arrangedSubviews.forEach {
                    guard let button = $0 as? XNavigationButton else {
                        return
                    }
                    button.deselectButton()
                }
                buttonAction()
                button.selectButton()
            }
            
            self.addArrangedSubview(button)
        }
    }
}

final class XNavigationButton: UIView {
    private let button = UIButton()
    private let statusView = UIView()
    private let title: String?
    
    init(title: String?, action: @escaping () -> Void) {
        self.title = title
        super.init(frame: .zero)
        setupViews()
        self.backgroundColor = .clear
        button.addAction(UIAction { _ in
            action()
        }, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAction(action: @escaping () -> Void) {
        button.addAction(UIAction { _ in
            action()
        }, for: .touchUpInside)
    }
    
    func selectButton() {
        button.isSelected = true
        statusView.backgroundColor = .systemBlue
    }
    
    func deselectButton() {
        button.isSelected = false
        statusView.backgroundColor = .clear
    }
    
    private func setupViews() {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.setTitleColor(.white, for: .selected)
                
        [button, statusView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let viewDictionary: [String: Any] = ["button": button, "status": statusView]
        var hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[button]|", metrics: nil, views: viewDictionary)
        hConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[status]|", metrics: nil, views: viewDictionary)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[button]-10-[status(5)]|", metrics: nil, views: viewDictionary)
        
        [hConstraints, vConstraints].forEach {
            self.addConstraints($0)
        }
    }
}
