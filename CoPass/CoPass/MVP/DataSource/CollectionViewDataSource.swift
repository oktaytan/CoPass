//
//  CollectionViewDataSource.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 27.06.2023.
//

import UIKit

class CollectionViewDataSource<U, V: ViewCell>: NSObject, UICollectionViewDataSource, ViewDataSource where U == V.ItemType {
    var items = [U]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: V.reuseIndentifier, for: indexPath)
        let item = self.item(at: indexPath)
        (cell as! V).configure(for: item)
        return cell
    }
}
