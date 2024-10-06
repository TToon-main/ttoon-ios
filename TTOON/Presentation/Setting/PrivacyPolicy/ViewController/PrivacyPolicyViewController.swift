//
//  PrivacyPolicyViewController.swift
//  TTOON
//
//  Created by 임승섭 on 11/3/24.
//

import UIKit

class PrivacyPolicyViewController: BaseViewController {
    let vm = PrivacyPolicyViewModel()
    let mainView = PrivacyPolicyView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setTableView()
    }
}

extension PrivacyPolicyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrivacyPolicyTableViewCell.description(), for: indexPath) as? PrivacyPolicyTableViewCell else { return UITableViewCell() }
        
        cell.setDesign(
            title: vm.data[indexPath.row].title,
            content: vm.data[indexPath.row].content
        )
        
        return cell
    }
}

extension PrivacyPolicyViewController {
    private func setNavigation() {
        navigationItem.title = "개인정보 처리방침"
    }
    
    private func setTableView() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
}