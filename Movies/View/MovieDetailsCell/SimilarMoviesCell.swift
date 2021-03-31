//
//  SimilarMoviesCell.swift
//  Movies
//
//  Created by Giorgi on 3/6/21.
//

import UIKit

private struct Consts {
    static let suggestionsCellId = "SuggestionCell"
}

class SimilarMoviesCell: UITableViewCell {
    
    //MARK: - Properties
    
    var movies = [SimilarMovie]() {
        didSet{reloadCollectionView()}
    }
    
    private let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .horizontal
       let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
       cv.register(SuggestionsCell.self, forCellWithReuseIdentifier: Consts.suggestionsCellId)
       cv.backgroundColor = .systemBackground
       
       return cv
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
        contentView.addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor,
                              right: rightAnchor, paddingLeft: 16, paddingRight: 16)
        collectionView.dataSource = self
        collectionView.delegate = self
        selectionStyle = .none
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.collectionView.reloadData()
        }
    }
}

extension SimilarMoviesCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Consts.suggestionsCellId, for: indexPath) as! SuggestionsCell
        let similarMovie = movies[indexPath.row]
        cell.movie = similarMovie
        
        return cell
    }
}
