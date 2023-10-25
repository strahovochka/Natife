//
//  FullPostTableViewCell.swift
//  Natife_TT
//
//  Created by Jane Strashok on 25.10.2023.
//

import UIKit

class FullPostTableViewCell: UITableViewCell {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
