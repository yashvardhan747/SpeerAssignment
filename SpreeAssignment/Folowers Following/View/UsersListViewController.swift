//
//  FollowersOrFollowingListViewController.swift
//  SpreeAssignment
//
//  Created by Astrotalk on 03/01/24.
//

import UIKit

class UsersListViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!
    
    private let viewModel: UsersListViewModel
    
    init(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupUI()
        viewModel.fetchUsers()
    }

    private func setupUI() {
        self.title = viewModel.getTitle()
        
        usersTableView.register(UINib(nibName: Constants.CellIdentifiers.UsersListTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.UsersListTableViewCell)
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        usersTableView.refreshControl = UIRefreshControl()
        usersTableView.refreshControl?.addTarget(self, action: #selector(callPullToRefersh), for: .valueChanged)
    }
    
    @objc private func callPullToRefersh() {
        viewModel.fetchUsers()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getUserProfileModelsCount() == 0 ? 10 : viewModel.getUserProfileModelsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.UsersListTableViewCell, for: indexPath) as? UsersListTableViewCell else {return UITableViewCell()}
        guard let vm = viewModel.getCellViewModel(at: indexPath.row) else {return cell}
        
        cell.configure(viewModel: vm)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vm = viewModel.getUserProfileViewModel(at: indexPath.row) else {return}
        
        let vc = UserProfileViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
        return
    }
}

//MARK: - UsersListViewModelDelegate

extension UsersListViewController: UsersListViewModelDelegate {
    func reloadTableView() {
        usersTableView.refreshControl?.endRefreshing()
        usersTableView.reloadData()
    }
    
    func showError(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ok", style: .cancel) { _ in
            self.usersTableView.refreshControl?.endRefreshing()
            UIView.animate(withDuration: 0.5, animations: {
                self.usersTableView.contentOffset = CGPoint.zero
            })
        }
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: false)
        self.usersTableView.refreshControl?.endRefreshing()
    }
}

