//
//  ViewController.swift
//  ARPKCarousel
//
//  Created by Gerald Kim on 7/2/19.
//  Copyright © 2019 ARPlaykit. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var modelView: ThreeDView!
    var currentIndex = -1

    let imageArray = [UIImage(named: "white"),
                      UIImage(named: "black"),
                      UIImage(named: "blue"),
                      UIImage(named: "green"),
                      UIImage(named: "yellow"),
                      UIImage(named: "orange"),
                      UIImage(named: "Red"),
                      UIImage(named: "pink")]

    override func viewDidLoad() {
        super.viewDidLoad()
        modelView.isRotating = true
        if let scnAssetPath = Bundle.main.path(forResource: "redchair", ofType: "usdz") {
            try! modelView.loadWithUSDZ(arUrl: URL(fileURLWithPath:scnAssetPath),
                                        cameraPosition: SCNVector3(x: 0, y: 50, z: 150),
                                        cameraXRotation: 0,
                                        pivotPosition: SCNVector3(x: 0, y: 0, z: 0))
        }
        changeTexture(index: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: collectionView.frame.size.width - modelView.frame.size.width)
    }

    func changeTexture(index: Int) {
        guard let node = modelView.modelNode?.childNode(withName: "RedChairSeat", recursively: true),
            index != currentIndex,
            index < imageArray.count else { return }
        currentIndex = index
        node.geometry?.material(named: "RedChairMaterial")?.diffuse.contents = imageArray[index]
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouselCell", for: indexPath) as? CarouselCollectionViewCell else {
            fatalError()
        }
        let image = imageArray[indexPath.row]
        cell.imageView.image = image
        cell.label.text = "Color \(indexPath.row)"
        return cell
    }
}

extension ViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let index = collectionView.indexPathForItem(at: view.convert(modelView.center, to: collectionView))?.item {
            changeTexture(index: index)
        }
    }
}
