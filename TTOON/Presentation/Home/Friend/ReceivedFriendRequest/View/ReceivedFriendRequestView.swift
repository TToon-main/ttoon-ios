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
    
    let toastView = {
        let view = FriendToastView()
        return view
    }()
    
    
    override func addSubViews() {
        super.addSubViews()
        
        [receivedRequestListTableView, noRequestView, toastView].forEach {
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
        
        toastView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(48)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
    }
}

extension ReceivedFriendRequestView {
    func showNoDataView(show: Bool) {
        self.noRequestView.isHidden = !show
    }
    
    func showToastView(type: FriendToastView.Status, nickname: String) {
        toastView.setUI(type, nickname: nickname)
        
        // 초기 상태 (숨김)
        toastView.alpha = 0
        toastView.isHidden = false
        
        // 나타나는 애니메이션
        UIView.animate(withDuration: 0.3, animations: {
            self.toastView.alpha = 1
        }) { _ in
            // 3초 후 사라지는 애니메이션
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.toastView.alpha = 0
                }) { _ in
                    self.toastView.isHidden = true
                }
            }
        }
    }
}
