//
//  PosterCell.swift
//  Movies
//
//  Created by Giorgi on 3/6/21.
//

import UIKit

class PosterCell: UITableViewCell {
    
    //MARK: - Properties
    
    var movie: Movie? {
        didSet {
            configure()
        }
    }
    
    var posterImage: UIImage? {
        didSet {setImage()}
    }
    
    private let posterImageView: UIImageView = {
         let iv = UIImageView()
         iv.backgroundColor = .lightGray
         iv.setDimensions(height: 240, width: 180)
         iv.clipsToBounds = true
         iv.layer.cornerRadius = 5

         return iv
     }()
     
     private let titleLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont(name: Constants.font, size: 24)
         label.lineBreakMode = .byWordWrapping
         label.numberOfLines = 0

         return label
     }()
     
     private let releaseDateLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont(name: Constants.font, size: 16)
         label.numberOfLines = 0
         label.lineBreakMode = .byWordWrapping

         return label
     }()
     
     private let languageLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont(name: Constants.font, size: 16)
         
         return label
     }()
     
     private let ratingLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont(name: Constants.font, size: 16)
         
         return label
     }()

    
    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUi()
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureUi() {
        addSubview(posterImageView)
        posterImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        let stack = configureStack()
        addSubview(stack)
        stack.anchor(top: safeAreaLayoutGuide.topAnchor, left: posterImageView.rightAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 8)
        
    }
    
    private func configureStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [titleLabel, releaseDateLabel, languageLabel, ratingLabel])
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.spacing = 8
        
        return stack
    }
    
    private func configure() {
        guard let movie = self.movie else {return}
        titleLabel.text = movie.title
        languageLabel.text = "Language: " + movie.language
        ratingLabel.text = "Rating: " + String(movie.rating)
        let releaseDate = movie.releaseDate
        releaseDateLabel.text = "Release Date: " + releaseDate.replacingOccurrences(of: "-", with: ".")
    }
    
    private func setImage() {
        guard let posterImage = self.posterImage else {return}
        posterImageView.image = posterImage
    }
}
