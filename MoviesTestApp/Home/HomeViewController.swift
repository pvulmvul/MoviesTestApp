//
//  ViewController.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 23.10.2023.
//

import UIKit
import Lottie

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var navigationTitle: UINavigationItem!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var loaderView: UIView!
    @IBOutlet private weak var lottieLoader: LottieAnimationView!
    @IBOutlet private weak var sortingButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    var homePresenter: HomePresenterProtocol?
    lazy var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomCells()
        fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI() {
        tableView.backgroundView = refreshControl
        sortingButton.setTitle("Sorting".localized(), for: .normal)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        searchBar.placeholder = "Search".localized()
        navigationTitle.title = "Popular Movies".localized()
        lottieLoader.loopMode = .loop
    }
    
    @IBAction func sortingButtonPressed(_ sender: Any) {
        guard let homePresenter = homePresenter else { return }
        homePresenter.handleSorting()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        guard let homePresenter = homePresenter else { return }
        homePresenter.refreshData()
    }
    
    @objc func search() {
        guard let homePresenter = homePresenter else { return }
        homePresenter.searchMovie(query: searchBar.text!)
    }
}

extension HomeViewController: HomeViewProtocol {
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func startLoading() {
        lottieLoader.play()
        loaderView.isHidden = false
    }
    
    func finishLoading() {
        self.refreshControl.endRefreshing()
        lottieLoader.stop()
        loaderView.isHidden = true
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setMoviesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.id) as! MovieTableViewCell
        guard let model = setMovieModelForCell(index: indexPath.row) else { return cell }
        cell.setupUI(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = setMovieModelForCell(index: indexPath.row) else { return }
        moveToDetails(movie: model)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        fetchNextPageMovies(index: indexPath.row)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            // to limit network activity, reload half a second after last key press.
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(HomeViewController.search), object: nil)
            self.perform(#selector(HomeViewController.search), with: nil, afterDelay: 0.4)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { //To avoid search request blocking fetchData after clearing the search field
                self.homePresenter?.fetchData()
            }
        }
    }
}

extension HomeViewController {
    func fetchMovies() {
        guard let homePresenter = homePresenter else { return }
        homePresenter.fetchData()
    }
    
    func setMoviesCount() -> Int {
        guard let homePresenter = homePresenter else { return 0 }
        return homePresenter.setMoviesCount()
    }
    
    func setMovieModelForCell(index: Int) -> MovieViewModel? {
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
        if searchBar.text != "" {
            homePresenter.fetchNextPageMovies(index: index, isSearching: true, query: searchBar.text!)
        } else {
            homePresenter.fetchNextPageMovies(index: index, isSearching: false, query: nil)
        }
    }
    
    func moveToDetails(movie: MovieViewModel) {
        guard let homePresenter = homePresenter else { return }
        homePresenter.showDetail(movie: movie)
    }
    
    func registerCustomCells() {
        tableView.register(
            MovieTableViewCell.nib,
            forCellReuseIdentifier: MovieTableViewCell.id
        )
    }
}
