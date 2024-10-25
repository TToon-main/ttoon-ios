//
//  ContactUsViewController.swift
//  TTOON
//
//  Created by 임승섭 on 5/19/24.
//

import ReactorKit
import RxCocoa
import RxSwift
import UIKit


class ContactUsViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    let mainView = ContactUsView()
    
    // MARK: - Init
    init(contactUsReactor: ContactUsReactor) {
        super.init(nibName: nil, bundle: nil)
        
        
        let reactor = ContactUsReactor()
        self.reactor = reactor
//        bind(reactor: reactor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        setNavigation()
    }
    
    func bind(reactor: ContactUsReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: ContactUsReactor) {
        mainView.emailTextField.rx.text.orEmpty
            .map { ContactUsReactor.Action.emailText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
            
        // 여긴 따로 액션 없이, 바텀시트 띄워주는 로직만 실행
        mainView.categoryPickerView.clearButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = CategoryBottomSheetViewController(self.reactor!)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.contentTextView.rx.text.orEmpty
            .map { ContactUsReactor.Action.contentText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.completeButton.rx.tap
            .map { ContactUsReactor.Action.completeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: ContactUsReactor) {
        reactor.state.map { $0.isEmailValid }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                owner.mainView.emailSubtitleLabel.update(value, enabledText: "문의에 대한 답변을 이메일로 보내드려요", disabledText: "올바른 이메일 형식을 입력해주세요")
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.category }
            .map { value in
                if let value { return value.description }
                else { return "카테고리를 선택해주세요" }
            }
            .distinctUntilChanged()
            .bind(to: mainView.categoryPickerView.textLabel.rx.text )
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isContentValid }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                if value {
                    owner.mainView.contentCountLabel.textColor = .grey05
                    owner.mainView.contentErrorSubtitleLabel.isHidden = true
                } else {
                    owner.mainView.contentCountLabel.textColor = .errorRed
                    owner.mainView.contentErrorSubtitleLabel.textColor = .errorRed
                    owner.mainView.contentErrorSubtitleLabel.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.contentCount }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, cnt in
                owner.mainView.contentCountLabel.text = "\(cnt)/200"
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.buttonEnabled }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                owner.mainView.completeButton.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        
        reactor.state.map { $0.completeResult }
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, result in
                if let result {
                    if case .success(let value) = result,
                    value == true {
                        TNAlert(self)
                            .setTitle("문의하기가 완료되었습니다")
                            .setSubTitle("1:1 문의에 대한 답변은 이메일로 보내드려요")
                            .addConfirmAction("확인", action: nil) // 화면 전환 시켜주기
                            .present()
                    } else {
                        TNAlert(self)
                            .setTitle("문의하기에 실패하였습니다")
                            .setSubTitle("잠시 후 다시 시도해주세요")
                            .addConfirmAction("확인", action: nil) // 따로 action 없어도 된다
                            .present()
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    
    // 비즈니스 로직 정리
    // 1. 이메일 텍스트 -> 유효성 검증 -> subtitleLabel 변경
    // 2. 카테고리 버튼 클릭 -> bottom sheet에서 클릭 -> label 변경 및 VM 저장
    // 3. 문의내용 텍스트 -> 유효성 검증 -> countLabel, 오류 레이블 색상 및 보여주기
    //  문의내용 텍스트 -> 텍스트 카운트 -> 카운트 레이블 변경
    
    // 4. 버튼 클릭 -> 이메일 전송
}

extension ContactUsViewController {
    private func setNavigation() {
        navigationItem.title = "문의하기"
    }
}


enum ContactCategory: Int, CaseIterable {
    case serviceInconveneint
    case imageNotGenerated
    case slowSpeed
    case serviceError
    case other
    
    var description: String {
        switch self {
        case .serviceInconveneint:
            return "서비스 이용이 불편해요"
        case .imageNotGenerated:
            return "원하는 그림이 생성되지 않아요"
        case .slowSpeed:
            return "속도가 너무 느려요"
        case .serviceError:
            return "서비스 이용에 오류가 있어요"
        case .other:
            return "기타"
        }
    }
}
