//
//  ContainerController.swift
//  Movies
//
//  Created by Giorgi on 3/6/21.
//

import UIKit

class ContainerController: UISplitViewController, UISplitViewControllerDelegate {
    
    //MARK: - Properties
    
    private let detailsNav = UINavigationController(rootViewController: MovieDetailsController())
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
    }
    
    //MARK: - Helpers
    
    private func configureUi() {
        let moviesController = MoviesController(isInSplitMode: true)
        moviesController.delegate = self
        let masterNav = UINavigationController(rootViewController: moviesController)
        self.viewControllers = [masterNav, detailsNav]
        self.preferredDisplayMode = .oneBesideSecondary
    }
}

//MARK: - MoviesControllerDelegate

extension ContainerController: MoviesControllerDelegate {
    func presentMovieDetailsController(withMovie movie: Movie) {
        detailsNav.popToRootViewController(animated: true)
        let controller = MovieDetailsController()
        controller.movie = movie
        detailsNav.pushViewController(controller, animated: true)
    }
}
