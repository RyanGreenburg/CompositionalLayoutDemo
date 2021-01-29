//
//  ViewController.swift
//  compLayoutDemo
//
//  Created by RYAN GREENBURG on 1/25/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var dataSource: DataSource = {
        DataSource(collectionView: collectionView, data: MockData.colors)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = dataSource
    }
}

