//
//  AnimalViewModel.swift
//  GetAPartner
//
//  Created by 游宗翰 on 2016/9/20.
//  Copyright © 2016年 han. All rights reserved.
//

import UIKit

class AnimalViewModel: NSObject, NSCoding {
    
    var animal : Animal?
    
    // 數據處理
    var imageUrl : URL?
    var fieldArray = ["描述", "名字", "性別", "年齡", "品種", "收容編號", "絕育否", "毛色", "體型", "位置", "聯絡電話", "e-mail"]
    var valueArray : [String] = [String]()
    
    init(animal:Animal) {
        self.animal = animal
        
        let imageUrlString = animal.imageName ?? ""
        imageUrl = URL(string: imageUrlString)
        
        valueArray = [animal.note!, animal.name!, animal.sex!, animal.age!, animal.type!, animal.acceptNum!, animal.isSterilization!, animal.hairType!, animal.build!, animal.resettlement!, animal.phone!, animal.email!]
        
        
    }
    
    
    // MARK:- 讀檔＆寫檔
    /// 讀檔的方法
    required init?(coder aDecoder: NSCoder) {
        animal = aDecoder.decodeObject(forKey: "animal") as? Animal
        imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? URL
        fieldArray = (aDecoder.decodeObject(forKey: "fieldArray") as? [String])!
        valueArray = (aDecoder.decodeObject(forKey: "valueArray") as? [String])!
    }
    
    /// 寫檔方法
    func encode(with aCoder: NSCoder) {
        aCoder.encode(animal, forKey: "animal")
        aCoder.encode(imageUrl, forKey: "imageUrl")
        aCoder.encode(fieldArray, forKey: "fieldArray")
        aCoder.encode(valueArray, forKey: "valueArray")
    }
    
}
