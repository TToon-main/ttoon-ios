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
    private let refreshAttendance = PublishSubject<Void>()

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
        rx.viewWillAppear
            .map { _ in AttendanceReactor.Action.refreshAttendance}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        refreshAttendance
            .map { AttendanceReactor.Action.refreshAttendance }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        attendanceScrollView.rx.checkAttendanceButtonTap
            .map { AttendanceReactor.Action.checkAttendanceButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: AttendanceReactor) {
        reactor.state.map { $0.point }
            .bind(to: navigationBar.rx.point)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSelected }
            .bind(to: attendanceScrollView.rx.isAttendanceChecked)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.showInvalid }
            .bind(to: attendanceScrollView.rx.showInvalid)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isEnabledCheckAttendanceButton }
            .bind(to: attendanceScrollView.rx.isEnabledCheckAttendanceButton)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.showCompleteAlert }
            .bind(onNext: showCompleteAlert)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.showAlreadyDoneAlert }
            .bind(onNext: showAlreadyDoneAlert)
            .disposed(by: disposeBag)
    }
}

extension AttendanceViewController {
    private func showCompleteAlert(_ flag: Bool) {
        if flag {
            let today = todayString()
            TNAlert(self)
                .setTitle("\(today) 출석체크 완료!")
                .setSubTitle("보상으로 100포인트를 지급 받았어요.")
                .addConfirmAction("확인")
                .present()
            
            refreshAttendance.onNext(())
        }
    }
    
    private func showAlreadyDoneAlert(_ flag: Bool) {
        if flag {
            TNAlert(self)
                .setTitle("오늘 이미 출석체크 했습니다.")
                .setSubTitle("내일 만나요.")
                .addConfirmAction("확인")
                .present()
        }
    }
    
    private func todayString() -> String {
        return Date().toString(of: .onlyDay).uppercased()
    }
}
