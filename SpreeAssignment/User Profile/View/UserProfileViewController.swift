//
//  UserProfileViewController.swift
//  SpreeAssignment
//
//  Created by Astrotalk on 03/01/24.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var userProfileView: UserProfileView!
    
    private let viewModel: UserProfileViewModel
    
    init(viewModel: UserProfileViewModel) {
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
        viewModel.fetchUserProfile(userName: viewModel.getUserName())
    }
    
    private func setupUI(){
        self.title = viewModel.getUserName()
        userProfileView.userDetailTableView.delegate = self
        userProfileView.userDetailTableView.dataSource = self
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getuserProfileDetailsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.UserProfileDetailTableViewCell, for: indexPath) as? UserProfileDetailTableViewCell else {return UITableViewCell()}
        guard let vm = viewModel.getCellViewModel(at: indexPath.row) else {return UITableViewCell()}
        
        cell.configure(viewModel: vm)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vm = viewModel.getViewModelOnTap(at: indexPath.row) else {return}
        
        let vc = UsersListViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }

}

//MARK: - UserProfileViewModelDelegate

extension UserProfileViewController: UserProfileViewModelDelegate {
    func reloadView() {
        userProfileView.profileImageView.setAndSaveImage(imageUrlString: viewModel.getProfilePicImageUrl(), imageName: viewModel.getUserName())
        userProfileView.userDetailTableView.reloadData()
    }
    
    func showError(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ok", style: .cancel)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: false)
    }
}
