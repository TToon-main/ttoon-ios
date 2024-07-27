//
//  CreateResultViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/24/24.
//

import UIKit

import RxSwift

class CreateResultViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let createResultView = CreateResultView()
    
    override func loadView() {
        view = createResultView
    }
}
