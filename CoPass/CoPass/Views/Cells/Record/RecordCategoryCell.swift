//
//  RecordCategoryCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 8.07.2023.
//

import UIKit

protocol RecordCategoryCellDelegate: AnyObject {
    func selected(category: CoCategory)
}

extension RecordCategoryCellDelegate {
    func selected(category: CoCategory) {}
}

class RecordCategoryCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var categories = [CoCategory]()
    private var selectedCategory: CoCategory = .login
    
    weak var delegate: RecordCategoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: RecordCategoryItemCell.self)
    }
    
    func set(data: [CoCategory], selectedCategory: CoCategory, delegate: RecordCategoryCellDelegate) {
        self.categories = data
        self.selectedCategory = selectedCategory
        self.delegate = delegate
        self.collectionView.reloadData()
    }
}


extension RecordCategoryCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = categories[indexPath.item]
        let cell = collectionView.dequeueReusableCell(cellType: RecordCategoryItemCell.self, indexPath: indexPath)
        cell.set(data: category, isSelected: selectedCategory == category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        self.selectedCategory = category
        collectionView.reloadData()
        delegate?.selected(category: category)
    }
}
