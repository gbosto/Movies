//
//  TableViewHeader.swift
//  Movies
//
//  Created by Giorgi on 3/6/21.
//

import UIKit

protocol SearchHeaderDelegate: class {
    func header(_header: SearchHeader, wantsToSearchWithText text: String)
}

class SearchHeader: UIView {
    
    //MARK: - Properties
    
    weak var delegate: SearchHeaderDelegate?
    
     let searchTextField: UITextField = {
        let tf = UITextField()
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        tf.leftView = spacer
        tf.leftViewMode = .always
        tf.enablesReturnKeyAutomatically = true
        tf.returnKeyType = .search
        
        tf.borderStyle = .roundedRect
        tf.placeholder = "Search for a Movie"
        
        return tf
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
       return button
    }()
    
    //MARK: - Lyfecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        addSubview(searchTextField)
        searchTextField.centerY(inView: self)
        searchTextField.anchor(left: leftAnchor, paddingLeft: 16 )
        addSubview(searchButton)
        searchButton.centerY(inView: searchTextField)
        searchButton.setDimensions(height: 30, width: 30)
        searchButton.anchor(left: searchTextField.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
    }
    
    //MARK: - Actions
    
    @objc private func didTapButton() {
        guard let delegate = self.delegate else {return}
        guard let text = searchTextField.text else {return}
        delegate.header(_header: self, wantsToSearchWithText: text)
    }
}
