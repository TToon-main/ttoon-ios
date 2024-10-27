//
//  UIImageView+.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/25/24.
//

import Kingfisher
import UIKit

extension UIImageView {
    func load(url: URL?, defaultImage: UIImage? = nil) {
        guard let url else { 
            DispatchQueue.main.async {
                self.image = defaultImage
            } 
            
            return
        } 
        
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
    
    func load(url: URL?, defaultImage: UIImage? = nil, completion: @escaping () -> Void) {
        guard let url else {
            DispatchQueue.main.async {
                self.image = defaultImage
            }
            
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        completion()
                    }
                }
            }
        }
    }
    
    func loadWithKF(url: URL?, defaultImage: UIImage? = nil, completion: ( () -> Void)? = nil) {
        self.kf.setImage(
            with: url,
            placeholder: defaultImage,
            options: [.scaleFactor(UIScreen.main.scale), .cacheOriginalImage]) { result  in
                completion?()
        }
    }
}
