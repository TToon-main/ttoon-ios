//
//  AlarmViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/20/24.
//

import UIKit

import RxCocoa
import RxSwift

final class AlarmViewController: BaseViewController {
    let alarmTableView = AlarmTableView()
    
    override func loadView() {
        view = alarmTableView
    }
    
    override func configures() {
        setTableView()
    }
    
    private func setTableView() {
        alarmTableView.dataSource = self
        alarmTableView.delegate = self
    }
}

extension AlarmViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as? AlarmTableViewCell else {
            return UITableViewCell()
        }

        return cell
    }
}
