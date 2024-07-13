//
//  CharacterPickerTableView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/13/24.
//

import UIKit

final class CharacterPickerTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        separatorStyle = .none
        backgroundColor = .clear
        rowHeight = 88
        register(CharacterPickerTableViewCell.self, forCellReuseIdentifier: CharacterPickerTableViewCell.IDF)
    }
}
