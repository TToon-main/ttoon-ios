//
//  FriendListView.swift
//  TTOON
//
//  Created by 임승섭 on 8/17/24.
//

import UIKit

class FriendListView: BaseView {
    // MARK: - UI Components
    let noFriendView = NoFriendView()
    
    /* ===== Sample ===== */
    let button1 = {
        let view = UIButton()
        view.backgroundColor = .lightGray
        view.setTitle("팝업 버튼 1", for: .normal)
        return view
    }()
    let button2 = {
        let view = UIButton()
        view.backgroundColor = .lightGray
        view.setTitle("팝업 버튼 2", for: .normal)
        return view
    }()
    /* ================== */
    
    override func addSubViews() {
        super.addSubViews()
        
        [noFriendView].forEach {
            self.addSubview($0)
        }
        
        
        
        /* ===== Sample ===== */
        [button1, button2].forEach {
            self.addSubview($0)
        }
        /* ================== */
    }
    
    override func layouts() {
        super.layouts()
        
        noFriendView.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        
        
        /* ===== Sample ===== */
        button1.snp.makeConstraints { make in
            make.top.equalTo(self).inset(150)
            make.leading.equalTo(self).inset(16)
            make.width.equalTo(120)
            make.height.equalTo(80)
        }
        button2.snp.makeConstraints { make in
            make.top.equalTo(self).inset(150)
            make.trailing.equalTo(self).inset(16)
            make.width.equalTo(120)
            make.height.equalTo(80)
        }
        /* ================== */
    }
}


/* ===== Sample ===== */
/* ================== */
