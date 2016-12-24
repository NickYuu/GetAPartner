//
//  DetailViewController.swift
//  GetAPartner
//
//  Created by 游宗翰 on 2016/9/21.
//  Copyright © 2016年 han. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    // MARK:- 屬性
    internal var viewModel : AnimalViewModel?
    fileprivate var favoritesArr : [AnimalViewModel] = []
    fileprivate var isFavorite = false
    let favoritePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/accout.plist"
    
    // MARK:- 元件屬性
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var favorites: UIButton!
    @IBOutlet weak var map: UIButton!
    @IBOutlet weak var mail: UIButton!
    @IBOutlet weak var phone: UIButton!
    @IBOutlet weak var share: UIButton!
    
    // MARK:- 系統呼叫函式
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 載入數據
        loadData()
        
        // 設置UI介面
        setupUI()
        
        // 改變button位置尺寸，用來做動畫
        buttonTransform()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 按鈕動畫
        buttonAnimal()
    }
    
    // 地圖轉場
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap"
        {
            let controller = segue.destination as! MapViewController
            controller.position = viewModel?.animal?.resettlement ?? ""
        }
    }
    
}

// MARK:- 設置UI介面相關
extension DetailViewController {
    /// 設置UI介面
    fileprivate func setupUI() -> Void {
        
        imageView.sd_setImage(with: viewModel?.imageUrl, placeholderImage: #imageLiteral(resourceName: "notfound"))
        
        title = viewModel?.animal?.name
        tableView.estimatedRowHeight = 36
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = #colorLiteral(red: 0.1956433058, green: 0.2113749981, blue: 0.2356699705, alpha: 1)
    }
    
    /// 按鈕動畫
    fileprivate func buttonAnimal() {
        doAnimate(time: 0, mybutton: favorites)
        doAnimate(time: 0.2, mybutton: map)
        doAnimate(time: 0.4, mybutton: mail)
        doAnimate(time: 0.6, mybutton: phone)
        doAnimate(time: 0.8, mybutton: share)
    }
}

// MARK:- 按鈕動作
extension DetailViewController {
    @IBAction func favorites(_ sender: UIButton) {
        sender.tintColor = favoriteClick()
    }
    
    @IBAction func sendMail(_ sender: UIButton) {
        mailClick()
        YULog("\((viewModel?.animal?.email)!)")
    }
    
    @IBAction func callPhone(_ sender: UIButton) {
        phoneClick()
        YULog("tel://\((viewModel?.animal?.phone)!)")
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        shareClick()
    }
}

// MARK:- 事件監聽
extension DetailViewController {
    
    /// mail按鈕點擊
    fileprivate func mailClick() {
        if viewModel?.animal?.email != "" {
            let email = "\((viewModel?.animal?.email)!)"
            let url = URL(string: "mailto:\(email)")
            UIApplication.shared.openURL(url!)
        }else{
            let alert = UIAlertController(title: "暫無資料", message: "目前沒有該單位email", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okBtn)
            present(alert, animated: true, completion: nil)
        }
    }
    
    /// phone按鈕點擊
    fileprivate func phoneClick() {
        if viewModel?.animal?.phone != ""
        {
            let url = URL(string: "tel://\((viewModel?.animal?.phone)!)")
            if url != nil{
                UIApplication.shared.openURL(url!)
            }
        }else{
            let alert = UIAlertController(title: "暫無資料", message: "目前沒有該單位電話", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okBtn)
            present(alert, animated: true, completion: nil)
        }
    }
    
    /// Share按鈕點擊
    fileprivate func shareClick() {
        let defaultText = "我發現 \(viewModel?.animal?.name), 開放認養拉～\n\((viewModel?.animal?.name))"
        let image = imageView.image
        let activityController = UIActivityViewController(activityItems: [defaultText, image!], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    // favorite按鈕點擊
    fileprivate func favoriteClick() -> UIColor {
        var color = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        if isFavorite{
            isFavorite = false
            
            for i in 0..<favoritesArr.count{
                if favoritesArr[i].imageUrl == self.viewModel?.imageUrl {
                    favoritesArr.remove(at: i)
                    break
                }
            }
        }else{
            isFavorite = true
            color = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            favoritesArr.append(viewModel!)
        }
        NSKeyedArchiver.archiveRootObject(favoritesArr, toFile: favoritePath)
        
        return color
    }
}

// MARK:- 數據相關
extension DetailViewController {
    fileprivate func loadData() {
        if let favoritesArr = (NSKeyedUnarchiver.unarchiveObject(withFile: favoritePath) as? [AnimalViewModel]) {
            self.favoritesArr = favoritesArr
        }
        // YULog(favoritesArr)
        
        for i in favoritesArr {
            if i.imageUrl == self.viewModel?.imageUrl {
                favorites.tintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                isFavorite = true
                break
            }
        }
    }
}

// MARK:- 動畫相關
extension DetailViewController {
    
    /// 改變位置
    fileprivate func buttonTransform() {
        let scale = CGAffineTransform(scaleX: 1.3, y: 1.3)
        let translate = CGAffineTransform(translationX: 0, y: 700)
        favorites.transform = scale.concatenating(translate)
        map.transform = scale.concatenating(translate)
        mail.transform = scale.concatenating(translate)
        phone.transform = scale.concatenating(translate)
        share.transform = scale.concatenating(translate)
    }
    
    /// 做動畫
    fileprivate func doAnimate(time:Double, mybutton:UIButton!){
        UIView.animate(withDuration: 0.8, delay: time, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            mybutton.transform = CGAffineTransform.identity
            }, completion: nil)
    }
}

// MARK:- tableView DataSource & Delegate
extension DetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    /// numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.fieldArray.count)!
    }
    
    /// cellForRowAtIndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DetailTableViewCell
        cell.backgroundColor = .clear
        cell.rowNum = indexPath.row
        cell.viewModel = viewModel
        
        return cell
    }
    
}
