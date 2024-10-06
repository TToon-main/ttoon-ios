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
    func addCharacter(model: AddCharacter) -> Observable<Bool>
    func deleteCharacter(id: String) -> Observable<Bool>
}

class ToonUseCase: ToonUseCaseProtocol {
    let repo: ToonRepositoryProtocol
    
    init(repo: ToonRepositoryProtocol) {
        self.repo = repo
    }
    
    func characterList() -> Observable<CharacterList> {
        let request = repo.getCharacters()
            .share()
        
        let mainId = UserDefaultsManager.mainCharacterId
        
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
        
        return .merge(list, emptyList, invalid)
    }
    
    func addCharacter(model: AddCharacter) -> Observable<Bool> {
        let dto = model.toDTO()
        
        let request = repo.postCharacter(dto: dto)
            .share()
        
        let success = request.compactMap { $0.element }
            .filter { $0 }
    
        let error = request.compactMap { $0.error }
            .map { _ in false}
        
        return .merge(success, error)
    }
    
    func deleteCharacter(id: String) -> Observable<Bool> {
        let dto = DeleteCharacterRequestDTO(id: id)
        
        let request = repo.deleteCharacter(dto: dto)
            .share()
        
        let success = request.compactMap { $0.element }
            .filter { $0 }
    
        let error = request.compactMap { $0.error }
            .map { _ in false}

        return .merge(success, error)
    }
}

extension ToonUseCase {
    enum CharacterList {
        case valid(list: [Character])
        case invalid
        case empty
    }
}
