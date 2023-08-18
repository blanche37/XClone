//
//  TimelineView.swift
//  XClone
//
//  Created by yun on 2023/08/01.
//

import UIKit
import Combine
import CombineCocoa

final class TimelineView: UIView {
    private typealias DataSource = UITableViewDiffableDataSource<Section, Twit>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Twit>
    
    enum Section {
        case standard
    }
    
    private(set) var tableView = UITableView()
    private let viewModel: TimelineViewModelProtocol
    private lazy var dataSource = configureDataSource()
    
    init(viewModel: TimelineViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        tableView.register(TimelineTableViewCell.self, forCellReuseIdentifier: "TimelineCell")
        setupViews()
    }
    
    private func createSnapshot(twit: [Twit]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.standard])
        snapshot.appendItems(twit)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureDataSource() -> DataSource {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell", for: indexPath) as? TimelineTableViewCell
            return cell?.configureCell(twit: itemIdentifier)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        tableView.backgroundColor = .black
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
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

import SwiftUI

fileprivate struct Preview: UIViewRepresentable {
    typealias UIViewType = TimelineView
    
    func makeUIView(context: Context) -> TimelineView {
        
        return TimelineView(viewModel: TimelineViewModel())
    }
    
    func updateUIView(_ uiView: TimelineView, context: Context) {
        
    }
}

@available(iOS 13.0.0, *)
struct TimelineViewPreview: PreviewProvider {
    static var previews: some View {
            Preview()
            .ignoresSafeArea(.all)
    }
}

