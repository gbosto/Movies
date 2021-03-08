//
//  MoviesController.swift
//  Movies
//
//  Created by Giorgi on 3/6/21.
//

import UIKit

protocol MoviesControllerDelegate: class {
    func didTapAt(movie: Movie)
    func presentMovieDetailsController(withMovie movie: Movie)
}

private struct Consts {
    static let cellId: String = "MoviesCell"
    static let rowHeight: CGFloat = 140
    static let baseUrl: String = "https://api.themoviedb.org/3/tv/popular?api_key=b4b80be561969a8cfe50a0a795412960&language=en-US&page="
}

class MoviesController: UITableViewController {
    
    //MARK: - Properties
    
    weak var delegate: MoviesControllerDelegate?
    private let service = Service.shared
    private let isInSplitMode: Bool
    private var page = 0
    private var searchedMovie: Movie? {
        didSet {presentMovieDetailsController()}
    }
    private var movies = [Movie]() {
        didSet {tableView.reloadData()}
    }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    init(isInSplitMode: Bool) {
        self.isInSplitMode = isInSplitMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    
    private func fetchMovies() {
        page += 1
        let url = Consts.baseUrl + String(page)
        service.fetchData(forUrl: url, decodingType: MovieItem.self, pagination: true) { result in
            DispatchQueue.main.async {
                self.tableView.tableFooterView = nil
            }
            switch result {
            case .success(let movieItem):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.clearMoviesArray()
                    self.movies.append(contentsOf: movieItem.results)
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {return}
                    self.showMessage(withTitle: "Error", message: error.localizedDescription, dissmissalText: "Ok")
                }
            }
        }
    }
    
    private func fetchImageData(_ path: String, forCell cell: UITableViewCell) {
        service.fetchData(posterPath: path) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    (cell as! MoviesCell).imageData = data
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - helpers

    private func configureUI() {
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                           style: .plain, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = searchButton
        
        
        tableView.register(MoviesCell.self, forCellReuseIdentifier: Consts.cellId)
        tableView.rowHeight = Consts.rowHeight
        tableView.separatorStyle = .none
    }
    
    private func presentMovieDetailsController() {
        guard let movie = self.searchedMovie else { return }
        delegate?.presentMovieDetailsController(withMovie: movie)
    }
    
    private func createFooter() -> UIView {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footer.center
        footer.addSubview(spinner)
        spinner.startAnimating()
        
        return footer
    }
    
    private func fetchImages(forCell cell: UITableViewCell, _ posterUrl: String?) {
        guard let posterUrl = posterUrl else {return}
        fetchImageData(posterUrl, forCell: cell)
    }
    
    private func clearMoviesArray() {
        if self.movies.count > 200 {
            self.movies.removeAll()
        }
    }
    
    //MARK: - Actions
    
    @objc private func searchButtonTapped() {
        let controller = SearchController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - TableViewDataSource

extension MoviesController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Consts.cellId, for: indexPath) as! MoviesCell
        let movie = movies[indexPath.row]
        cell.movie = movie
        fetchImages(forCell: cell, movie.posterUrl)
        return cell
    }
}

//MARK: - TableViewDelegate

extension MoviesController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        if isInSplitMode {
            guard let delegate = delegate else {return}
            delegate.didTapAt(movie: movie)
        } else {
            let controller = MovieDetailsController()
            controller.movie = movie
            navigationController?.pushViewController(controller, animated: true)
        }
    }
  
}

//MARK: - UIScrollViewDelegate

extension MoviesController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 50 - scrollView.frame.size.height) {
            guard !service.isPaginating else {return}
            self.tableView.tableFooterView = createFooter()
            fetchMovies()
        }
    }
}

//MARK: - SearchControllerDelegate

extension MoviesController: SearchControllerDelegate {
    func didTapCell(movie: Movie) {
        navigationController?.popViewController(animated: true)
        self.searchedMovie = movie
        if !isInSplitMode {
            let controller = MovieDetailsController()
            controller.movie = movie
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
