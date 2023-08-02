//
//  SearchFilterOptionCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class SearchFilterOptionCell: UITableViewCell {
    static let reuseIdentifier: String = "SearchFilterOptionCell"
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}
