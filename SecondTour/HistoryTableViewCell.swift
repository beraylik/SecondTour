//
//  HistoryTableViewCell.swift
//  SecondTour
//
//  Created by Gena Beraylik on 12.11.2017.
//  Copyright © 2017 Beraylik. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .green
        setupViews()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.contentView.addSubview(pathLabel)
        self.contentView.addSubview(dateLabel)
        
        self.contentView.addConstraintsWith(format: "H:|-10-[v0]-5-[v1(130)]-5-|", views: [pathLabel, dateLabel])
    
        self.contentView.addConstraintsWith(format: "V:|-5-[v0(40)]", views: [pathLabel])
        self.contentView.addConstraintsWith(format: "V:|-5-[v0(40)]", views: [dateLabel])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    let pathLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

}
