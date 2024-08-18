//
//  SplashRepositoryProtocol.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/18/24.
//

import Foundation

protocol SplashRepositoryProtocol {
    func fetchNetworkStatus() -> Bool
    func fetchMinVersion() -> String
}
