//
//  BaseURL.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/6/24.
//

import Foundation

class BaseURL {
    static func fetchUrl() -> URL {
    #if DEV 
        return URL(string: "https://ttoon.site")! 
    #else
        return URL(string: "https://ttoon.kr")!
    #endif
    }
}
