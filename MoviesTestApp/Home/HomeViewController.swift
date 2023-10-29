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
    @IBOutlet private weak var emptyStateView: UIView!
    @IBOutlet private weak var lottieLoader: LottieAnimationView!
    @IBOutlet private weak var sortingButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    var homePresenter: HomePresenterProtocol?
    private lazy var refreshControl = UIRefreshControl()
    private var searchTask: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomCells()
        homePresenter?.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homePresenter?.prepareForAppear()
        setupUI()
    }
    
    private func setupUI() {
        tableView.backgroundView = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        searchBar.placeholder = "Search".localized()
        lottieLoader.loopMode = .loop
    }
    
    @objc private func sortingButtonPressed(_ sender: Any) {
        guard let homePresenter = homePresenter else { return }
        homePresenter.handleSorting()
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        guard let homePresenter = homePresenter else { return }
        homePresenter.refreshData()
    }
    
    @objc private func search() {
        guard let homePresenter = homePresenter else { return }
        homePresenter.searchMovie(query: searchBar.text!)
    }
}

extension HomeViewController: HomeViewProtocol {
    func hideEmptyStateView() {
        emptyStateView.isHidden = true
    }
    
    func showEmptyStateView() {
        emptyStateView.isHidden = false
    }
    
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
    
    func setupNavBar() {
        title = "Popular Movies".localized()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "sortingIcon"), style: .done, target: self, action: #selector(sortingButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        homePresenter?.getMoviesCount() ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.id) as! MovieTableViewCell
        guard let model = homePresenter?.setMovieModel(index: indexPath.row) else { return cell }
        cell.setupUI(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = homePresenter?.setMovieModel(index: indexPath.row) else { return }
        homePresenter?.showDetail(movie: model)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchBar.text != "" {
            homePresenter?.fetchNextPageMovies(index: indexPath.row, isSearching: true, query: searchBar.text!)
        } else {
            homePresenter?.fetchNextPageMovies(index: indexPath.row, isSearching: false, query: nil)
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                if searchText != "" {
                    self?.homePresenter?.searchMovie(query: searchText)
                } else {
                    self?.homePresenter?.fetchData()
                }
            }
        }
        
        self.searchTask = task
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
    }
}

private extension HomeViewController {
    func registerCustomCells() {
        tableView.register(
            MovieTableViewCell.nib,
            forCellReuseIdentifier: MovieTableViewCell.id
        )
    }
}
