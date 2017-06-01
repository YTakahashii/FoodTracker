//
//  RatingControl.swift
//  FoodTracker
//
//  Created by 高橋佑太 on 2017/06/01.
//  Copyright © 2017年 高橋佑太. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    // MARK: Properties
    var rating = 0
    var ratingButtons = [UIButton]()
    
    //@IBInspectableをつけたプロパティはストーリーボードで値を設定できるようになる
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0)
    @IBInspectable var starCount: Int = 5
    
    //MARK: Initialization
    //コードから初期化する場合
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    //ストーリーボードから初期化する場合
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Private Methods
    private func setupButtons(){
        for _ in 0..<starCount {
            let button = UIButton()
            button.backgroundColor = UIColor.red
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false //ボタンの自動生成された制約を無効にします
            //ボタンをレイアウト内の固定サイズオブジェクト（44ポイント×44ポイント）として定義する
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true //高さを44に設定
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true //幅を44に設定
        
            //ボタンが押されたときの動作（メソッド）を登録する
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
        
            //ボタンをスタックに追加
            addArrangedSubview(button)
            
            //ボタンをratingButtons[]に格納
            ratingButtons.append(button)
        }
    }
    
    //MARK: Button Action
    func ratingButtonTapped(button: UIButton){
        print("Button pressed 👍")
    }
}
