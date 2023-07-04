//
//  HomeCategoryCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 3.07.2023.
//

import UIKit

protocol HomeCategoryCellDelegate: AnyObject {
    func select(_ category: CoCategory)
}

extension HomeCategoryCellDelegate {
    func select(_ category: CoCategory) {}
}

class HomeCategoryCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var data: [CoCategory : Int] = [:]
    weak var delegate: HomeCategoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        self.titleLabel.text = Strings.categoryTitle
        collectionView.cornerRadius = AppConstants.appUIRadius
        collectionView.backgroundColor = .coPurple10
        collectionView.register(cellType: HomeCategoryItemCell.self)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 18
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.contentInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func set(with data: [CoCategory : Int], delegate: HomeCategoryCellDelegate) {
        self.data = data
        self.delegate = delegate
    }
}


extension HomeCategoryCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = CoCategory.allCases[indexPath.item]
        let count = data[item] ?? 0
        let cell = collectionView.dequeueReusableCell(cellType: HomeCategoryItemCell.self, indexPath: indexPath)
        cell.set(with: item, count: count)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 94.0, height: 94.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let item = CoCategory.allCases[indexPath.item]
        delegate?.select(item)
    }
}


extension HomeCategoryCell {
    struct Strings {
        static let categoryTitle = "home_category_title".localized
    }
    
    enum UserActionEvent {
        case categoryTapped(at: CoCategory)
    }
}
