//
//  MyPageViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/19/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class MyPageViewController: BaseViewController {
    // MARK: - Properties
    private lazy var appSetSection: MyPageTableViewDataSource = {
        let notificationRow = MyPageTableViewCellDataSource(title: "알림 설정", info: "On")
        let languageRow = MyPageTableViewCellDataSource(title: "언어 설정", info: setUpLang())
        
        return MyPageTableViewDataSource(sectionTitle: "설정", cellData: [notificationRow, languageRow])
    }()
    
    private lazy var appInfoSection: MyPageTableViewDataSource = {
        let appVersionRow = MyPageTableViewCellDataSource(title: "앱 버전", info: self.currentAppVersion(), isArrowVisible: true)
        let privacyPolicyRow = MyPageTableViewCellDataSource(title: "개인정보 처리방침")
        let openSourceRow = MyPageTableViewCellDataSource(title: "오픈 소스")
        let creatorsRow = MyPageTableViewCellDataSource(title: "만든 사람들")
        let contactUsRow = MyPageTableViewCellDataSource(title: "문의하기")
        
        return MyPageTableViewDataSource(sectionTitle: "앱 정보 및 문의", cellData: [appVersionRow, privacyPolicyRow, openSourceRow, creatorsRow, contactUsRow])
    }()
    
    private lazy var accountSection: MyPageTableViewDataSource = {
        let logoutRow = MyPageTableViewCellDataSource(title: "로그아웃")
        let withdrawRow = MyPageTableViewCellDataSource(title: "탈퇴하기")
        
        return MyPageTableViewDataSource(sectionTitle: "계정", cellData: [logoutRow, withdrawRow])
    }()
    
    private lazy var languageDataSource = ["Eng", "한국어"]
    
    private lazy var myPageTableViewDataSource = [appSetSection, appInfoSection, accountSection]
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    private let myPageView = MyPageView()
    
    // MARK: - Init
    init(myPageReactor: MyPageReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = myPageReactor 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycles
    override func loadView() {
        view = myPageView
    }
    
    // MARK: - Configures
    override func configures() {
        setTableView()
        setNavigationItem()
    }
    
    func setTableView() {
        myPageView.myPageTableView.dataSource = self
        myPageView.myPageTableView.delegate = self
    }
    
    func currentAppVersion() -> String {
        if let info: [String: Any] = Bundle.main.infoDictionary, let currentVersion: String = info["CFBundleShortVersionString"] as? String {
            return currentVersion
        }
        return "1.0"
    }
    
    private func setNavigationItem() {
        self.navigationItem.title = "마이페이지"
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
}

extension MyPageViewController: View {
    func bind(reactor: MyPageReactor) {
        bindState(reactor: reactor)
        bindAction(reactor: reactor)
    }
    
    func bindAction(reactor: MyPageReactor) {
        rx.viewWillAppear
            .map { _ in MyPageReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myPageView.rx.profileSettingButtonTap
            .map { MyPageReactor.Action.profileSettingButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: MyPageReactor) {
        reactor.state
            .map { $0.userInfo }
            .compactMap { $0 }
            .bind(to: myPageView.rx.userInfo)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.presentProfileSetVC }
            .compactMap { $0 }
            .bind(onNext: presentSetProfileVC)
            .disposed(by: disposeBag)
    }
    
    func setUpLang() -> String {
        guard let languageCode = Locale.current.language.languageCode?.identifier else { return "한국어" }
        
        if languageCode == "ko" {
            return "한국어"
        } else {
            return "Eng"
        }
    }
}

// MARK: - Header, Footer 관련 코드

extension MyPageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return myPageTableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return makeHeader(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPageTableViewDataSource[section].cellData.count
    }
    
    private func makeHeader(_ tableView: UITableView, section: Int) -> UIView? {
        let headerView = makeHeaderView(tableView.bounds.width, 16)
        let titleLabel = makeHeaderLabel(section)
        
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        return headerView
    }
    
    private func makeHeaderView(_ width: CGFloat, _ height: CGFloat) -> UIView {
        let size = CGSize(width: width, height: height)
        let headerView = UIView.init(frame: CGRect.init(origin: .zero, size: size))
        
        return headerView
    }
    
    private func makeHeaderLabel(_ section: Int) -> UILabel  {
        let titleLabel = UILabel()
        titleLabel.textColor = .grey06
        titleLabel.font = .body14r
        titleLabel.text = myPageTableViewDataSource[section].sectionTitle
        
        return titleLabel
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 0
        }
        
        return 48
    }
}

// MARK: - Cell 관련 코드
extension MyPageViewController {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.IDF, for: indexPath) as? MyPageTableViewCell else {
            return UITableViewCell()
        }
        
        let data = myPageTableViewDataSource[indexPath.section].cellData[indexPath.row]
        cell.setCell(data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 2) {
            presetLogoutAlert()
        }
        
        if indexPath == IndexPath(row: 0, section: 0) {
            presentAlarmVC()
        }
        
        if indexPath == IndexPath(row: 1, section: 0) {
            presentChangeLangVC()
        }
    }
    
    private func presentChangeLangVC() {
        let viewControllerToPresent = MyPageChangeLangViewController()
        
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.custom { context in return 265 } ]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    private func presentAlarmVC() {
        let vc = AlarmViewController()
        present(vc, animated: true)
    }
    
    private func presentSetProfileVC() {
        let repo = MyPageRepository()
        let useCase = MyPageUseCase(repository: repo)
        let reactor = ProfileSetReactor(useCase: useCase)
        let vc = ProfileSetViewController(profileSetReactor: reactor)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presetLogoutAlert() {
        TNAlert(self)
            .setTitle("로그아웃 하시겠어요?")
            .setSubTitle("재접속하시면 다시 로그인 해야해요.")
            .addCancelAction("취소")
            .addConfirmAction("로그아웃")
            .present()
    }
}
