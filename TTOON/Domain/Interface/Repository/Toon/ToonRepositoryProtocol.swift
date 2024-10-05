//
//  ToonRepositoryProtocol.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 10/5/24.
//

import Foundation

import RxSwift

protocol ToonRepositoryProtocol {
    func getCharacters() -> Observable<Event<GetCharacterResponseDTO>>
    func deleteCharacter(dto: DeleteCharacterRequestDTO) -> Observable<Event<Bool>>
    func patchCharacter(dto: PatchCharacterRequestDTO) -> Observable<Event<Bool>>
    func postCharacter(dto: PostCharacterRequestDTO) -> Observable<Event<Bool>>
}
