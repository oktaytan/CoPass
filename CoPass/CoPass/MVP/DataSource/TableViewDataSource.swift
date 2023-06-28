//
//  TableViewDataSource.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 27.06.2023.
//

import UIKit

class TableViewDataSource<U, V: ViewCell>: NSObject, UITableViewDataSource, ViewDataSource where U == V.ItemType {
    
    var items = [U]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: V.identifier, for: indexPath)
        let item = self.item(at: indexPath)
        (cell as! V).configure(for: item)
        return cell
    }
}

