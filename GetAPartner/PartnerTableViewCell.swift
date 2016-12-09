//
//  PartnerTableViewCell.swift
//  
//
//  Created by 游宗翰 on 2016/9/20.
//
//

import UIKit
import SDWebImage

class PartnerTableViewCell: UITableViewCell {

    // MARK:- 元件的屬性
    @IBOutlet weak var PartnerImage: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var sexLB: UILabel!
    @IBOutlet weak var ageLB: UILabel!
    @IBOutlet weak var typeLB: UILabel!
    @IBOutlet weak var buildLB: UILabel!
    
    // MARK:- 自定的屬性
    var viewModel : AnimalViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            // PartnerImage
            PartnerImage.sd_setImage(with: viewModel.imageUrl, placeholderImage: #imageLiteral(resourceName: "notfound"))
            
            nameLB.text = checkString((viewModel.animal?.name) ?? "")
            sexLB.text = checkString((viewModel.animal?.sex) ?? "")
            ageLB.text = checkString((viewModel.animal?.age) ?? "")
            typeLB.text = checkString((viewModel.animal?.type) ?? "")
            buildLB.text = checkString((viewModel.animal?.build) ?? "")
            
        }
    }
    
    private func checkString(_ string:String) -> String {
        if string == "" {
            return "暫無資訊"
        }
        return string
    }
    

}
