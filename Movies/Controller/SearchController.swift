//
//  SearchController.swift
//  Movies
//
//  Created by Giorgi on 3/6/21.
//

import UIKit

private struct Consts {
    static let cellId   : String = "SearchCell"
    static let rowHeight : CGFloat = 140
}

protocol SearchControllerDelegate: class {
    func didTapCell(movie: Movie)
}

class SearchController: UITableViewController {
    
    //MARK: - Properties
    
    weak var delegate: SearchControllerDelegate?
    
    private lazy var header = SearchHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 65))
    private let service = Service.shared
    private var movies = [Movie]() {
        didSet {self.tableView.reloadData()}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - API
    
    private func fetchSerchResults(query: String) {
        let title = query.replacingOccurrences(of: " ", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)


        let url = "https://api.themoviedb.org/3/search/movie?api_key=b4b80be561969a8cfe50a0a795412960&language=en-US&query=\(title)&page=1&include_adult=true"
        startLoading()
        service.fetchData(forUrl: url, decodingType: SearchedMovieItem.self) { result in
            self.stopLoading()
            switch result {
            case .success(let movieItem):
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {return}
                    self.movies.removeAll()
                    self.movies = configureMoviesArray(searchedMovies: movieItem.results)
                    if self.movies.count == 0 {
                        self.showMessage(withTitle: "No Results Found", message: "Try Different Keywords", dissmissalText: "Ok")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showMessage(withTitle: "Error", message: error.localizedDescription, dissmissalText: "OK")
                }
            }
        }
    }
    
    private func fetchImageData(path: String, cell: UITableViewCell) {
        
        service.fetchData(posterPath: path) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    (cell as! MoviesCell).imageData = data
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        header.searchTextField.becomeFirstResponder()
        
        tableView.separatorStyle = .none
        tableView.tableHeaderView = header
        tableView.register(MoviesCell.self, forCellReuseIdentifier: Consts.cellId)
        tableView.rowHeight = Consts.rowHeight
        header.delegate = self
        header.searchTextField.delegate = self
        dismissKeyboard()
    }

}

    private func configureMoviesArray(searchedMovies: [SearchedMovie]) -> [Movie] {
        var movies = [Movie]()
        searchedMovies.forEach {
            let movie = Movie(releaseDate: $0.releaseDate,
                              title: $0.title,
                              language: $0.language,
                              posterUrl: $0.posterUrl ?? "" ,
                              rating: $0.rating,
                              description: $0.description,
                              id: $0.id)
            movies.append(movie)
        }
        return movies
    }

//MARK: - SearchControllerDelegate

extension SearchController: SearchHeaderDelegate {
    func header(_header: SearchHeader, wantsToSearchWithText text: String) {
        fetchSerchResults(query: text)
    }
}

//MARK: - TableViewDataSource

extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Consts.cellId, for: indexPath) as! MoviesCell
        let movie = movies[indexPath.row]
        if movie.posterUrl != nil {
        fetchImageData(path: movie.posterUrl!, cell: cell)
        }
        cell.movie = movie

        return cell
    }
}

//MARK: - TableViewDelegate

extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        guard let delegate = self.delegate else {return}
        delegate.didTapCell(movie: movie)
    }
}


//MARK: - UITextFieldDelegate

extension SearchController: UITextFieldDelegate {
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == header.searchTextField {
        guard let query = textField.text else {return false}
        self.fetchSerchResults(query: query)
    }
    return true
}
}
