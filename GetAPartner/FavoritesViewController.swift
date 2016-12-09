//
//  FavoritesViewController.swift
//  GetAPartner
//
//  Created by 游宗翰 on 2016/9/24.
//  Copyright © 2016年 han. All rights reserved.
//

import UIKit
import PMAlertController

class FavoritesViewController: UIViewController {

    // MARK:- 屬性
    var viewModels : [AnimalViewModel] = []
    var favoritePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/accout.plist"
    
    // MARK:- 元件屬性
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- 系統調用的函式
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    // MARK:- 跳轉頁面傳送數據
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let controller = segue.destination as! DetailViewController
                
                controller.viewModel = viewModels[indexPath.row]
            }
        }
    }
}

// UI相關 ＆ backButton
extension FavoritesViewController {
    
    fileprivate func setupUI() {
        title = "收藏列表"
        tableView.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.2117647059, blue: 0.2352941176, alpha: 1)
    }
    
    @IBAction func backBtn(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearAll(_ sender: AnyObject) {
        
        let alertVC = PMAlertController(title: "清除", description: "確定要清空您的收藏嗎？", image: UIImage(named: "Edit-clear"), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "確定", style: .default, action: {
            self.viewModels = []
            NSKeyedArchiver.archiveRootObject(self.viewModels, toFile: self.favoritePath)
            self.tableView.reloadData()
        }))
        
        alertVC.addAction(PMAlertAction(title: "取消", style: .cancel, action: {
        }))
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
}

// MARK:- 數據相關
extension FavoritesViewController {
    fileprivate func loadData() {
        viewModels = (NSKeyedUnarchiver.unarchiveObject(withFile: favoritePath) as? [AnimalViewModel]) ?? [AnimalViewModel]()
        // YULog(viewModels)
        tableView.reloadData()
    }
}


// MARK:- tableView的DataSource和Delegate方法
extension FavoritesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PartnerTableViewCell
        cell.backgroundColor = .clear
        let viewModel = viewModels[indexPath.row]
        cell.viewModel = viewModel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
