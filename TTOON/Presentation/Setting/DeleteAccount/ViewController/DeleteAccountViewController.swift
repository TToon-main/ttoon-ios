//
//  DeleteAccountViewController.swift
//  TTOON
//
//  Created by 임승섭 on 5/19/24.
//

import ReactorKit
import RxCocoa
import RxSwift
import UIKit

class DeleteAccountViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    private let mainView = DeleteAccountView()
    
    init(deleteAccountReactor: DeleteAccountReactor) {
        super.init(nibName: nil, bundle: nil)
        
        let reactor = DeleteAccountReactor()
        self.reactor = reactor
        bind(reactor: reactor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func loadView() {
        self.view = mainView
    }
    
    // 비즈니스 로직 정리
    // 1. 탈퇴 이유 bottom sheet에서 클릭 -> bottom sheet에서 클릭 -> label 변경 및 VM 저장 (직접 입력을 선택한 경우, 아래 텍스트뷰 hidden false)
    // 2. 탈퇴 이유 (직접 입력) 텍스트 -> 유효성 검증 -> countLabel 변경
    // 3. 버튼 클릭 -> 이메일 전송
    
    func bind(reactor: DeleteAccountReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: DeleteAccountReactor) {
        // bottom sheet 올라오면 진행
        mainView.reasonPickerView.clearButton.rx.tap
            .map {
                let a = DeleteAccountReason.allCases.randomElement()!
                
                return DeleteAccountReactor.Action.deleteReason(a)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.reasonTextView.rx.text.orEmpty
            .map { DeleteAccountReactor.Action.directInputText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.completeButton.rx.tap
            .map { DeleteAccountReactor.Action.completeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: DeleteAccountReactor) {
        reactor.state.map { $0.deleteReason }
            .map { value in
                if let value { return value.rawValue }
                else { return "탈퇴하시는 이유를 알려주세요" }
            }
            .distinctUntilChanged()
            .bind(to: mainView.reasonPickerView.textLabel.rx.text )
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.showTextView }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                owner.mainView.reasonTextView.isHidden = !value
                owner.mainView.reasonCountLabel.isHidden = !value
                
                if !value {
                    // 혹시나 카운트가 오바해서 이게 떠있을 때, 지워줘야 함
                    owner.mainView.reasonErrorSubtitleLabel.isHidden = true
                }
                
                // 이렇게 하면 안됨.... 일단 구현
                if value && owner.mainView.reasonTextView.text.count > 100 {
                    owner.mainView.reasonErrorSubtitleLabel.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.directInputTextValid }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                if value {
                    owner.mainView.reasonCountLabel.textColor = .grey05
                    owner.mainView.reasonErrorSubtitleLabel.isHidden = true
                } else {
                    owner.mainView.reasonCountLabel.textColor = .errorRed
                    owner.mainView.reasonErrorSubtitleLabel.textColor = .errorRed
                    owner.mainView.reasonErrorSubtitleLabel.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.directInputTextCount }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, cnt in
                owner.mainView.reasonCountLabel.text = "\(cnt)/100"
            }
            .disposed(by: disposeBag)
        
        
        // 버튼 활성화
        reactor.state.map { $0.buttonEnabled }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                owner.mainView.completeButton.backgroundColor = value ? .blue : .red
            }
            .disposed(by: disposeBag)
        
        
        // 누른 결과?
        
    }
}

enum DeleteAccountReason: String, CaseIterable {
    case serviceInconvenient = "서비스 이용이 불편해서"
    case notHelpfulForWriting = "일기 작성에 도움이 되지 않아서"
    case ineffectiveForDailyRecords = "꾸준한 일상 기록에 효과가 없어서"
    case unsatisfactoryImages = "생성되는 이미지가 마음에 들지 않아서"
    case switchingToOtherService = "타 서비스로 이동"
    case directInput = "직접 입력"
}
