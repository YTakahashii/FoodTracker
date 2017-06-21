//
//  MealViewController.swift
//  FoodTracker
//
//  Created by 高橋佑太 on 2017/05/25.
//  Copyright © 2017年 高橋佑太. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var meal: Meal?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameTextField.delegate = self
        updateSaveButtonState()
    }
    // MARK: Actions
    
    //画像選択画面に遷移する処理
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: Private Methods
    private func updateSaveButtonState() {
        //テキストフィールドがからのときSaveボタンを無効化する
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Doneを押すとキーボードが閉じる処理
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //テキストボックスに値を入れ終わったときに
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //テキスト編集してるとき
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false //Saveボタンを無効にする
    }
    
    //MARK: UIImagePickerControllerDelegate
    //画像選択がキャンセルされたとき
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil) //PickerControllerを終了する
    }
    
    //ユーザーが写真を選択すると呼び出される。選択した画像をimageViewに表示する
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        photoImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard  let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("Saveボタンは押されていません。キャンセルされました。", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        meal = Meal(name: name, photo: photo, rating: rating)
    }

}
