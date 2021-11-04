//
//  HomeBannerTableViewCell.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/04.
//

import UIKit

class HomeBannerTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var cvBanner: UICollectionView!
    
    var banners = Banner.dummyBannerList
    var timer = Timer()
    var counter = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cvBanner.delegate = self
        cvBanner.dataSource = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @objc func changeImage() {
//        if counter < banners.count {
//            let index = IndexPath.init(item: counter, section: 0)
//            self.cvBanner.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
//            pcBanner.currentPage = counter
//            counter += 1
//        } else {
//            counter = 0
//            let index = IndexPath.init(item: counter, section: 0)
//            self.cvBanner.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
//            pcBanner.currentPage = counter
//            counter = 1
//        }
//    }

    // MARK: - Collection View DataSource, Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Banner.dummyBannerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeBannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
        cell.ivBanner.image = UIImage(named: banners[indexPath.row].imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = cvBanner.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
        
}
