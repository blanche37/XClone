//
//  SearchView.swift
//  XClone
//
//  Created by yun on 2023/08/08.
//

import UIKit

final class SearchView: UITextField {
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "magnifyingglass")
        let attachmentString = NSAttributedString(attachment: attachment)
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        let placeholderString = NSAttributedString(string: " 검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        let placeholder = NSMutableAttributedString()
        placeholder.append(attachmentString)
        placeholder.append(placeholderString)

        self.attributedPlaceholder = placeholder
        self.backgroundColor = .gray
        self.placeholder = "검색"
        self.layer.cornerRadius = 10
       
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 280).isActive = true
    }
}

import SwiftUI

fileprivate struct Preview: UIViewRepresentable {
    typealias UIViewType = SearchView
    
    func makeUIView(context: Context) -> SearchView {
        
        return SearchView()
    }
    
    func updateUIView(_ uiView: SearchView, context: Context) {
        
    }
}

@available(iOS 13.0.0, *)
struct SearchViewPreview: PreviewProvider {
    static var previews: some View {
            Preview()
            .ignoresSafeArea(.all)
            .frame(height: 50)
            .background(Color.black)
    }
}
