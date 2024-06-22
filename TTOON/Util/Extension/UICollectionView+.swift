//
//  UICollectionView+.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import UIKit

extension UICollectionView {
    func registerCell<T: BaseCollectionViewCell>(cell: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.IDF)
    }
}
