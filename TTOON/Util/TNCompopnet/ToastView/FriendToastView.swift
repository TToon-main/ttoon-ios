//
//  FriendToastView.swift
//  TTOON
//
//  Created by 임승섭 on 11/23/24.
//

import SnapKit
import UIKit


// width padding : 16. height : 56
class FriendToastView: BaseView {
    enum Status {
        case accept
        case reject
    }
    
    // UI Component
    let expressionImageView = {
        let view = UIImageView()
        view.image = .friendHappy
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let messageLabel = {
        let view = UILabel()
        view.text = "‘티라미수케이크'님의 친구요청을 수락했어요."
        view.font = .body16m
        view.textColor = .white
        return view
    }()
    
    // Layout
    override func addSubViews() {
        super.addSubViews()
        
        [expressionImageView, messageLabel].forEach{
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        expressionImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(expressionImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    // Setting
    override func configures() {
        super.configures()
        
        self.isHidden = true
        
        backgroundColor = UIColor(hexString: "#2B2D36")?.withAlphaComponent(0.7)
        layer.cornerRadius = 28
        clipsToBounds = true
    }
    
    func setUI(_ status: FriendToastView.Status, nickname: String) {
        let nicknameStr = truncateStr(nickname, maxLength: 8)

        switch status {
        case .accept:
            self.expressionImageView.image = .friendHappy
            self.messageLabel.text = "‘\(nicknameStr)'님의 친구요청을 수락했어요."
            
        case .reject:
            self.expressionImageView.image = .friendSad
            self.messageLabel.text = "‘\(nicknameStr)'님의 친구요청을 거절했어요."
        }
    }
}


extension FriendToastView {
    // 닉네임 문자열이 길어지면 뒷부분은 ...으로 변경
    private func truncateStr(_ str: String, maxLength: Int) -> String {
        // 문자열의 길이가 maxLength 넘는지 체크
        guard str.count >= maxLength else { return str }
        
        // 문자열의 시작부터 maxLength-1번째 인덱스까지
        let index = str.index(str.startIndex, offsetBy: maxLength-1)
        let truncated = String(str[..<index])
        
        // "..." 추가
        return truncated + "..."
    }
}
