//
//  ToonRepositoryProtocol.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 10/5/24.
//

import Foundation

import RxSwift

protocol ToonRepositoryProtocol {
    func getCharacters() -> Observable<Event<[GetCharacterResponseDTO]>>
    func deleteCharacter(dto: DeleteCharacterRequestDTO) -> Observable<Event<Bool>>
    func patchCharacter(dto: PatchCharacterRequestDTO) -> Observable<Event<CharacterResponseDTO>>
    func postCharacter(dto: PostCharacterRequestDTO) -> Observable<Event<CharacterResponseDTO>>
    func postToon(dto: PostToonRequestDTO) -> Observable<Event<PostToonResponseDTO>>
    func postSaveToon(dto: PostSaveToonRequestDTO) -> Observable<Event<Bool>>
}
