//
//  DetailTableViewCell.swift
//  GetAPartner
//
//  Created by 游宗翰 on 2016/9/21.
//  Copyright © 2016年 han. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldLB: UILabel!
    @IBOutlet weak var valueLB: UILabel!
    
    var rowNum : Int = 0
    
    var viewModel : AnimalViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            
            fieldLB.text = checkString(viewModel.fieldArray[rowNum])
            valueLB.text = checkString(viewModel.valueArray[rowNum])
            // YULog(viewModel.fieldArray[rowNum])
        }
    }
    
    private func checkString(_ string:String) -> String {
        if string == "" {
            return "暫無資訊"
        }
        return string
    }

}
