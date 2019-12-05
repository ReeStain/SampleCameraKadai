//
//  FirstListViewController.swift
//  SampleCamera
//
//  Created by om on 2019/04/25.
//  Copyright © 2019年 Rei Furuya. All rights reserved.
//

import UIKit

protocol FilterListViewControllerDelegate: class    {
    func filterListViewController(_ controller: FilterListViewController, didSelectFilter filter:String, index:Int)
    
}

class FilterListViewController: UITableViewController {
    weak var delegate: FilterListViewControllerDelegate? = nil
    
//デリゲートを保存しておく変数
    var selectedIndex: Int = 0 //選択済みの番号を記憶しておく変数
    

    
    let filterList:[String] = ["",
                               "CIPhotoEffectChromer",
                               "CIPhotoEffectFade",
                               "CIPhotoEffectIndtant",
                               "CIPhotoEffectNoir",
                               "CIPhotoEffectProcess",
                               "CIPhotoEffectTonal",
                               "CIPhotoEffectTransfer",
                               "CISepiaTone",
                               "CIVignette",]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filterList.count
    }
    
 
    
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //フィルター名を取得
        var filtername = filterList[indexPath.row]
        
        //フィルター名がからの場合は「No Effect」と表示させる
        if filtername.isEmpty {
            filtername = "No Effect"
        }
        
        //セルにフィルター名を記載
        cell.textLabel?.text  = filtername
        

        

        //ここから追加
        //チェックを一旦外す
        cell.accessoryType = UITableViewCell.AccessoryType.none
        //選択されていた番号であれば、チェックを表示する
        if indexPath.row == selectedIndex{
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        
        //設定したセルを返す
        return cell
        
    }
    
    //UITableviewものいずれかのセルをタップした際の処理
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //デリゲートさきが正しく設定されているかのnil;チェック
        if let myDelegate = delegate {
            //設定されていたら、各情報を引数に渡してデリゲートメソッドを実行
            myDelegate.filterListViewController(self, didSelectFilter: filterList[indexPath.row], index: indexPath.row)
        }
        //前の画面(MainViewController)に戻る
        self.navigationController?.popViewController(animated: true)
    }
    
    

    }

    

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


