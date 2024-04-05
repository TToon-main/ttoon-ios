//
//  BaseViewController.swift
//  TTOON
//
//  Created by 임승섭 on 4/5/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setConstraints()
        setting()
    }
    
    func setConfigure() { }
    func setConstraints() { }
    func setting() { }
}
