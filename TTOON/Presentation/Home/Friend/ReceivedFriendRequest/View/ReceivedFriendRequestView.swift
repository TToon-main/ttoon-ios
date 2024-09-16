//
//  FriendRequestView.swift
//  TTOON
//
//  Created by 임승섭 on 9/2/24.
//

import UIKit

// 받은 요청 뷰
class ReceivedFriendRequestView: BaseView {
    // MARK: - UI Components
    let noRequestView = NoDataView("아직 친구 요청이 없어요")
    
    let receivedRequestListTableView = {
        let view = UITableView()
        view.register(ReceivedFriendRequestTableViewCell.self, forCellReuseIdentifier: ReceivedFriendRequestTableViewCell.description())
        view.rowHeight = 76
        view.allowsSelection = false
        return view
    }()
    
    override func addSubViews() {
        super.addSubViews()
        
        [receivedRequestListTableView, noRequestView].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        noRequestView.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        receivedRequestListTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension ReceivedFriendRequestView {
    func showNoDataView(show: Bool) {
        print("showNoFriendView : \(show)")
        self.noRequestView.isHidden = !show
    }
}
