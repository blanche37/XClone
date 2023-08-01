//
//  TimelineView.swift
//  XClone
//
//  Created by yun on 2023/08/01.
//

import UIKit

final class TimelineView: UIView {
    private let tableView = UITableView()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        tableView.backgroundColor = .black
        
        self.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDictionary: [String: Any] = ["table": tableView]
        
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[table]|", metrics: nil, views: viewDictionary)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[table]|", metrics: nil, views: viewDictionary)
        
        [hConstraints, vConstraints].forEach {
            addConstraints($0)
        }
        
    }
}
