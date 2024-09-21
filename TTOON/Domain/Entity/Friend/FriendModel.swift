//
//  FriendModel.swift
//  TTOON
//
//  Created by 임승섭 on 9/8/24.
//

import Foundation

// 공통
struct UserInfoModel {
    let friendId: Int
    let profileUrl: String?
    let nickname: String
}

struct UserListRequestModel {
    let searchStr: String
    let page: Int
}
struct SearchedUserInfoModel {
    let userInfo: UserInfoModel
    var status: SearchedUserStatus
    
    enum SearchedUserStatus: String {
        case accept = "ACCEPT"
        case waiting = "WAITING"
        case nothing = "NOTHING"
        case asking = "ASKING"
    }
}
