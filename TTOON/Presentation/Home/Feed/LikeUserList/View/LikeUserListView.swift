//
//  LikeUserView.swift
//  TTOON
//
//  Created by 임승섭 on 10/28/24.
//

import SnapKit
import UIKit

class LikeUserListView: BaseView {
    // MARK: - UI Component
    let noLikesView = NoDataView("좋아요를 누른 사람이 없어요")
    
    let likeUserListTableView = {
        let view = UITableView()
        view.register(
            LikeUserListTableViewCell.self,
            forCellReuseIdentifier: LikeUserListTableViewCell.description()
        )
        view.rowHeight = 76
        view.allowsSelection = false
        return view
    }()
    
    override func addSubViews() {
        super.addSubViews()
        
        [likeUserListTableView, noLikesView].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        noLikesView.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        likeUserListTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

extension LikeUserListView {
    func showNoLikesView(show: Bool) {
        self.noLikesView.isHidden = !show
    }
}
