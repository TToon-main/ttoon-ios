//
//  FriendListView.swift
//  TTOON
//
//  Created by 임승섭 on 8/17/24.
//

import UIKit

// 친구 목록 뷰
// - 데이터 없을 때 : "아직 추가된 친구가 없어요"
// - 데이터 있을 때 : 테이블뷰 (셀 - '친구 삭제' (FriendListTableViewCell)
class FriendListView: BaseView {
    // MARK: - UI Components
    let noFriendView = NoFriendView()
    
    let friendListTableView = {
        let view = UITableView()
        view.register(
            FriendListTableViewCell.self,
            forCellReuseIdentifier: FriendListTableViewCell.description()
        )
        view.rowHeight = 76
        view.allowsSelection = false
        return view
    }()
    
    override func addSubViews() {
        super.addSubViews()
        
        [noFriendView, friendListTableView].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        noFriendView.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        friendListTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
