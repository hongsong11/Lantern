//
//  DefaultPageIndicatorViewController.swift
//  Example
//
//  Created by JiongXing on 2019/12/16.
//  Copyright © 2021 丰巢科技. All rights reserved.
//

import UIKit
import Lantern
import SDWebImage

class DefaultPageIndicatorViewController: BaseCollectionViewController {
    
    override var name: String { "UIPageControl样式的页码指示器" }
    
    override var remark: String { "举例如何使用UIPageControl样式的页码指示器" }
    
    override func makeDataSource() -> [ResourceModel] {
        makeNetworkDataSource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.fc.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        if let firstLevel = self.dataSource[indexPath.item].firstLevelUrl {
            let url = URL(string: firstLevel)
            cell.imageView.sd_setImage(with: url, completed: nil)
        }
        return cell
    }
    
    override func openLantern(with collectionView: UICollectionView, indexPath: IndexPath) {
        let lantern = Lantern()
        lantern.numberOfItems = {
            self.dataSource.count
        }
        lantern.reloadCellAtIndex = { context in
            let url = self.dataSource[context.index].secondLevelUrl.flatMap { URL(string: $0) }
            let lanternCell = context.cell as? LanternImageCell
            lanternCell?.index = context.index
            let collectionPath = IndexPath(item: context.index, section: indexPath.section)
            let collectionCell = collectionView.cellForItem(at: collectionPath) as? BaseCollectionViewCell
            let placeholder = collectionCell?.imageView.image
            lanternCell?.imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: { (_, _, _, _) in
                lanternCell?.setNeedsLayout()
            })
        }
        lantern.transitionAnimator = LanternZoomAnimator(previousView: { index -> UIView? in
            let path = IndexPath(item: index, section: indexPath.section)
            let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
            return cell?.imageView
        })
        // UIPageIndicator样式的页码指示器
        lantern.pageIndicator = LanternDefaultPageIndicator()
        lantern.pageIndex = indexPath.item
        lantern.show()
    }
}
