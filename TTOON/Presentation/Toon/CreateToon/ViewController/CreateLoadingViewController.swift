//
//  CreateLoadingViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/24/24.
//

import UIKit

import RxSwift

class CreateLoadingViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let createLoadingView = CreateLoadingView()
    
    override func loadView() {
        view = createLoadingView
    }
    
    override func layouts() {
        createLoadingView.updateProgress(0.29)
    }
}
