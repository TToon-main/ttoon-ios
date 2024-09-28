//
//  CommonError.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/28/24.
//

import Foundation

protocol CommonErrorProtocol: Error, RawRepresentable where RawValue == String {
    static var decoding: Self { get }
    static var unknown: Self { get }
}
