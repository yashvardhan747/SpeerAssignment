//
//  ViewController.swift
//  SpreeAssignment
//
//  Created by Astrotalk on 03/01/24.
//

import UIKit

class SearchUserProfileViewController: UIViewController {

    @IBOutlet weak var searchUserTextField: UITextField!
    @IBOutlet weak var userProfileView: UserProfileView!
    @IBOutlet weak var noUserLabel: UILabel!
    
    private let viewModel = SearchUserProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileView.isHidden = true
        viewModel.delgate = self
        
        setUpUI()
        setupUIForInitialState()
    }
    
    private func setUpUI(){
        searchUserTextField.delegate = self
        
        userProfileView.userDetailTableView.delegate = self
        userProfileView.userDetailTableView.dataSource = self
    }
}

//MARK: - UITextFieldDelegate

extension SearchUserProfileViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, text.isEmpty == false else {
            setupUIForInitialState()
            return
        }
        viewModel.searchUserProfile(for: text)
        return
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchUserProfileViewController: UITableViewDelegate, UITableViewDataSource {
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

//MARK: - SearchUserProfileViewModelDelegate

extension SearchUserProfileViewController: SearchUserProfileViewModelDelegate {
    func dismissKeyboard() {
        searchUserTextField.resignFirstResponder()
    }
    
    func setupUIForInitialState() {
        dismissKeyboard()
        userProfileView.isHidden = true
        noUserLabel.isHidden = false
        noUserLabel.text = "Search user by UserName"
    }
    
    func setupUIForUserFound() {
        guard let safeUserName = viewModel.getUserName() else {return}
        userProfileView.isHidden = false
        noUserLabel.isHidden = true
        
        userProfileView.profileImageView.setAndSaveImage(imageUrlString: viewModel.getProfilePicImageUrl(), imageName: safeUserName)
        
        userProfileView.userDetailTableView.reloadData()
    }
    
    func setupUIForUserNotFound() {
        userProfileView.isHidden = true
        noUserLabel.isHidden = false
        noUserLabel.text = "No user found"
    }
}
