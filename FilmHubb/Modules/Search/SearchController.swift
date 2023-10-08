//
//  SearchController.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 2.10.2023.
//

import UIKit

private let searchCellIdentifier = "searchCell"

class SearchController: UITableViewController {
    
    //MARK: - Properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var viewModel = SearchViewModel()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - API
    
    //MARK: - Actions
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Search"
        
        tableView.register(SearchMovieCell.self, forCellReuseIdentifier: searchCellIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .singleLine
        
        configureSearchController()
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a movie"
        
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
    }
}

//MARK: - UITableViewDelegate/DataSource

extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellIdentifier, for: indexPath) as! SearchMovieCell
        cell.configure(viewModel: SearchMovieViewModel(searchResult: viewModel.movies[indexPath.item]))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoader(true)
        let id = viewModel.movies[indexPath.item].id
        viewModel.getMovie(withId: id) { movieInfo in
            self.viewModel.getCredits(forId: id) { movieCredits in
                self.viewModel.getMovieVideos(forId: id) { movieVideos in
                    DispatchQueue.main.async {
                        let controller = InspectorController(viewModel: InspectorViewModel(movie: movieInfo, movieCredits: movieCredits, movieVideos: movieVideos))
                        controller.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
    }
}

//MARK: - UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.searchMovie(withName: searchText) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
