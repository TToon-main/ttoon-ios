//
//  SetNickNameRepositoryProtocol.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/8/24.
//

import Foundation

import RxSwift

protocol SetNickNameRepositoryProtocol {
    func postIsValidNickName(dto: PostIsValidNickNameRequestDTO) -> Observable<Event<Bool>>
}
