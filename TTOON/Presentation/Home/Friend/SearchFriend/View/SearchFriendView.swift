//
//  SearchFriendView.swift
//  TTOON
//
//  Created by 임승섭 on 9/4/24.
//

import UIKit

class SearchFriendView: BaseView {
    // MARK: - UI Component
    let searchBar = {
        let view = UISearchBar()
        view.backgroundImage = UIImage()    // 서치바 테두리 없애기 위함
        view.placeholder = "친구를 검색하세요"
//        view.showsCancelButton = true
//        view.setShowsCancelButton(true, animated: true)
        return view
    }()
    
    let noDataView = NoDataView("검색 결과가 없어요")
    
    let userTableView = {
        let view = UITableView()
        view.register(UserListTableViewCell.self, forCellReuseIdentifier: UserListTableViewCell.description())
        view.rowHeight = 76
        view.allowsSelection = false
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    // MARK: - Layout
    override func addSubViews() {
        super.addSubViews()
        
        [searchBar, userTableView, noDataView].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        userTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        noDataView.snp.makeConstraints { make in
            make.center.equalTo(userTableView)
        }
    }
}

extension SearchFriendView {
    func showNoDataView(show: Bool) {
        self.noDataView.isHidden = !show
    }
}
