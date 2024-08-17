//
//  AddFriendView.swift
//  TTOON
//
//  Created by 임승섭 on 8/17/24.
//

import UIKit

class AddFriendView: BaseView {
    // MARK: - UI Components
    let noFriendView = NoFriendView()
    
    override func addSubViews() {
        super.addSubViews()
        
        [noFriendView].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        noFriendView.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
}
