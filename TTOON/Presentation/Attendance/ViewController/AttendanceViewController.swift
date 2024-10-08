//
//  AttendanceViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/21/24.
//

import UIKit

import ReactorKit

class AttendanceViewController: BaseViewController {
    // MARK: - Properties
    var disposeBag = DisposeBag()

    // MARK: - UI Properties
    
    private let navigationBar = AttendanceNavigationBar()
    private let attendanceScrollView = AttendanceScrollView()
    
    // MARK: - Initializer
    
    init(attendanceReactor: AttendanceReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = attendanceReactor 
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life Cycle
    
    override func loadView() {
        view = attendanceScrollView
    }
    
    // MARK: - Configurations
    
    override func configures() {
        setCustomNavigationBar(navigationBar)
    }
}

extension AttendanceViewController: View {
    func bind(reactor: AttendanceReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: AttendanceReactor) {
    }
    
    func bindState(reactor: AttendanceReactor) {
    }
}
