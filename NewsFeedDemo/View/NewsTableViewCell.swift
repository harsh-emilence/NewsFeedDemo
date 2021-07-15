//
//  NewsTableViewCell.swift
//  NewsFeedDemo
//
//  Created by Zimble on 14/07/21.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var newTitle: UILabel!
    
    @IBOutlet weak var newLink: UILabel!
    @IBOutlet weak var editorName: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    static let identifier = "NewsTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
