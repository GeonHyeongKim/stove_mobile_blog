//
//  DetailComentTableViewCell.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/05.
//

import UIKit

protocol DetailDeleteCommentTableDelegate: AnyObject {
    func deleteComment(cell: DetailComentTableViewCell, index: Int)
}

class DetailComentTableViewCell: UITableViewCell {

    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblComent: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    weak var delegate: DetailDeleteCommentTableDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteComment(_ sender: Any) {
        delegate?.deleteComment(cell: self, index: btnDelete.tag)
    }
}
