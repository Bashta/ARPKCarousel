//
//  CarouselCollectionFlowLayout.swift
//  ARPKCarousel
//
//  Created by Gerald Kim on 12/2/19.
//  Copyright © 2019 ARPlaykit. All rights reserved.
//

import UIKit

class CarouselCollectionFlowLayout: UICollectionViewFlowLayout {

    // This needs to be overriden to customize the paging offset of the cells.
    // Someone else (https://stackoverflow.com/a/49617263) wrote some fancy code for this
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        let pageWidth = self.itemSize.width + self.minimumInteritemSpacing
        let approximatePage = collectionView.contentOffset.x / pageWidth
        let currentPage = (velocity.x < 0.0) ? floor(approximatePage) : ceil(approximatePage)
        let flickVelocity = velocity.x * 0.3

        let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)
        let newHorizontalOffset = ((currentPage + flickedPages) * pageWidth) - collectionView.contentInset.left
        return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
    }
}
