//
//  ToonRepository.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 10/5/24.
//

import Foundation

import RxMoya
import RxSwift

class ToonRepository: ToonRepositoryProtocol {
    private let provider = APIProvider<ToonAPI>()
    
    func getCharacters() -> Observable<Event<GetCharacterResponseDTO>> {
        return provider.log.rx.request(.getCharacters)
            .mapData(responseType: GetCharacterResponseDTO.self,
                     errorType: GetCharactersError.self)
    }
    
    func deleteCharacter(dto: DeleteCharacterRequestDTO) -> Observable<Event<Bool>> {
        return provider.log.rx.request(.deleteCharacter(dto: dto))
            .mapIsSuccess(errorType: DeleteCharacterError.self)
    }
    
    func patchCharacter(dto: PatchCharacterRequestDTO) -> Observable<Event<Bool>> {
        return provider.log.rx.request(.patchCharacter(dto: dto))
            .mapIsSuccess(errorType: PatchCharacterError.self)
    }
    
    func postCharacter(dto: PostCharacterRequestDTO) -> Observable<Event<Bool>> {
        return provider.log.rx.request(.postCharacter(dto: dto))
            .mapIsSuccess(errorType: PostCharacterError.self)
    }
}

extension ToonRepository {
    enum GetCharactersError: String, CommonErrorProtocol {
        case unknown
        case decoding
    }
    
    enum DeleteCharacterError: String, CommonErrorProtocol {
        case unknown
        case decoding
    }
    
    enum PatchCharacterError: String, CommonErrorProtocol {
        case unknown
        case decoding
    }
    
    enum PostCharacterError: String, CommonErrorProtocol {
        case unknown
        case decoding
    }
}
