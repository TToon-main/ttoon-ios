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
    
    lazy var underLineView = {
        let view = UnderLineView()
        
        return view
    }()
    
    lazy var myPageTableView = {
        let view = MyPageTableView(frame: .zero, style: .grouped)
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(profileSummaryView)
        addSubview(underLineView)
        addSubview(myPageTableView)
    }
    
    override func layouts() {
        profileSummaryView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(110)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(profileSummaryView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        myPageTableView.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
