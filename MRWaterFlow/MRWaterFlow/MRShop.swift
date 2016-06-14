//
//  MRShop.swift
//  MRWaterFlow
//
//  Created by 乐浩 on 16/6/13.
//  Copyright © 2016年 乐浩. All rights reserved.
//

import UIKit

class MRShop: NSObject {
    
    var w: NSNumber?
    var h: NSNumber?
    var img: String?
    var price: String?
    
    //将字典数组转换为模型数组
    class func dictsToModels(list: [[String: AnyObject]]) -> [MRShop] {
        var models = [MRShop]()
        for dict in list {
            //MRStatus(dict: dict) 一个模型 会调用init(dict:[String: AnyObject])这个方法
            models.append(MRShop(dict: dict))
        }
        return models
    }
    
    
    //字典转模型
    init(dict:[String: AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    //用kvc，要求value和key一一对应，当遇到key不对应的时候 调用这个方法
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
