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
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    var ratingButtons = [UIButton]()
    
    //@IBInspectableをつけたプロパティはストーリーボードで値を設定できるようになる
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
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
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false //ボタンの自動生成された制約を無効にします
            //ボタンをレイアウト内の固定サイズオブジェクト（44ポイント×44ポイント）として定義する
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true //高さを44に設定
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true //幅を44に設定
        
            //ボタンが押されたときの動作（メソッド）を登録する
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            //アクセシビリティラベルをセット
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            //ボタンをスタックに追加
            addArrangedSubview(button)
            
            //ボタンをratingButtons[]に格納
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    //MARK: Button Action
    func ratingButtonTapped(button: UIButton){
        
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // 現在のレーティングがタップされたら０にリセットする
            rating = 0
        } else {
            // その他がタップされたらそのレートにする
            rating = selectedRating
        }
        
    }
    
    private func updateButtonSelectionStates() {
        for(index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
            
            let hintString : String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            let valueString: String
            
            switch rating {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }

    }
}
