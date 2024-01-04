//
//  UsersListTableViewCell.swift
//  SpreeAssignment
//
//  Created by Astrotalk on 03/01/24.
//

import UIKit
import SkeletonView

class UsersListTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    private var viewModel: UsersListTablaViewCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userNameLabel.showAnimatedSkeleton()
        userProfileImageView.showAnimatedSkeleton()
        nameLabel.showAnimatedSkeleton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func hideSkeletonView() {
        userNameLabel.hideSkeleton()
        userProfileImageView.hideSkeleton()
        nameLabel.hideSkeleton()
    }
    
    func configure(viewModel: UsersListTablaViewCellViewModel) {
        hideSkeletonView()
        self.viewModel = viewModel
        
        userNameLabel.text = viewModel.userName
        nameLabel.text = viewModel.name ?? ""
        userProfileImageView.setAndSaveImage(imageUrlString: viewModel.imageUrlString, imageName: viewModel.userName)
    }
}
