//
//  ViewController.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 23.10.2023.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var navigationTitle: UINavigationItem!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var tabeView: UITableView!

    var homePresenter: HomePresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomCells()
        checkInternetConnectionAndProceed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    func setupUI() {
        searchBar.placeholder = "Search".localized()
        navigationTitle.title = "Popular Movies".localized()
    }
}

extension HomeViewController: HomeViewProtocol {

    func reloadTableView() {
        tabeView.reloadData()
    }

    func startLoading() {
        //loader logic
    }

    func finishLoading() {
        //loader logic
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setMoviesCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = setMovieModelForCell(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.id) as! MovieTableViewCell
        cell.setupUI(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = setMovieModelForCell(index: indexPath.row)
        moveToDetails(movie: model)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        fetchNextPageMovies(index: indexPath.row)
    }
}

extension HomeViewController {
    func checkInternetConnectionAndProceed() {
        guard let homePresenter = homePresenter else { return }
        homePresenter.handleInternetConnection()
    }
    
    func setMoviesCount() -> Int {
        guard let homePresenter = homePresenter else { return 0 }
        return homePresenter.setMoviesCount()
    }
    
    func setMovieModelForCell(index: Int) -> MovieViewModel {
        guard let homePresenter = homePresenter else {
            return MovieViewModel(
                id: 0,
                genres: [],
                overview: "",
                posterPath: "",
                releaseDate: "",
                title: "",
                video: false,
                voteAverage: 0.0
            )
        }
        return homePresenter.setMovieModel(index: index)
    }
    
    func fetchNextPageMovies(index: Int) {
        guard let homePresenter = homePresenter else { return }
        homePresenter.fetchNextPageMovies(index: index)
    }
    
    func moveToDetails(movie: MovieViewModel) {
        guard let homePresenter = homePresenter else { return }
        homePresenter.showDetail(movie: movie)
    }

    func registerCustomCells() {
        tabeView.register(
            MovieTableViewCell.nib,
            forCellReuseIdentifier: MovieTableViewCell.id
        )
    }
}
