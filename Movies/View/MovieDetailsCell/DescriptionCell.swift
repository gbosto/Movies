//
//  DescriptionCell.swift
//  Movies
//
//  Created by Giorgi on 3/6/21.
//

import UIKit

class DescriptionCell: UITableViewCell {
    
    //MARK: - Properties
    
    var movie: Movie? {
        didSet{configure()}
    }
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont(name: Constants.font, size: 22)
        
        return label
    }()
    
    private let descriptionView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = UIFont(name: Constants.font, size: 16)
        
        return tv
    }()

    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureUi() {
        selectionStyle = .none

        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 16)

        contentView.addSubview(descriptionView)
        descriptionView.anchor(top: descriptionLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,
                               paddingTop: 0, paddingLeft: 16, paddingRight: 16, height: 150)
    }
    
    private func configure() {
        guard let movie = self.movie else {return}
        descriptionView.text = movie.description
    }
}
