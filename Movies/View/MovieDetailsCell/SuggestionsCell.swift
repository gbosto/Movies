//
//  SuggestionsCell.swift
//  Movies
//
//  Created by Giorgi on 3/6/21.
//

import UIKit

class SuggestionsCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var movie: SimilarMovie? {
        didSet {configure()}
    }
    
    private let posterImageView: UIImageView = {
         let iv = UIImageView()
         iv.setDimensions(height: 120, width: 90)
         iv.layer.cornerRadius = 5
         iv.clipsToBounds = true
         iv.backgroundColor = .lightGray
         return iv
     }()
     
     private let titleLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont(name: Constants.font, size: 12)
         label.numberOfLines = 0
         label.lineBreakMode = .byWordWrapping
         label.textAlignment = .center
        
         return label
     }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .systemBackground
        addSubview(posterImageView)
        posterImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: posterImageView.bottomAnchor , left:leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    private func configure() {
        guard let movie = self.movie else {return}
        posterImageView.image = movie.image
        titleLabel.text = movie.title
    }
}
