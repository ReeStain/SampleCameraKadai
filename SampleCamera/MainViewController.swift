//
//  MainViewController.swift
//  SampleCamera
//
//  Created by om on 2019/04/25.
//  Copyright © 2019年 Rei Furuya. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,
UIImagePickerControllerDelegate, UINavigationControllerDelegate,FilterListViewControllerDelegate{
    var myImage: UIImage!
    var selectedIndex: Int = 0 //選択したフィルターの順番を保持しておく変数
    

    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var myLabel: UILabel!
    
    @IBAction func onCameraButtonTapped(_ sender: UIBarButtonItem) {
        let controller: UIAlertController =
            UIAlertController(title: "", message: "どの方法で写真を読み込みますか？", preferredStyle: UIAlertController.Style.actionSheet)
        //一つ目の選択肢
        controller.addAction(UIAlertAction(title: "写真を撮影する", style: UIAlertAction.Style.default, handler: {(action)in
            self.selectedCamera()
            
        }))
        
        //二つ目の選択肢
        controller.addAction(UIAlertAction(title: "カメラロールから読み込む" , style: UIAlertAction.Style.default, handler: {(action) in
            self.selectedLibrary()
            
        }))
        
        controller.addAction(UIAlertAction(title: "キャンセル" , style: UIAlertAction.Style.cancel, handler:nil))
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func selectedCamera(){
        //カメラを使用できるかチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            //UIImagePIckerControlelrのインスタンスを作成
            let picker:UIImagePickerController = UIImagePickerController()
            
            picker.sourceType = UIImagePickerController.SourceType.camera
            
            picker.delegate = self
            
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func selectedLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            //UIImagePickerControllerのインスタンスを生成
            let picker:UIImagePickerController = UIImagePickerController()
            
            //カメラロールから写真を読み込む
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            
            //UIImagePickerControllerDelegateを自身に設定
            picker.delegate = self
            //UIIImagePickerController(写真の読み込み画面)を表示
            self.present(picker,animated: true,completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        //撮影、選択写真のチェック
        if let editedImage: UIImage =
            info[.originalImage] as? UIImage{
            //UIIMageViewに画像をセット
            myImageView.image = editedImage
            //オリジナルデータせをセット
            myImage = editedImage
    
        }
        
        //新規で画像を読み込んだ場合、選択したフィルターの番号はリセット
        selectedIndex = 0
        
        //画像がきちんとほ表示されるようであれば、注意書きを消す
        if myImageView.image != nil{
            myLabel.isHidden = true
        }
        //UIImagePickerControllerを閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSaveButtonTapped(_ sender: UIBarButtonItem) {
        //UIImageWriteToSavedphotsoAlbumで画像を端末に保存する
        UIImageWriteToSavedPhotosAlbum(myImageView.image!, self, #selector(self.showResultSavedImage(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    //保存を試みた結果をダイアログ表示
    @objc func showResultSavedImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer){
        //表示するメッセージ用の変数を用意
        var title:String = "保存完了！"
        var message:String = "カメラロールに画像を保存しました"
        
        //保存が行えなかった場合にはエラーメッセージを表示
        if error != nil {
            title = "エラー"
            message = "保存に失敗しました。設定アプリでプライバシー設定を確認してください"
            
        }
        
        let controller: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        
    }
    
    @IBAction func onEditButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "MoveFilterListView",
                          sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func filterListViewController(_ controller: FilterListViewController, didSelectFilter filter: String, index: Int){
        //選択したフィルターの順番を保持しとく
        selectedIndex = index
        
        //フィルターを加工しない場合はオリジナルを表示する
        if filter.isEmpty {
            //選択した番号は０を入れる
            selectedIndex = 0
            //画像は保持しているオリジナル画像をセットする
            myImageView.image = myImage
            
            //処理はここで終了
            return
        }
        
        //フィルターを設定する
        let filter: CIFilter = CIFilter(name: filter)!
        
        //画像をCIImageへ変換
        let ciImage = CIImage(image: myImage!)!
        
        //CIImageフィルターを適用
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        //フィルターを適用した画像を出力できるかチェック
        if let filteredImage :CIImage = filter.outputImage{
            //コンテキストの準備
            let context = CIContext(options: nil)
            
            //CGImage作成
            let cgiImage = context.createCGImage(filteredImage, from: filteredImage.extent)
            
            //CGImageをUIImageへ変換
            //写真の向きを調整
            let image = UIImage(cgImage: cgiImage!, scale: UIScreen.main.scale,
                                orientation: myImage.imageOrientation)
            
            myImageView.image = image
        }
        
        
        
        
    }
    
    
    //Storyboardで設定した遷移時に実装されるメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        //年のため識別子をチェック
        if segue.identifier == "MoveFilterListView" {
            //遷移先のFilterListViewControllerのインスタンスを取得
            let controller: FilterListViewController = segue.destination as! FilterListViewController
            //デリゲート先をMainViewControllerに設定
            controller.delegate  = self

            //選択している番号を渡す
            controller.selectedIndex = selectedIndex
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
