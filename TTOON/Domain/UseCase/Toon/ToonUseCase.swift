//
//  ToonUseCase.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 10/5/24.
//

import Foundation

import RxSwift

protocol ToonUseCaseProtocol {
    func characterList() -> Observable<ToonUseCase.CharacterList>
}

class ToonUseCase: ToonUseCaseProtocol {
    let repo: ToonRepositoryProtocol
    
    init(repo: ToonRepositoryProtocol) {
        self.repo = repo
    }
    
    func characterList() -> Observable<CharacterList> {
        let request = repo.getCharacters()
            .share()
        
        let mainId = KeychainStorage.shared.mainCharacterId
        
        let success = request.compactMap { $0.element }
            .share()
        
        let list = success
            .map { $0.map { $0.toDomain(mainId: mainId) } }
            .map { CharacterList.valid(list: $0)}
        
        let emptyList = success
            .filter(\.isEmpty)
            .map { _ in CharacterList.empty}
        
        let invalid = request.compactMap { $0.error }
            .map { _ in CharacterList.invalid}
        
        return Observable.merge(list, emptyList, invalid)
    }
}

extension ToonUseCase {
    enum CharacterList {
        case valid(list: [Character])
        case invalid
        case empty
    }
}
