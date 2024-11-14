//
//  ToonRepository.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 10/5/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

class ToonRepository: ToonRepositoryProtocol {
    private let provider = APIProvider<ToonAPI>()
    
    func getCharacters() -> Observable<Event<[GetCharacterResponseDTO]>> {
        return provider.log.rx.request(.getCharacters)
            .mapData(responseType: [GetCharacterResponseDTO].self,
                     errorType: GetCharactersError.self)
    }
        
    func deleteCharacter(dto: DeleteCharacterRequestDTO) -> Observable<Event<Bool>> {
        return provider.log.rx.request(.deleteCharacter(dto: dto))
            .mapIsSuccess(errorType: DeleteCharacterError.self)
    }
    
    func patchCharacter(dto: PatchCharacterRequestDTO) -> Observable<Event<CharacterResponseDTO>> {
        return provider.log.rx.request(.patchCharacter(dto: dto))
            .mapData(responseType: CharacterResponseDTO.self,
                     errorType: PatchCharacterError.self)
    }
    
    func postCharacter(dto: PostCharacterRequestDTO) -> Observable<Event<CharacterResponseDTO>> {
        return provider.log.rx.request(.postCharacter(dto: dto))
            .mapData(responseType: CharacterResponseDTO.self,
                     errorType: PostCharacterError.self)
    }
    
    func postToon(dto: PostToonRequestDTO) -> Observable<Event<PostToonResponseDTO>> {
        return provider.toon.rx.request(.postToon(dto: dto))
            .mapData(responseType: PostToonResponseDTO.self,
                     errorType: PostToonError.self)
    }
    
    func postSaveToon(dto: PostSaveToonRequestDTO) -> Observable<Event<Bool>> {
        return provider.log.rx.request(.postSaveToon(dto: dto))
            .mapIsSuccess(errorType: PostToonError.self)
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
    
    enum PostToonError: String, CommonErrorProtocol {
        case unknown
        case decoding
    }
}
