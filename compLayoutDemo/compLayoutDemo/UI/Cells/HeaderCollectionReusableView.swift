//
//  HeaderCollectionReusableView.swift
//  compLayoutDemo
//
//  Created by RYAN GREENBURG on 1/26/21.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    static let reuseID = "\(HeaderCollectionReusableView.self)"
    static let nib = UINib(nibName: reuseID, bundle: nil)

    @IBOutlet weak var titleLabel: UILabel!
    
}
