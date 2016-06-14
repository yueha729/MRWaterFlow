//
//  MRWaterFlowLayout.swift
//  MRWaterFlow
//
//  Created by 乐浩 on 16/6/13.
//  Copyright © 2016年 乐浩. All rights reserved.
//

import UIKit

@objc
protocol MRWaterFlowLayoutDelegate: NSObjectProtocol {
    
    /**
     *  返回图片的高度
     *  @param width  cell 的宽度
     */
    func WaterFlowLayout(layout: MRWaterFlowLayout, heightForItemAtIndex index: NSInteger, withItemWidth itemWidth: CGFloat) -> CGFloat
    
    /**
     *  返回列数
     */
    optional func columnCountInWaterFlowLayout(layout: MRWaterFlowLayout) -> NSInteger
    
    /**
     *  返回每列之间的间距
     */
    optional func columnMarginInWaterFlowLayout(layout: MRWaterFlowLayout) -> CGFloat
    
    /**
     *  返回每行之间的间距
     */
    optional func rowMarginInWaterFlowLayout(layout: MRWaterFlowLayout) -> CGFloat
    
    /**
     *  返回边缘间距
     */
    optional func edgeInsetsInWaterFlowLayout(layout: MRWaterFlowLayout) -> UIEdgeInsets
    
}

class MRWaterFlowLayout: UICollectionViewLayout {
    
    weak var WaterFlowLayoutDelegate: MRWaterFlowLayoutDelegate?
    
    //内容的高度
    var contentHeight: CGFloat?
//    let columnCount = 3
    var columnCount: NSInteger {
        
        return WaterFlowLayoutDelegate!.columnCountInWaterFlowLayout!(self)

    }
    
//    let rowMargin = 10
    var rowMargin: CGFloat {
        
        return WaterFlowLayoutDelegate!.rowMarginInWaterFlowLayout!(self)
    }
    
//    let columnMargin = 10
    var columnMargin: CGFloat {
        
        return WaterFlowLayoutDelegate!.columnMarginInWaterFlowLayout!(self)
    }

//    let edgInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var edgInsets: UIEdgeInsets {
        
        return WaterFlowLayoutDelegate!.edgeInsetsInWaterFlowLayout!(self)
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        contentHeight = 0
        
        //清楚之前计算的所有高度
        columnHeights.removeAll()
        
        for _ in 0..<columnCount {
           columnHeights.append(edgInsets.top)
        }
        
        //清除之前所有的布局属性
        attrsArray.removeAll()
        
        //返回一组中有多少个
        let count: NSInteger = (collectionView?.numberOfItemsInSection(0))!
        
        //获取indexPath位置cell对应的布局属性
        for i in 0..<count {
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            let attrs = layoutAttributesForItemAtIndexPath(indexPath)!
            attrsArray.append(attrs)
        }
    }
    
    // 决定cell的布局
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attrsArray
    }
    
    // 返回indexPath位置cell对应的的布局属性
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        // 创建布局属性
        let attrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        // collectionView的宽度
        let collectionViewW = collectionView?.frame.size.width
        
        // 设置布局属性的frame
        let W = (collectionViewW! - edgInsets.left - edgInsets.right - CGFloat((columnCount - 1)) * CGFloat(columnMargin)) / CGFloat(columnCount)
        
        let H = WaterFlowLayoutDelegate!.WaterFlowLayout(self, heightForItemAtIndex: indexPath.item, withItemWidth: W)
        
        //找出高度最短的那一列
        var destColmun = 0
        var minColmunHeight = columnHeights[0]
        
        for i in 1..<columnCount {
            
            //获取第i列的高度
            let colmunHeight = columnHeights[i]
            
            if minColmunHeight > colmunHeight {
                minColmunHeight = colmunHeight
                destColmun = i
            }
        }
        
        let X = edgInsets.left + CGFloat(destColmun) * (W + CGFloat(columnMargin))
        var Y = minColmunHeight
        
        if Y != edgInsets.top {
            Y += CGFloat(rowMargin)
        }
        
        attrs.frame = CGRectMake(X, Y, W, H)
        
        //更新队短那列的高度
        columnHeights[destColmun] = CGRectGetMaxY(attrs.frame)
        
        //记录内容的高度
        let colmunHeight = columnHeights[destColmun]
        
        if contentHeight < colmunHeight {
            contentHeight = colmunHeight
        }
        
        return attrs
    }
    
    override func collectionViewContentSize() -> CGSize {
        
        return CGSizeMake(0, contentHeight! + edgInsets.bottom)
    }
    
    //MARK: - 懒加载
    //存放所有cell的布局属性
    private lazy var attrsArray: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    //存放所有列的当前高度
    private lazy var columnHeights: [CGFloat] = [CGFloat]()

}


