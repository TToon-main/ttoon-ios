//
//  MyPageViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/19/24.
//

import UIKit

final class MyPageViewController: BaseViewController {
    let myPageView = MyPageView()
    
    override func loadView() {
        view = myPageView
    }
}
