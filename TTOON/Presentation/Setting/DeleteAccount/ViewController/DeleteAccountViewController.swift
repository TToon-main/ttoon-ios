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
    
    // 얼럿에도 연결해야 하고, reactor로도 연결해야 해서, 임의의 프로퍼티를 하나 만든다.
    // 버튼이 눌리면, 해당 subject에 이벤트를 발생시킨다.
    // -> reactor로 bind되어 네트워크 통신을 수행한다.
    var deleteAccountButtonTapped = PublishSubject<Void>()
    
    init(deleteAccountReactor: DeleteAccountReactor) {
        super.init(nibName: nil, bundle: nil)
        
        let reactor = DeleteAccountReactor()
        self.reactor = reactor
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
        loadInitialData()
    }
    
    func bind(reactor: DeleteAccountReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: DeleteAccountReactor) {
        // 바텀시트 올려주기만 하기
        mainView.reasonPickerView.clearButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.presentDeleteAccountBottomSheetVC()
            }
            .disposed(by: disposeBag)
        
        // 직접 입력일 때만 등장하는 텍스트뷰
        mainView.reasonTextView.rx.text.orEmpty
            .map { DeleteAccountReactor.Action.directInputText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // 완료 버튼의 tap은 단순히 얼럿만 띄워준다.
        // 얼럿의 버튼이 실제 탈퇴하기 버튼
        mainView.completeButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                TNAlert(self)
                    .setTitle("정말 탈퇴하시겠어요?")
                    .setSubTitle("그동안의 소중한 기록이 모두 사라지고, 탈퇴 후에는 다시 복구할 수 없어요.")
                    .addCancelAction("돌아가기", action: nil)
                    .addConfirmAction("탈퇴하기", action: {
                        owner.reactor?.action.onNext(.confirmButtonTapped)  // 탈퇴 버튼 탭 액션 전달
                    })
                    .present()
            }
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: DeleteAccountReactor) {
        reactor.state.map { $0.userNickname }
            .subscribe(with: self) { owner, nickname in
                owner.mainView.mainTitleLabel.text = "\(nickname)님이 떠나신다니\n너무 아쉬워요"
                owner.mainView.nameInputView.nameLabel.text = nickname
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.deleteReason }
            .map { value in
                if let value { return value.description }
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
                owner.mainView.completeButton.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        // 탈퇴 완료
        reactor.state.map { $0.completeResult }
            .subscribe(with: self) { owner, result  in
                if result {
                    owner.popToLoginVC()
                }
            }
            .disposed(by: disposeBag)
        
        // (탈퇴를 위한) 애플 재로그인 성공
        reactor.state.map { $0.goDeleteAccountWithApple }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                if value {
                    owner.reactor?.action.onNext(.deleteAccountWithApple)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension DeleteAccountViewController {
    private func setNavigation() {
        navigationItem.title = "탈퇴하기"
    }
    
    private func presentDeleteAccountBottomSheetVC() {
        // VC의 reactor 전달
        let vc = DeleteAccountReasonBottomSheetViewController(self.reactor!)
        
        vc.bottomSheetView.titleLabel.text = "탈퇴하시는 이유를 알려주세요"
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom { _ in return 547 } ]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        self.present(vc, animated: true)
    }
    
    private func loadInitialData() {
        self.reactor?.action.onNext(.loadData)
    }
    
    private func popToLoginVC() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.logout()
        }
    }
}

enum DeleteAccountReason: Int, CaseIterable {
    case serviceInconvenient
    case notHelpfulForWriting
    case ineffectiveForDailyRecords
    case unsatisfactoryImages
    case switchingToOtherService
    case directInput
    
    var description: String {
        switch self {
        case .serviceInconvenient:
            return "서비스 이용이 불편해서"
        case .notHelpfulForWriting:
            return "일기 작성에 도움이 되지 않아서"
        case .ineffectiveForDailyRecords:
            return "꾸준한 일상 기록에 효과가 없어서"
        case .unsatisfactoryImages:
            return "생성되는 이미지가 마음에 들지 않아서"
        case .switchingToOtherService:
            return "타 서비스로 이동"
        case .directInput:
            return "직접 입력"
        }
    }
}
