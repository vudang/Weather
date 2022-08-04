//
//  FontSizeView.swift
//  Weather
//
//  Created by Tony on 04/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FontSizeView: UIView {
    private let increaseFontButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "textformat.size.larger"), for: .normal)
        return button
    }()
    
    private let decreaseFontButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "textformat.size.smaller"), for: .normal)
        return button
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .darkGray
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.alpha = 0.1
        return view
    }()
    
    private let tapGesture = UITapGestureRecognizer()
    
    var increaseFont: Observable<Void> {
        return self.increaseFontButton.rx.tap.asObservable()
    }
    
    var decreaseFont: Observable<Void> {
        return self.decreaseFontButton.rx.tap.asObservable()
    }
    
    var dismissEvent: Observable<Void> {
        return tapGesture.rx.event
            .map({ _ -> Void in
                return ()
            })
            .asObservable()
    }
    
    init() {
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(backgroundView)
        self.addSubview(contentStackView)
        self.contentStackView.addArrangedSubview(decreaseFontButton)
        self.contentStackView.addArrangedSubview(increaseFontButton)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalToSuperview().offset(60)
            make.height.equalTo(60)
        }
        contentStackView.layer.cornerRadius = 10
        backgroundView.addGestureRecognizer(tapGesture)
    }
}
