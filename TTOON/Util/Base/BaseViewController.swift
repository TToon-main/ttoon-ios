//
//  BaseViewController.swift
//  TTOON
//
//  Created by 임승섭 on 4/5/24.
//

import UIKit

class BaseViewController: UIViewController {
    lazy var safeGuide = view.safeAreaLayoutGuide
    lazy var width = UIScreen.main.bounds.width
    lazy var height = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        layouts()
        bind()
        configures()
    }
    
    func addSubViews() { }
    func layouts() { }
    func bind() { }
    func configures() { }
}
