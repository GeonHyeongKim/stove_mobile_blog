//
//  HomeSelectTableViewCell.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/04.
//

import UIKit

class HomeSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var btnNews: UIButton!
    @IBOutlet weak var btnNotice: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
