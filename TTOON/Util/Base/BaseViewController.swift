//
//  BaseViewController.swift
//  TTOON
//
//  Created by 임승섭 on 4/5/24.
//

import UIKit

class BaseViewController: UIViewController {
    var height = UIScreen.main.bounds.height
    var width = UIScreen.main.bounds.width
    lazy var safeGuide = view.safeAreaLayoutGuide
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        layouts()
        configures()
    }
    
    func addSubViews() { }
    func layouts() { }
    func configures() { }
}
