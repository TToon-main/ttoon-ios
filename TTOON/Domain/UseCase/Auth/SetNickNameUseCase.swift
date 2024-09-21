//
//  SetNickNameUseCase.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/8/24.
//

import Foundation

import RxSwift

protocol SetNickNameUseCaseProtocol {
    func isValidText(dto: PostIsValidNickNameRequestDTO) -> Observable<SetNickNameUseCase.TextFieldStatus>
    func truncateText(text: String) -> String
}

class SetNickNameUseCase: SetNickNameUseCaseProtocol {
    let setNickNameRepository: SetNickNameRepository
    
    enum TextFieldStatus {
        case duplicationNickname // 중복된 닉네임
        case unknownError // 알 수 없는 에러
        case validNickname // 사용 가능한 닉네임
        case readyToRequest // API 요청 전
    }
    
    // MARK: - init
    init(setNickNameRepository: SetNickNameRepository) {
        self.setNickNameRepository = setNickNameRepository
    }
    
    // MARK: - method
    
    func isValidText(dto: PostIsValidNickNameRequestDTO) -> Observable<TextFieldStatus> {
        let request = setNickNameRepository.postIsValidNickName(dto: dto)
            .share()
        
        let success = request
            .compactMap { $0.element }
            .map { $0 ? TextFieldStatus.validNickname : TextFieldStatus.duplicationNickname } 
        
        let fail = request
            .compactMap { $0.error }
            .map { _ in TextFieldStatus.unknownError }

        return Observable.merge(success, fail)
    }
    
    func truncateText(text: String) -> String {
        return ValidationManager.shared.truncateText(text)
    }
}
