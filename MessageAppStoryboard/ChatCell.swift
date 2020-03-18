//
//  ChatCell.swift
//  MessageAppStoryboard
//
//  Created by Volkan on 17.03.2020.
//  Copyright © 2020 Volkan. All rights reserved.
//

import UIKit
import Firebase

class ChatCell: UITableViewCell {

    @IBOutlet weak var messageCame: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
