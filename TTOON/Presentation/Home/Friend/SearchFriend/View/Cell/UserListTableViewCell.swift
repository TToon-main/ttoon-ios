//
//  UserListTableViewCell.swift
//  TTOON
//
//  Created by 임승섭 on 8/24/24.
//

import RxSwift
import UIKit

// 이미지, 닉네임, 버튼('친구 신청하기', '친구 신청완료')
class UserListTableViewCell: BaseTableViewCell {
    var disposeBag = DisposeBag()
    let profileInfoView = TableViewProfileInfoView()
    
    let requestFriendButton = UserListTableViewButton()
    
    override func addSubViews() {
        super.addSubViews()
        
        [profileInfoView, requestFriendButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        requestFriendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
//            make.width.equalTo(108)
            make.height.equalTo(36)
        }
        
        profileInfoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(120)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func setDesign(_ model: UserInfoModel) {
        self.profileInfoView.setDesign(model)
    }
}




/* ===== 내 친구 목록 화면의 셀에 나타나는 버튼 정의 ===== */
// 친구 신청하기, 친구 신청완료, (친구), ...
enum UserListTableViewRequestButtonType {
    case deleteFriend   // "친구 삭제"
    
    case sendRequest    // "친구 신청"
    case sentRequest    // "요청됨"
    case alreadyFriend  // "나의 친구"
    
    case accept // 수락
    case reject // 거절
}
class UserListTableViewButton: UIButton {
    var type: UserListTableViewRequestButtonType = .sendRequest {
        didSet {
            setTypeUI(type)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUI() {
        layer.cornerRadius = 8
        titleLabel?.font = .body14m
    }
    
    private func setTypeUI(_ type: UserListTableViewRequestButtonType) {
        switch type {
        // 1. 친구 목록 Cell
        case .deleteFriend: // 친구 삭제
            backgroundColor = .tnOrangeOff
            setTitleColor(.tnOrange, for: .normal)
            setTitle("친구 삭제", for: .normal)
            isEnabled = true
        
            
        // 2. 친구 요청 Cell
        case .sendRequest:  // 친구 요청하기
            backgroundColor = .tnOrange
            setTitleColor(.white, for: .normal)
            setTitle("친구 신청", for: .normal)
            isEnabled = true
            self.snp.makeConstraints { make in
                make.width.equalTo(84)
            }
            
        case .sentRequest:  // 친구 요청 완료
            backgroundColor = .grey02
            setTitleColor(.grey08, for: .normal)
            setTitle("요청됨", for: .normal)
            isEnabled = false
            self.snp.makeConstraints { make in
                make.width.equalTo(69)
            }
            
        case .alreadyFriend: // 나의 친구
            backgroundColor = .grey02
            setTitleColor(.grey08, for: .normal)
            setTitle("나의 친구", for: .normal)
            isEnabled = false
            self.snp.makeConstraints { make in
                make.width.equalTo(84)
            }
            
            
            
        // 3. 받은 요청 Cell
        case .accept:
            backgroundColor = .tnOrangeOff
            setTitleColor(.tnOrange, for: .normal)
            setTitle("수락", for: .normal)
            isEnabled = true
            
        case .reject:
            backgroundColor = .grey01
            setTitleColor(.grey06, for: .normal)
            setTitle("거절", for: .normal)
            isEnabled = true
        }
    }
}
