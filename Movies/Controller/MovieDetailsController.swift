//
//  MovieDetailsController.swift
//  Movies
//
//  Created by Giorgi on 3/6/21.
//

import UIKit

private struct Consts {
    static let baseUrl: String = "https://api.themoviedb.org/3/tv/"
    static let urlCompl: String = "/similar?api_key=b4b80be561969a8cfe50a0a795412960&language=en-US&page=1"
}

class MovieDetailsController: UIViewController {
    //MARK: - Properties
    
    private let service = Service.shared
    private let tableView = MovieDetailsTableView()
    var movie: Movie?

    //MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateView()
    }
    
    
    //MARK: - Api
    
    private func fetchSimilarMovies() {
        guard let movie = self.movie else {return}
        let url = Consts.baseUrl + String(movie.id) + Consts.urlCompl
        showLoader()
        service.fetchData(forUrl: url, decodingType: MovieItem.self) { result in
            self.removeLoader()
            switch result {
            case .success(let movieItem):
                
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {return}
                    if movieItem.results.count == 0 {
                        self.showMessage(withTitle: "Error", message: "No Results Found For Similar Shows", dissmissalText: "OK")
                    }
                    movieItem.results.forEach {
                        guard let url = $0.posterUrl else {return}
                        self.fetchImageData(path: url, title: $0.title, isForMainPoster: false)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {return}
                    self.showMessage(withTitle: "Error", message: "No Results Found For Similar Shows, \(error.localizedDescription)", dissmissalText: "OK")
                }
            }
        }
    }
    
    private func fetchImageData(path: String, title: String = "", isForMainPoster: Bool) {
        service.fetchData(posterPath: path) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {return}
                
                if isForMainPoster {
                    DispatchQueue.main.async {[weak self] in
                        guard let self = self else {return}
                        self.tableView.poster = image
                    }
                } else {
                    DispatchQueue.main.async {[weak self] in
                        guard let self = self else {return}
                        let similarMovie = SimilarMovie(title: title, image: image)
                        self.tableView.similarMovies.append(similarMovie)
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {return}
                    self.showMessage(withTitle: "Error", message: error.localizedDescription, dissmissalText: "Ok")
                }
            }
        }
    }
    
    //MARK: - helpers
    
    private func updateView() {
        if movie != nil {
            configureUI()
            fetchSimilarMovies()
            guard let path = movie?.posterUrl else {return}
            fetchImageData(path: path, isForMainPoster: true)
        } else {
            view.backgroundColor = .systemBackground
        }
    }

    private func configureUI() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.movie = movie
        view.backgroundColor = .white

    }
}



