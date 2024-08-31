//
//  UIImageView+.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/25/24.
//

import UIKit

extension UIImageView {
    func load(url: URL?) {
        guard let url else { return } 
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}