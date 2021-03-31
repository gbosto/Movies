//
//  MovieCell.swift
//  Movies
//
//  Created by Giorgi on 3/6/21.
//

import UIKit

class MoviesCell: UITableViewCell {
    
    //MARK: - Properties

    var imageData: Data? {
        didSet {setImage()}
    }
    
    var movie: Movie? {
        didSet {configureCell()}
    }

   private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.setDimensions(height: 120, width: 90)
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.font, size: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.font, size: 14)
        
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.font, size: 14)
        
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.font, size: 14)
        
        return label
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
        addSubview(posterImageView)
        posterImageView.centerY(inView: self)
        posterImageView.anchor(left: leftAnchor, paddingLeft: 16)
        
        let stack = configureStack()
        addSubview(stack)
        stack.anchor(top: topAnchor, left: posterImageView.rightAnchor, right: rightAnchor,
                     paddingTop: 4, paddingLeft: 12, paddingRight: 12)
    }
    
    private func configureStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [titleLabel, releaseDateLabel, languageLabel, ratingLabel])
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.spacing = 8
        
        return stack
    }
    
    private func configureCell() {
        guard let movie = self.movie else {return}
        titleLabel.text = movie.title
        ratingLabel.text = "Rating: " + String(movie.rating)
        languageLabel.text = "Language: " + movie.language
        releaseDateLabel.text = "Release Year: " + String(movie.releaseDate.dropLast(6))
    }
    
    private func setImage() {
        guard let data = self.imageData else {return}
        let image = UIImage(data: data)
        posterImageView.image = image
    }
}

