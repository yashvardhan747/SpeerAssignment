//
//  UsersListTablaViewCellViewModel.swift
//  SpreeAssignment
//
//  Created by Astrotalk on 04/01/24.
//

import Foundation

struct UsersListTablaViewCellViewModel {
    let userName: String
    let name: String?
    let imageUrlString: String?
    
    init(userName: String, name: String?, imageUrlString: String?) {
        self.userName = userName
        self.name = name
        self.imageUrlString = imageUrlString
    }
}
