//
//  FollowersOrFollowingListViewModel.swift
//  SpreeAssignment
//
//  Created by Astrotalk on 03/01/24.
//

import Foundation

protocol UsersListViewModelDelegate: AnyObject {
    func reloadTableView()
    func showError(message: String)
}

enum UserListType {
    case followers
    case following
}

class UsersListViewModel {
    private let userlistType: UserListType
    private let parentUser: UserProfileModel
    
    private var userProfileModels = [UserProfileModel]()
    
    weak var delegate: UsersListViewModelDelegate?
    
    init(parentUser: UserProfileModel, userlistType: UserListType) {
        self.parentUser = parentUser
        self.userlistType = userlistType
    }
//    MARK: - Get functions
    func getTitle() -> String? {
        switch userlistType {
        case .followers:
            if let name = parentUser.name {
                return "Followers of " + name
            }else {
                return nil
            }
        case .following:
            if let name = parentUser.name {
                return name + " following"
            }else {
                return nil
            }
        }
    }
    
    func getUserProfileModelsCount() -> Int {
        userProfileModels.count
    }
    
    func getUserProfileModel(at index: Int) -> UserProfileModel? {
        guard index < userProfileModels.count else {return nil}
        return userProfileModels[index]
    }
    
    func getCellViewModel(at index: Int) -> UsersListTablaViewCellViewModel? {
        guard let userProfileModel = getUserProfileModel(at: index) else {return nil}
        
        return UsersListTablaViewCellViewModel(userName: userProfileModel.userName, name: userProfileModel.name, imageUrlString: userProfileModel.profileImageUrlString)
    }
    
    func getUserProfileViewModel(at index: Int) -> UserProfileViewModel? {
        guard let userProfileModel = getUserProfileModel(at: index) else {return nil}
        
        return UserProfileViewModel(userName: userProfileModel.userName)
    }
}

//MARK: - Fetch users list

extension UsersListViewModel {
    func fetchUsers() {
        let apiCall: APICall
        
        switch userlistType {
        case .followers:
            apiCall = .getFollowers(parentUser.userName)
        case .following:
            apiCall = .getFollowings(parentUser.userName)
        }
        
        APIManager.shared.makeAPICall(call: apiCall) {[weak self] (result: Result<[DecodingFailableObject<UserProfileModel>], NetworkError>) in
            guard let safeSelf = self else {return}
            switch result {
            case .success(let decodingFailableUsers):
                
                safeSelf.userProfileModels = decodingFailableUsers.compactMap { optionalUser in
                    switch optionalUser.value {
                    case .success(let userProfileModel):
                        return userProfileModel
                    case .failure(_):
                        return nil
                    }
                }
                safeSelf.delegate?.reloadTableView()
            case .failure(let error):
                safeSelf.delegate?.showError(message: error.getErrorString)
            }
        }
    }
}
