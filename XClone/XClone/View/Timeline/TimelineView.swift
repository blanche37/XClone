//
//  TimelineView.swift
//  XClone
//
//  Created by yun on 2023/08/01.
//

import UIKit

final class TimelineView: UIView {
    private let scrollView = UIScrollView()
    private let tableView = UITableView()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(scrollView)
        scrollView.addSubview(tableView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDictionary: [String: Any] = ["scroll": scrollView, "table": tableView]
        
        var hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[scroll]|", metrics: nil, views: viewDictionary)
        var vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[scroll]|", metrics: nil, views: viewDictionary)
        
        [hConstraints, vConstraints].forEach {
            addConstraints($0)
        }
        
    }
}
