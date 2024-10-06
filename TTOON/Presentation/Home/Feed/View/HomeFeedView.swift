//
//  HomeFeedView.swift
//  TTOON
//
//  Created by 임승섭 on 10/6/24.
//

import UIKit

class HomeFeedView: BaseView {
    let onlyMyFeedView = OnlyMyFeedToggleView()
    
    let feedTableView = {
        let view = UITableView()
        view.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.description())
        view.allowsSelection = false
        view.rowHeight = UITableView.automaticDimension
        view.backgroundColor = .grey01
        view.separatorStyle = .none
        return view
    }()
    
    override func addSubViews() {
        super.addSubViews()
        
        [onlyMyFeedView, feedTableView].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        feedTableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    override func configures() {
        super.configures()
        
        // Set header view
        onlyMyFeedView.frame = CGRect(x: 0, y: 0, width: width, height: 60)
        feedTableView.tableHeaderView = onlyMyFeedView
    }
}

extension HomeFeedView {
    func setSwitch(_ value: Bool) {
        onlyMyFeedView.onlyMyFeedSwitch.isOn = value
    }
}
