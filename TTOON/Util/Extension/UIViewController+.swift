//
//  UIViewController+.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/21/24.
//

import UIKit

extension UIViewController: IDF {
    static var IDF: String {
        return String(describing: self)
    }
}
