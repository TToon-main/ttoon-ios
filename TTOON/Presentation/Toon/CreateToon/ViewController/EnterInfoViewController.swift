//
//  EnterInfoViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import UIKit

import RxCocoa
import RxSwift

class EnterInfoViewController: CreateToonBaseViewController {
    private let disposeBag = DisposeBag()
    
    private let enterInfoScrollView = EnterInfoScrollView()
    
    override func loadView() {
        view = enterInfoScrollView
    }
}
