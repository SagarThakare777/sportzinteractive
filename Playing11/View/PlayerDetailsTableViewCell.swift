//
//  PlayerDetailsTableViewCell.swift
//  Playing11
//
//  Created by SAGAR THAKARE on 30/04/21.
//

import UIKit

class PlayerDetailsTableViewCell: UITableViewCell {

    //MARK:- Outlet's
    @IBOutlet weak var imgPlayerProfile: UIImageView!
    @IBOutlet weak var lblPlayerFullName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
