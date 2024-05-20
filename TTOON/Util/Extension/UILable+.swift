//
//  UILable+.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/20/24.
//

import UIKit

extension UILabel {
    func makeSampleText(_ num: Int = 1) {
        let sample = (0..<num).reduce("가") { result, _ in
            result + "가"
        }
        
        self.text = sample
    }
}
