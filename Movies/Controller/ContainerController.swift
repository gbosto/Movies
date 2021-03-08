//
//  ContainerController.swift
//  Movies
//
//  Created by Giorgi on 3/6/21.
//

import UIKit

class ContainerController: UISplitViewController, UISplitViewControllerDelegate {
    
    //MARK: - Properties
    
    private let moviesController = MoviesController(isInSplitMode: true)
    private lazy var masterNav = UINavigationController(rootViewController: moviesController)
    private let detailsNav = UINavigationController(rootViewController: MovieDetailsController())
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
    }
    
    //MARK: - Helpers
    
    private func configureUi() {
        moviesController.delegate = self
        self.viewControllers = [masterNav, detailsNav]
        self.preferredDisplayMode = .oneBesideSecondary
    }
    
    private func presentDetailsViewController(withMovie movie: Movie) {
        detailsNav.popToRootViewController(animated: true)
        let controller = MovieDetailsController()
        controller.movie = movie
        
        detailsNav.pushViewController(controller, animated: true)
    }
}

//MARK: - MoviesControllerDelegate

extension ContainerController: MoviesControllerDelegate {
    func didTapAt(movie: Movie) {
        presentDetailsViewController(withMovie: movie)
    }
    
    func presentMovieDetailsController(withMovie movie: Movie) {
        presentDetailsViewController(withMovie: movie)
    }
}
