//
//  SetNickNameViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/8/24.
//

import UIKit

import RxSwift

class SetNickNameViewController: BaseViewController {
    private let setNickNameView = SetNickNameView()
    
    override func loadView() {
        view = setNickNameView
    }
}
