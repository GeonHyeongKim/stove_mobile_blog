//
//  DetailInputTableViewCell.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/04.
//

import UIKit

protocol DetailInputTableDelegate: AnyObject {
    func didReturn(cell: DetailInputTableViewCell, string: String?)
}

class DetailInputTableViewCell: UITableViewCell {

    @IBOutlet weak var tfInputComment: UITextField!
    weak var delegate: DetailInputTableDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tfInputComment.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension DetailInputTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.didReturn(cell: self, string: textField.text)
        textField.text = ""
        return true
    }
}
