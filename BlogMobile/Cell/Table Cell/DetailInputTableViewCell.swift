//
//  DetailInputTableViewCell.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/04.
//

import UIKit

class DetailInputTableViewCell: UITableViewCell {

    @IBOutlet weak var tfInputComent: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
