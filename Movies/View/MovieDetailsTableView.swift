//
//  MovieDetailsTableView.swift
//  Movies
//
//  Created by Giorgi on 3/7/21.
//

import UIKit

private struct Consts {
    static let cellId: String = "DefaultCellId"
    static let posterCellId: String = "PosterCell"
    static let descriptionCellId: String = "DescriptionCell"
    static let SimilarMoviesCellId: String = "SimilarCell"
}

class MovieDetailsTableView: UIView {
    
    //MARK: - Properties
    
     var similarMovies = [SimilarMovie](){
        didSet {reloadTableView()}
    }
    
     var poster: UIImage? {
        didSet {reloadTableView()}
    }
    
     var movie: Movie? {
        didSet {reloadTableView()}
    }
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.contentSize = CGSize(width: self.frame.width, height: 1000)
        
        return tv
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureUI(){
        addSubview(tableView)
        tableView.fillSuperview()
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(PosterCell.self, forCellReuseIdentifier: Consts.posterCellId)
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: Consts.descriptionCellId)
        tableView.register(SimilarMoviesCell.self, forCellReuseIdentifier: Consts.SimilarMoviesCellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Consts.cellId)
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.tableView.reloadData()
        }
    }
}

//MARK: - TableViewDataSource

extension MovieDetailsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 3
   }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       switch indexPath.row {
       case 0:
           let cell = tableView.dequeueReusableCell(withIdentifier: Consts.posterCellId, for: indexPath) as! PosterCell
           cell.movie = self.movie
           cell.posterImage = poster
           return cell
       case 1:
           let cell = tableView.dequeueReusableCell(withIdentifier: Consts.descriptionCellId, for: indexPath) as! DescriptionCell
           cell.movie = self.movie
           return cell
       case 2:
           let cell = tableView.dequeueReusableCell(withIdentifier: Consts.SimilarMoviesCellId, for: indexPath) as! SimilarMoviesCell
           cell.movies = self.similarMovies
           return cell
       default:
           return tableView.dequeueReusableCell(withIdentifier: Consts.cellId, for: indexPath)
       }
   }
}

//MARK: - TableViewDataDelegate


extension MovieDetailsTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       switch indexPath.row{
       case 0:
           return 270
       case 1:
           return 200
       case 2:
           return 220
       default:
           return 0
       }
   }
}
