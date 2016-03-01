//
//  GraphCollectionView.swift
//  FloCGDemo
//
//  Created by Junna on 3/1/16.
//  Copyright © 2016 Junna. All rights reserved.
//

import Foundation
import UIKit

class GraphCollectionView: UICollectionView {
    
    var collection: [[Int16]] = [] {
        didSet {
            reloadData()
        }
    }
    
    private let cellIdentifier: String = "GraphCell"
    
    convenience init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSize(width: frame.width - 8, height: frame.height)
        layout.minimumLineSpacing = 8.0
        self.init(frame: frame, collectionViewLayout:layout)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.dataSource = self
        self.delegate = self
        self.registerClass(GraphCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.allowsSelection = false
        self.pagingEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GraphCollectionView : UICollectionViewDataSource, UICollectionViewDelegate {
    @available(iOS 6.0, *)
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! GraphCollectionViewCell
        cell.items = collection[indexPath.row]
        return cell
    }
}

class GraphCollectionViewCell: UICollectionViewCell {
    var items : [Int16] = [] {
        didSet {
            setup()
        }
    }
    
    func setup() {
        self.contentView.addSubview(graphView)
        graphView.graphPoints = items
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        graphView.width = self.contentView.width
        graphView.height = self.contentView.height
        graphView.top = 0.0
        graphView.left = 0.0
    }
        
    lazy var graphView : GraphView = {
        let view = GraphView(frame: CGRectZero)
        return view
    }()
}