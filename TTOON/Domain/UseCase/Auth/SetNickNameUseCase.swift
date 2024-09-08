//
//  SetNickNameUseCase.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/8/24.
//

import Foundation

import RxSwift

protocol SetNickNameUseCaseProtocol {
}

class SetNickNameUseCase: SetNickNameUseCaseProtocol {
    let splashRepository: SplashRepositoryProtocol
    
    // MARK: - init
    init(splashRepository: SplashRepositoryProtocol) {
        self.splashRepository = splashRepository
    }
    
    // MARK: - method
    
    func isValidText(text: String) -> Observable<TextFieldStatus> {
        return .just(.valid)
    }
    
    func truncateText(text: String) -> String {
        return ValidationManager.shared.truncateText(text)
    }
}
