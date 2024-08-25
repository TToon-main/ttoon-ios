//
//  FriendRequestViewController.swift
//  TTOON
//
//  Created by 임승섭 on 8/24/24.
//

import UIKit

class FriendRequestViewController: BaseViewController {
    // sample
    lazy var tableView = {
        let view = UITableView()
        view.register(FriendListTableViewCell.self, forCellReuseIdentifier: FriendListTableViewCell.description())
        view.register(UserListTableViewCell.self, forCellReuseIdentifier: UserListTableViewCell.description())
        view.register(ReceivedFriendRequestTableViewCell.self, forCellReuseIdentifier: ReceivedFriendRequestTableViewCell.description())
        view.delegate = self
        view.dataSource = self
        
        view.rowHeight = 76
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        sampleLayout()
    }
    
    
    func sampleLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}


extension FriendRequestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Sample
        if indexPath.row % 5 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendListTableViewCell.description(), for: indexPath) as? FriendListTableViewCell else { return UITableViewCell() }
            
            return cell
        } else if indexPath.row % 3 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.description(), for: indexPath) as? UserListTableViewCell else { return UITableViewCell() }
            
            cell.requestFriendButton.type = [.sendRequest, .sentRequest].randomElement()!
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedFriendRequestTableViewCell.description(), for: indexPath) as? ReceivedFriendRequestTableViewCell else {
                return UITableViewCell()
            }
            
            return cell
        }
    }
}
