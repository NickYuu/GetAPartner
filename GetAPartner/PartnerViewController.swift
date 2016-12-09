//
//  PartnerViewController.swift
//  GetAPartner
//
//  Created by 游宗翰 on 2016/9/20.
//  Copyright © 2016年 han. All rights reserved.
//

import UIKit
import PMAlertController
import SVProgressHUD

class PartnerViewController: UIViewController {

    // MARK:- 屬性
    let fullSize = UIScreen.main.bounds.size
    fileprivate var allArray : [AnimalViewModel]?
    fileprivate var dogArray : [AnimalViewModel] = []
    fileprivate var catArray : [AnimalViewModel] = []
    fileprivate var otherArray : [AnimalViewModel] = []
    
    // MARK:- 延遲加載的屬性
    fileprivate lazy var viewModels : [AnimalViewModel] = [AnimalViewModel]()
    fileprivate lazy var textField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    fileprivate lazy var pickerView = UIPickerView()
    fileprivate lazy var picker = ["全部", "狗狗", "貓咪", "其他"]
    
    // MARK:- 元件的屬性
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- 系統調用的函式
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設置UI介面
        setupUI()
        
        // 載入數據
        loadAnimalData()
        
    }
    
    @IBAction func change(_ sender: AnyObject) {
        textField.becomeFirstResponder()
        tableView.isUserInteractionEnabled = false
    }
    
}
    
// MARK:- 設置UI介面相關
extension PartnerViewController {
    /// 設置UI介面
    fileprivate func setupUI() -> Void {
        
        
        
        title = "領養代替購買"
        tableView.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.2117647059, blue: 0.2352941176, alpha: 1)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        pickerView = UIPickerView(frame: CGRect(x: fullSize.width/4, y: fullSize.height-250, width: fullSize.width/2, height: 250))
        pickerView.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.2117647059, blue: 0.2352941176, alpha: 1)
        let pkImage = UIImageView(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: pickerView.frame.height))
        pkImage.image = UIImage(named: "picker")
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.addSubview(pkImage)
        view.addSubview(textField)
        
        textField.inputView = pickerView
        
        // 載入中提示
        SVProgressHUD.show(withStatus: "載入中")
        
        // 增加一個觸控事件
        let tap = UITapGestureRecognizer(
            target: self,
            action:
            #selector(PartnerViewController.hideKeyboard(tapG:)))
        tap.cancelsTouchesInView = false
        
        // 加在最基底的 self.view 上
        self.view.addGestureRecognizer(tap)
    }
    
    /// 網路異常提示框
    fileprivate func errAlert() {
        
        let alertVC = PMAlertController(title: "連線錯誤", description: "請檢查您的網路，稍後再試試。", image: UIImage(named: "1024px-Software-update-urgent.svg"), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "使用舊檔", style: .cancel, action: { () -> Void in
        }))
        
        alertVC.addAction(PMAlertAction(title: "再試一次", style: .default, action: { 
            self.loadAnimalData()
        }))
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
}

// MARK:- 事件監聽
extension PartnerViewController {
    // 按空白處會隱藏編輯狀態
    @objc fileprivate func hideKeyboard(tapG:UITapGestureRecognizer){
        self.view.endEditing(true)
        tableView.isUserInteractionEnabled = true
    }
}


// MARK:- 數據相關
extension PartnerViewController {
    
    /// 加載首頁數據
    fileprivate func loadAnimalData() {
        NetworkTools.shareInstance.loadAnimalData { (result, err) in
            if err != nil {
                
                // 錯誤提示框
                self.errAlert()
                
                let array = UserDefaults.standard.array(forKey: "animal")
                
                self.loadArray(array as! [[String : AnyObject]])
                
                return
            }
            guard let resultArray = result else {
                return
            }
            
            UserDefaults.standard.set(resultArray, forKey: "animal")
            UserDefaults.standard.synchronize()
            
            self.loadArray(resultArray)
            
        }
    }
    
    fileprivate func loadArray(_ resultArray:[[String:AnyObject]]) {
        
        viewModels = []
        dogArray = []
        catArray = []
        otherArray = []
        
        for animalDic in resultArray {
            let animal = Animal(dic: animalDic)
            
            let viewModel = AnimalViewModel(animal: animal)
            self.viewModels.append(viewModel)
            
            switch (viewModel.animal?.type)! {
            case "犬" : self.dogArray.append(viewModel)
            case "貓": self.catArray.append(viewModel)
            default : self.otherArray.append(viewModel)
            }
        }
        self.allArray = self.viewModels
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    /// 跳轉頁面傳送數據
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let controller = segue.destination as! DetailViewController
                
                controller.viewModel = viewModels[indexPath.row]
            }
        }
    }
}

// MARK:- tableView的DataSource和Delegate方法
extension PartnerViewController : UITableViewDataSource, UITableViewDelegate {
    
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

// MARK:- PickerView DataSource Delegate
extension PartnerViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int) -> Int {
        return picker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picker[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            viewModels = allArray!
            tableView.reloadData()
            // textField.resignFirstResponder()
        case 1:
            viewModels = dogArray
            tableView.reloadData()
            // textField.resignFirstResponder()
        case 2:
            viewModels = catArray
            tableView.reloadData()
            // textField.resignFirstResponder()
        case 3:
            viewModels = otherArray
            tableView.reloadData()
            // textField.resignFirstResponder()
        default:
            break
        }
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) ->  NSAttributedString? {
        return NSAttributedString(string: picker[row], attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
}

