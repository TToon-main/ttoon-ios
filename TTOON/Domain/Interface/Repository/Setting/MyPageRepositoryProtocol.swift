//
//  MyPageRepositoryProtocol.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/25/24.
//

import Foundation

import RxSwift

protocol MyPageRepositoryProtocol {
    func getUserInfo() -> Observable<UserInfoResponseDTO>
}
