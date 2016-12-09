//
//  Animal.swift
//  GetAPartner
//
//  Created by 游宗翰 on 2016/9/20.
//  Copyright © 2016年 han. All rights reserved.
//

import UIKit

class Animal: NSObject, NSCoding {
    
    // MARK:- 屬性
    var name : String?
    var sex : String?
    var type : String?
    var build : String?
    var age : String?
    var imageName : String?
    var note : String?
    var variety : String?
    var acceptNum : String?
    var isSterilization : String?
    var hairType : String?
    var resettlement : String?
    var phone : String?
    var email : String?
    
    // 自定構造函式
    init(dic:[String:Any]) {
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    // MARK:- 讀檔＆寫檔
    /// 讀檔的方法
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        sex = aDecoder.decodeObject(forKey: "sex") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        build = aDecoder.decodeObject(forKey: "build") as? String
        age = aDecoder.decodeObject(forKey: "age") as? String
        imageName = aDecoder.decodeObject(forKey: "imageName") as? String
        note = aDecoder.decodeObject(forKey: "note") as? String
        variety = aDecoder.decodeObject(forKey: "variety") as? String
        acceptNum = aDecoder.decodeObject(forKey: "acceptNum") as? String
        isSterilization = aDecoder.decodeObject(forKey: "isSterilization") as? String
        hairType = aDecoder.decodeObject(forKey: "hairType") as? String
        resettlement = aDecoder.decodeObject(forKey: "resettlement") as? String
        phone = aDecoder.decodeObject(forKey: "phone") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
    }
    
    /// 寫檔方法
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(sex, forKey: "sex")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(build, forKey: "build")
        aCoder.encode(age, forKey: "age")
        aCoder.encode(imageName, forKey: "imageName")
        aCoder.encode(note, forKey: "note")
        aCoder.encode(variety, forKey: "variety")
        aCoder.encode(acceptNum, forKey: "acceptNum")
        aCoder.encode(isSterilization, forKey: "isSterilization")
        aCoder.encode(hairType, forKey: "hairType")
        aCoder.encode(resettlement, forKey: "resettlement")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(email, forKey: "email")
    }
}
