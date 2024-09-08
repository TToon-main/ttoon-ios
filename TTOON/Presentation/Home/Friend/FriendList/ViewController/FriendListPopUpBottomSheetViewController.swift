//
//  FriendListPopUpBottomSheetViewController.swift
//  TTOON
//
//  Created by 임승섭 on 8/23/24.
//

import UIKit

class FriendListPopUpBottomSheetViewController: BaseViewController {
    var bottomSheetView = FriendListPopUpBottomSheetView(
        title: "",
        subTitle: "",
        image: TNImage.highFive_color!,
        confirmButtonTitle: "",
        cancelButtonTitle: nil
    )
    
    init(
        title: String,
        subTitle: String,
        image: UIImage,
        confirmButtonTitle: String,
        cancelButtonTitle: String?
    ) {
        super.init(nibName: nil, bundle: nil)
        
        self.bottomSheetView = FriendListPopUpBottomSheetView(
            title: title,
            subTitle: subTitle,
            image: image,
            confirmButtonTitle: confirmButtonTitle,
            cancelButtonTitle: cancelButtonTitle
        )
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
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
