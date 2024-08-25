//
//  MyPageChangeLangViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/25/24.
//

import Foundation
import UIKit

class MyPageChangeLangViewController: BaseViewController {
    // MARK: - Properties
    private lazy var languageDataSource = ["Eng", "한국어"]
    
    // MARK: - UI Properties
    private let myPageChangeLangView = MyPageChangeLangView()
    
    // MARK: - LifeCycles
    override func loadView() {
        view = myPageChangeLangView
    }
    
    // MARK: - Configures
    override func configures() {
        setUpTableView()
    }
    
    private func setUpTableView() {
        myPageChangeLangView.contentTableView.dataSource = self
        myPageChangeLangView.contentTableView.delegate = self
    }
}

extension MyPageChangeLangViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        languageDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TNSheetCell.IDF, for: indexPath) as? TNSheetCell else {
            return UITableViewCell()
        }
        
        guard let languageCode = Locale.current.language.languageCode?.identifier else { return UITableViewCell() }
        
        var selectedIndex: IndexPath
    
        if languageCode == "ko" {
            selectedIndex = IndexPath(row: 1, section: 0)
        } else {
            selectedIndex = IndexPath(row: 0, section: 0)
        }
        
        if selectedIndex == indexPath {
            cell.isChecked.toggle()
        }

        cell.titleLabel.text = languageDataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: indexPath.section)) as? TNSheetCell {
                cell.isChecked = false
            }
        }
        
        if let selectedCell = tableView.cellForRow(at: indexPath) as? TNSheetCell {
            selectedCell.isChecked.toggle()
        }
        
        moveToSetting()
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
