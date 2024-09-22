//
//  AttendanceUseCase.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/22/24.
//

import Foundation

protocol AttendanceUseCaseProtocol {
}

class AttendanceUseCase: AttendanceUseCaseProtocol {
    let repo: AttendanceRepositoryProtocol
    
    init(repo: AttendanceRepositoryProtocol) {
        self.repo = repo
    }
}
