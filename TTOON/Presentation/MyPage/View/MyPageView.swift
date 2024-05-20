//
//  MyPageView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/19/24.
//

import UIKit

final class MyPageView: BaseView {
    lazy var profileSummaryView = {
        let view = ProfileSummaryView()
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(profileSummaryView)
    }
    
    override func layouts() {
        profileSummaryView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(110)
        }
    }
}
