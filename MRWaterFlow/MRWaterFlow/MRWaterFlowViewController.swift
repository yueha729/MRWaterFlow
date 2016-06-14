//
//  MRWaterFlowViewController.swift
//  MRWaterFlow
//
//  Created by 乐浩 on 16/6/13.
//  Copyright © 2016年 乐浩. All rights reserved.
//

import UIKit

private let MRWaterFlowCellReuseIdentifier = "MRWaterFlowCellReuseIdentifier"

class MRWaterFlowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化UI
        setupUI()
        
        setupRefresh()
    }
    
    func setupRefresh() {
        
        collectionView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(MRWaterFlowViewController.loadNewShops))
        collectionView.header.beginRefreshing()
        
        collectionView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(MRWaterFlowViewController.loadMoreShops))
        collectionView.footer.hidden = true
        
    }
    
    func loadNewShops() {
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0) * Int64(NSEC_PER_SEC)), dispatch_get_main_queue()) {
            let path = NSBundle.mainBundle().pathForResource("1.plist", ofType: nil)!
            let dictArray = NSArray(contentsOfFile: path)
            
            let shops = MRShop.dictsToModels(dictArray! as! [[String : AnyObject]])
            self.MRShops.removeAll()
            self.MRShops += shops
            
            self.collectionView.reloadData()
            self.collectionView.header.endRefreshing()
        }
    }
    
    func loadMoreShops() {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0) * Int64(NSEC_PER_SEC)), dispatch_get_main_queue()) {
            let path = NSBundle.mainBundle().pathForResource("1.plist", ofType: nil)!
            let dictArray = NSArray(contentsOfFile: path)
            let shops = MRShop.dictsToModels(dictArray! as! [[String : AnyObject]])
 
            self.MRShops += shops

            self.collectionView.reloadData()
            self.collectionView.footer.endRefreshing()
        }
    }
    
    func setupUI() {
        
        //1. 添加子控件
        view.addSubview(collectionView)
        
        //2. 布局子控件
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        
        let dict = ["collectionView": collectionView]
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dict)
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dict)
        
        view.addConstraints(cons)
    }
    
    //MARK: - 懒加载
    private lazy var MRShops: [MRShop] = [MRShop]()
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = MRWaterFlowLayout()
        layout.WaterFlowLayoutDelegate = self
        
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        //注册cell
        let nib = UINib(nibName: "MRShopCell", bundle: nil)
        clv.registerNib(nib, forCellWithReuseIdentifier: MRWaterFlowCellReuseIdentifier)
        
        clv.backgroundColor = UIColor.clearColor()
        clv.dataSource = self
        
        return clv
    }()

}

//MARK: - UICollectionViewDataSource
extension MRWaterFlowViewController: UICollectionViewDataSource, MRWaterFlowLayoutDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.footer.hidden = MRShops.count == 0
        
        return MRShops.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MRWaterFlowCellReuseIdentifier, forIndexPath: indexPath) as! MRShopCell
        
        cell.shop = MRShops[indexPath.item]
        
        return cell
    }
    
    func WaterFlowLayout(layout: MRWaterFlowLayout, heightForItemAtIndex index: NSInteger, withItemWidth itemWidth: CGFloat) -> CGFloat {
        
        let shop = MRShops[index]
        return itemWidth * (CGFloat(shop.h!) / CGFloat(shop.w!))
    }
    
    func columnCountInWaterFlowLayout(layout: MRWaterFlowLayout) -> NSInteger {
        
        return 4
    }
    
    func columnMarginInWaterFlowLayout(layout: MRWaterFlowLayout) -> CGFloat {
        return 5
    }
    
    func rowMarginInWaterFlowLayout(layout: MRWaterFlowLayout) -> CGFloat {
        return 10
    }
    
    func edgeInsetsInWaterFlowLayout(layout: MRWaterFlowLayout) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

class MRShopCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!

    var shop: MRShop! {
        didSet{
            
            imageView.sd_setImageWithURL(NSURL(string: shop.img!), placeholderImage: UIImage(named: "loading"))
            priceLabel.text = shop?.price
        }
    }
}

