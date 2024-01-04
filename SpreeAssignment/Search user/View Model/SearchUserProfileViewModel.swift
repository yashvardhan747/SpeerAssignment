//
//  SearchUserProfileViewModel.swift
//  SpreeAssignment
//
//  Created by Astrotalk on 03/01/24.
//

import Foundation

protocol SearchUserProfileViewModelDelegate: AnyObject {
    func setupUIForUserFound()
    func setupUIForUserNotFound()
    func setupUIForInitialState()
    func dismissKeyboard()
}

enum UserProfileDetail{
    case userName(String)
    case name(String)
    case description(String)
    case followers(Int)
    case following(Int)
    
    var getTitle: String {
        switch self {
        case .userName(_):
            "User name"
        case .name(_):
            "Name"
        case .description(_):
            "Description"
        case .followers(_):
            "Followers"
        case .following(_):
            "Following"
        }
    }
    
    var getValue: String {
        switch self {
        case .userName(let string):
            string
        case .name(let string):
            string
        case .description(let string):
            string
        case .followers(let int):
            String(int)
        case .following(let int):
            String(int)
        }
    }
}

class SearchUserProfileViewModel {

    private var userProfileDetails = [UserProfileDetail]()
    private var userProfile: UserProfileModel?
    
    private var searchUserProfileWorkItem: DispatchWorkItem?
    
    weak var delgate: SearchUserProfileViewModelDelegate?
    
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
              let safeUserProfileModel = userProfile else {return nil}
        
        switch userDetail {
        case .followers(_):
            return UsersListViewModel(parentUser: safeUserProfileModel, userlistType: .followers)
        case .following(_):
            return  UsersListViewModel(parentUser: safeUserProfileModel, userlistType: .following)
        default:
            return nil
        }
    }

    func getUserName() -> String? {
        userProfile?.userName
    }
    
    func getProfilePicImageUrl() -> String? {
        userProfile?.profileImageUrlString
    }
    
// MARK: - Helper Functions
    
    func fillUserFrofileDetails() {
        guard let safeUserProfile = userProfile else {return}
        
        userProfileDetails = [UserProfileDetail]()
        userProfileDetails.append(.userName(safeUserProfile.userName))
        if let name = safeUserProfile.name {
            userProfileDetails.append(.name(name))
        }
        
        if let description = safeUserProfile.description {
            userProfileDetails.append(.description(description))
        }
        
        if let followersCount = safeUserProfile.followersCount {
            userProfileDetails.append(.followers(followersCount))
        }
        
        if let followingCount = safeUserProfile.followingCount {
            userProfileDetails.append(.following(followingCount))
        }
    }
    
    func searchUserProfile(for string: String) {
        searchUserProfileWorkItem?.cancel()
        
        let workItem: DispatchWorkItem = DispatchWorkItem {
            if string.isEmpty == true {
                DispatchQueue.main.async {
                    self.delgate?.setupUIForInitialState()
                }
            }else {
                self.fetchUserProfile(userName: string)
                DispatchQueue.main.async {
                    self.delgate?.dismissKeyboard()
                }
            }
        }
        
        searchUserProfileWorkItem = workItem
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: workItem)
    }
}

//MARK: - Fetch User details

extension SearchUserProfileViewModel {
    func fetchUserProfile(userName: String) {
        if userName.isEmpty {
            delgate?.setupUIForInitialState()
        }
        APIManager.shared.makeAPICall(call: .getUserProfile(userName)) {[weak self](result: Result<UserProfileModel, NetworkError>) in
            guard let safeSelf = self else {return}
            switch result {
            case .success(let userProfile):
                safeSelf.userProfile = userProfile
                safeSelf.fillUserFrofileDetails()
                safeSelf.delgate?.setupUIForUserFound()
            case .failure(_):
                safeSelf.delgate?.setupUIForUserNotFound()
            }
        }
    }
}
