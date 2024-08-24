//
//  FriendListPopUpBottomSheetViewController.swift
//  TTOON
//
//  Created by 임승섭 on 8/23/24.
//

import UIKit

class FriendListPopUpBottomSheetViewController: BaseViewController {
    let bottomSheetView = FriendListPopUpBottomSheetView(
        title: "‘발랄한 고양이'님과\n친구를 끊으시겠어요?",
        subTitle: "친구를 추가하면 친구와 서로의 기록을\n살펴보고 반응해줄 수 있어요",
        image: TNImage.highFive_color!,
        confirmButtonTitle: "하이",
        cancelButtonTitle: nil
    )
    
    override func addSubViews() {
        super.addSubViews()
        
        view.addSubview(bottomSheetView)
    }
    
    override func layouts() {
        super.layouts()
        
        bottomSheetView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-36)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
