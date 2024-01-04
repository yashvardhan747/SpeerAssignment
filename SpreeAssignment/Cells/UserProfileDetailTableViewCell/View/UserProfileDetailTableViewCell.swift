//
//  UserProfileDetailTableViewCell.swift
//  SpreeAssignment
//
//  Created by Astrotalk on 03/01/24.
//

import UIKit

class UserProfileDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    
    private var viewModel: UserProfileTableViewCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(viewModel: UserProfileTableViewCellViewModel) {
        self.viewModel = viewModel
        
        title.text = viewModel.title
        value.text = viewModel.value
    }
    
}
