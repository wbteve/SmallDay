//
//  SearchView.swift
//  SmallDay
//
//  Created by MacBook on 15/8/18.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  搜索控制器

import UIKit

class SearchView: UIView {
    /// 动画时长
    let animationDuration = 0.5
    var searchTextField: SearchTextField!
    var searchBtn: UIButton!
    /// 是否已经缩放过
    var isScale: Bool = false
    weak var delegate: SearchViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        searchTextField = SearchTextField()
        let margin: CGFloat = 20
        searchTextField.frame = CGRectMake(margin, 20 * 0.5, AppWidth - 2 * margin, 30)
        addSubview(searchTextField)
        
        searchBtn = UIButton()
        searchBtn.setTitle("搜索", forState: .Normal)
        searchBtn.setTitle("取消", forState: .Selected)
        searchBtn.titleLabel!.font = UIFont.systemFontOfSize(18)
        searchBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        searchBtn.setTitleColor(UIColor.blackColor(), forState: .Selected)
        searchBtn.alpha = 0
        searchBtn.titleLabel!.textAlignment = .Center
        searchBtn.frame = CGRectMake(AppWidth - 100, 0, 100, 50)
        searchBtn.addTarget(self, action: "searchBtnClick:", forControlEvents: .TouchUpInside)
        addSubview(searchBtn)
        
        // 监听键盘弹出
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillshow", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyBoardWillshow() {
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.searchBtn.alpha = 1
            self.searchBtn.selected = false
            if !self.isScale {
                self.searchTextField.frame.size.width = self.searchTextField.width - 60
                self.isScale = true
            }
        })
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.endEditing(true)
    }
    
    func resumeSearchTextField() {
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            if self.isScale {
                self.searchBtn.alpha = 0
                self.searchBtn.selected = false
                self.searchTextField.frame.size.width = self.searchTextField.width + 60
                self.isScale = false
            }
        })
    }
    
    func searchBtnClick(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            searchTextField.becomeFirstResponder()
        } else if searchTextField.text.isEmpty {
            return
        } else {
            sender.selected = true
            if delegate != nil {
                delegate!.searchView(self, searchTitle: searchTextField.text)
            }
        }
    }
}

protocol SearchViewDelegate: NSObjectProtocol {
    func searchView(searchView: SearchView, searchTitle: String)
}
