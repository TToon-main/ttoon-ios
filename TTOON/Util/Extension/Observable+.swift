//
//  Observable+.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/28/24.
//

import Foundation

import RxSwift

extension Observable {
    func mapError<T: CommonErrorProtocol>(_ type: T.Type) -> Observable<T> {
        return self.map { ($0 as? T) ?? .unknown }
    }
}
