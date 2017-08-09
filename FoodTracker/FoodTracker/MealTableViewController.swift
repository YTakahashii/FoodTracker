//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by 高橋佑太 on 2017/06/19.
//  Copyright © 2017年 高橋佑太. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    //MARK: Properties
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //編集ビヘイビアが組み込まれた特殊なバーボタンを追加
        navigationItem.leftBarButtonItem = editButtonItem
        
        //保存されいる食べ物を読み込む
        if let saveMeals = loadMeals() {
            meals += saveMeals
        }else {
            //サンプルデータをロード
            loadSampleMeals()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    //セクション数を返す
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    //行数を返す
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let meal = meals[indexPath.row]
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }

    //MARK: Private Methods
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("正しく保存されました。", log: OSLog.default, type: .debug)
        } else {
            os_log("保存に失敗しました。", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal.init(name: "カプレーゼサラダ", photo: photo1, rating: 4) else {
            fatalError("meal1をインスタンス化できませんでした。")
        }
        
        guard let meal2 = Meal.init(name: "チキンとポテト", photo: photo2, rating: 5) else {
            fatalError("meal2をインスタンス化できませんでした。")
        }
        
        guard let meal3 = Meal.init(name: "ミートボールパスタ", photo: photo3, rating: 2) else {
            fatalError("meal3をインスタンス化できませんでした。")
        }
        
        meals += [meal1, meal2, meal3]
        
    }
    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue){

        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            //既存の食事を選択したら
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                //更新
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else{
                //新しく追加
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            //Save
            saveMeals()
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
            case "AddItem":
                os_log("食事追加画面", log: OSLog.default, type: .debug)
            case "ShowDetail":
                guard  let mealDetailViewController = segue.destination as? MealViewController else {
                    fatalError("予期せぬ遷移先です：\(segue.destination)")
                }
                guard  let selectedMealCell = sender as? MealTableViewCell else {
                    fatalError("予期せぬ送り先です")
                }
                guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                    fatalError("予期せぬ選択セルです")
                }
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
            default:
                fatalError("予期せぬセグエです")
        }
    }
}
