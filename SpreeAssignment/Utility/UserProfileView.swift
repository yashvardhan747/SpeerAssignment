//
//  UserProfileView.swift
//  SpreeAssignment
//
//  Created by Astrotalk on 03/01/24.
//

import UIKit

class UserProfileView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userDetailTableView: UITableView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubView()
    }
    
    private func initSubView() {
        let nib = UINib(nibName: "UserProfileView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
                contentView.frame = bounds
                addSubview(contentView)
        contentView.frame = bounds
        addSubview(contentView)
        
        userDetailTableView.register(UINib(nibName: Constants.CellIdentifiers.UserProfileDetailTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.UserProfileDetailTableViewCell)
    }
    
    
}
