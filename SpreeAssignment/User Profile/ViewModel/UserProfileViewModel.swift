//
//  UserProfileViewModel.swift
//  SpreeAssignment
//
//  Created by Astrotalk on 04/01/24.
//

import Foundation

protocol UserProfileViewModelDelegate: AnyObject {
    func reloadView()
    func showError(message: String)
}

class UserProfileViewModel{
    private let userName: String
    private var userProfileModel: UserProfileModel?
    private var userProfileDetails = [UserProfileDetail]()
    
    weak var delegate: UserProfileViewModelDelegate?
    
    init(userName: String) {
        self.userName = userName
    }
    
    private func fillUserFrofileDetails() {
        guard let safeUserProfileModel = userProfileModel else {return}
        
        userProfileDetails.append(.userName(safeUserProfileModel.userName))
        
        if let name = safeUserProfileModel.name {
            userProfileDetails.append(.name(name))
        }
        
        if let description = safeUserProfileModel.description {
            userProfileDetails.append(.description(description))
        }
        
        if let followersCount = safeUserProfileModel.followersCount {
            userProfileDetails.append(.followers(followersCount))
        }
        
        if let followingCount = safeUserProfileModel.followingCount {
            userProfileDetails.append(.following(followingCount))
        }
    }
    
// MARK: - Get functions
    
    func getuserProfileDetailsCount() -> Int{
        userProfileDetails.count
    }
    
    private func getUserDetail(at index: Int) -> UserProfileDetail? {
        guard index < userProfileDetails.count else {return nil}
        return userProfileDetails[index]
    }
    
    func getCellViewModel(at index: Int) -> UserProfileTableViewCellViewModel? {
        guard let userDetail = getUserDetail(at: index) else {return nil}
        return UserProfileTableViewCellViewModel(title: userDetail.getTitle, value: userDetail.getValue)
    }
    
    func getViewModelOnTap(at index: Int) -> UsersListViewModel? {
        guard let userDetail = getUserDetail(at: index),
              let safeUserProfileModel = userProfileModel else {return nil}
        
        switch userDetail {
        case .followers(_):
            return UsersListViewModel(parentUser: safeUserProfileModel, userlistType: .followers)
        case .following(_):
            return  UsersListViewModel(parentUser: safeUserProfileModel, userlistType: .following)
        default:
            return nil
        }
    }
    
    func getUserName() -> String {
        userName
    }
    
    func getProfilePicImageUrl() -> String? {
        userProfileModel?.profileImageUrlString
    }
}


//MARK: - UserProfileViewModel

extension UserProfileViewModel{
    func fetchUserProfile(userName: String) {
        APIManager.shared.makeAPICall(call: .getUserProfile(userName)) {[weak self](result: Result<UserProfileModel, NetworkError>) in
            guard let safeSelf = self else {return}
            switch result {
            case .success(let userProfile):
                safeSelf.userProfileModel = userProfile
                safeSelf.fillUserFrofileDetails()
                safeSelf.delegate?.reloadView()
            case .failure(let error):
                safeSelf.delegate?.showError(message: error.getErrorString)
            }
        }
    }
}
