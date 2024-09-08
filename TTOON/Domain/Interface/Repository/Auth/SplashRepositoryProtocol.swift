//
//  SplashRepositoryProtocol.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/18/24.
//

import Foundation

import RxSwift

protocol SplashRepositoryProtocol {
    func fetchNetworkStatus() -> Bool
    func fetchMinVersion() -> Observable<Event<String>>
}
