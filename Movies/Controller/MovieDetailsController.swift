//
//  MovieDetailsController.swift
//  Movies
//
//  Created by Giorgi on 3/6/21.
//

import UIKit

class MovieDetailsController: UIViewController {
    //MARK: - Properties
    
    private let service = Service.shared
    private let tableView = MovieDetailsTableView()
    var movie: Movie?

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateView()
    }
    
    
    //MARK: - Api
    
    private func fetchSimilarShows() {
        guard let movie = self.movie else {return}
        let url = "https://api.themoviedb.org/3/tv/\(movie.id)/similar?api_key=b4b80be561969a8cfe50a0a795412960&language=en-US&page=1"
        startLoading()
        service.fetchData(forUrl: url, decodingType: MovieItem.self) { result in
            self.stopLoading()
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
                DispatchQueue.main.async {
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
                        self.tableView.mainPosterImage = image
                    }
                } else {
                    DispatchQueue.main.async {[weak self] in
                        guard let self = self else {return}
                        let similarMovie = SimilarMovie(title: title, image: image)
                        self.tableView.similarMovies.append(similarMovie)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - helpers
    
    private func updateView() {
        if movie != nil {
            configureUI(withMovie: movie!)
            fetchSimilarShows()
            guard let path = movie?.posterUrl else {return}
            fetchImageData(path: path, isForMainPoster: true)
        } else {
            view.backgroundColor = .systemBackground
        }
    }

    private func configureUI(withMovie movie: Movie) {
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.movie = movie
        view.backgroundColor = .white

    }
}



