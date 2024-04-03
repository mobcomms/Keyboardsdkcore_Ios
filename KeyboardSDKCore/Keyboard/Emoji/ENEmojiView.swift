//
//  ENEmojiView.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/06/14.
//

import Foundation
import UIKit


public protocol ENEmojiViewDelegate: AnyObject {
    func closeEmojiView(emojiVeiw:ENEmojiView)
}


public class ENEmojiView: UIView {
    
    let cellID: String = "ENEmojiViewCollectionCell"
    var keyboardTheme:ENKeyboardTheme = ENKeyboardTheme()
    let collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        return UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
    }()
    
    let emojiTitleLabel:UILabel = {
        let label = DHPaddedLabel()
        label.leftInset = 5.0
        label.rightInset = 5.0
        label.topInset = 0.0
        label.bottomInset = 0.0
        
        label.text = "smilels & people"
        
        label.textColor = ENKeyboardThemeManager.shared.loadedTheme?.themeColors.key_text
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        
        return label
    }()
    
    public let returnKeyboardButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("ABC", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        button.setTitleColor(ENKeyboardThemeManager.shared.loadedTheme?.themeColors.key_text, for: .normal)
        
        return button
    }()
    
    let backspaceButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let image = UIImage.init(named: "aikbd_btn_keyboard_delete", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = ENKeyboardThemeManager.shared.loadedTheme?.themeColors.key_text
        button.setTitle("", for: .normal)
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    
    let buttonRootView:UIView = UIView()
    
    
    
    var emojiList:[ENEmoji] = []
    
    public var proxy:UITextDocumentProxy? = nil
    public weak var delegate:ENEmojiViewDelegate? = nil
    
    public var customTextField:UITextField? = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        emojiList.removeAll()
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(ENEmojiViewCell.self, forCellWithReuseIdentifier: cellID)
        self.collectionView.contentInset = UIEdgeInsets.init(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        
        emojiTitleLabel.backgroundColor = .clear
        
        self.addSubview(emojiTitleLabel)
        self.addSubview(collectionView)
        self.addSubview(buttonRootView)
        
        emojiTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        buttonRootView.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutConstraints:[NSLayoutConstraint] = []
        let views: [String: Any] = [
            "emojiTitleLabel":emojiTitleLabel,
            "collectionView": collectionView,
            "buttonRootView": buttonRootView
        ]
        
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[emojiTitleLabel]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[buttonRootView]|", metrics: nil, views: views)
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-1-[emojiTitleLabel(18)]-0-[collectionView]-0-[buttonRootView(39)]|", metrics: nil, views: views)
        
        NSLayoutConstraint.activate(layoutConstraints)
        self.backgroundColor = ENKeyboardThemeManager.shared.loadedTheme?.themeColors.tab_off
        self.emojiTitleLabel.backgroundColor = .clear //.white
        self.collectionView.backgroundColor = .clear //.white
        self.buttonRootView.backgroundColor = .clear //UIColor.init(white: 0.8, alpha: 1.0)
        
        initCategoryButtons()
    }
    
    public func setUpWith(emoji:ENEmojiCategory = .smileys) {
        emojiTitleLabel.text = emoji.title
        
        self.emojiList.removeAll()
        self.emojiList.append(contentsOf: emoji.emojis)
        
        
        self.collectionView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 1, height: 1), animated: false)
        collectionView.reloadData()
    }
    
    
    func initCategoryButtons() {
        returnKeyboardButton.addTarget(self, action: #selector(returnToKeyboardButtonClicked), for: .touchUpInside)
        backspaceButton.addTarget(self, action: #selector(backspaceButtonClicked), for: .touchUpInside)
        
        let stackView:UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        stackView.alignment = .fill
        
        let categories: [ENEmojiCategory] = ENEmojiCategory.all.filter { $0.emojis.count > 0 }
        for category in categories {
            let button = UIButton.init(frame: .zero)
            button.setTitle(category.fallbackDisplayEmoji.char, for: .normal)
            button.addTarget(self, action: #selector(categoryButtonClicked(sender:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
        }
        
        buttonRootView.addSubview(returnKeyboardButton)
        buttonRootView.addSubview(stackView)
        buttonRootView.addSubview(backspaceButton)
        
        returnKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        backspaceButton.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutConstraints:[NSLayoutConstraint] = []
        let views: [String: Any] = [
            "stackView":stackView,
            "returnKeyboardButton": returnKeyboardButton,
            "backspaceButton": backspaceButton
        ]
        
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[returnKeyboardButton]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[backspaceButton]|", metrics: nil, views: views)
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[returnKeyboardButton(35)]-2-[stackView]-2-[backspaceButton(35)]|", metrics: nil, views: views)
        
        NSLayoutConstraint.activate(layoutConstraints)
        
    }
}



//MARK:- Actions

extension ENEmojiView {
    
    @objc func returnToKeyboardButtonClicked() {
        delegate?.closeEmojiView(emojiVeiw: self)
    }
    
    
    @objc func backspaceButtonClicked() {
        if let _ = customTextField {
            customTextField?.deleteBackward()
        }
        else {
            self.proxy?.deleteBackward()
        }
        
    }
    
    
    @objc func categoryButtonClicked(sender: UIButton) {
        let selectedTitle = sender.title(for: .normal)
        let selectedCategorys: [ENEmojiCategory] = ENEmojiCategory.all.filter { $0.fallbackDisplayEmoji.char == selectedTitle }
        
        if selectedCategorys.count > 0 {
            let category = selectedCategorys[0]
            self.setUpWith(emoji: category)
        }
    }
}



//MARK:- Collection View Delegates
extension ENEmojiView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? ENEmojiViewCell
        cell?.setEmoji(emoji: emojiList[indexPath.row])
        
        return cell ?? UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = emojiList[indexPath.row]
        let input = emoji.char
        
        if let _ = customTextField {
            customTextField?.insertText(String(input))
        }
        else {
            proxy?.insertText(String(input))
        }
        
        ENEmojiCategory.frequentEmojiProvider.registerEmoji(emoji)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 35.0, height: 35.0)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? ENEmojiViewCell)?.clearText()
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? ENEmojiViewCell)?.setEmoji(emoji: (emojiList[indexPath.row]))
    }
}




public class ENEmojiViewCell: UICollectionViewCell {
    
    var textlayer: CATextLayer? = nil
    var imageView:UIImageView? = nil
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
    }
    
    func setEmoji(emoji: ENEmoji?){
        clearText()
        
        if textlayer == nil {
            textlayer = CATextLayer.init()
            textlayer?.frame = self.bounds
            textlayer?.alignmentMode = .center
            textlayer?.fontSize = 30.0
            textlayer?.contentsScale = UIScreen.main.scale

            self.layer.addSublayer(textlayer!)
        }

        textlayer?.string = emoji?.char
    }
    
    func clearText() {
        textlayer?.string = ""
        textlayer?.removeFromSuperlayer()
        textlayer = nil
    }
}
