//
//  HomeController.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 2.10.2023.
//

import UIKit

class HomeController: UIViewController {
    
    //MARK: - Properties
    
    var viewModel = HomeViewModel()
    
    private let homeTable: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        return tv
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
        configureUI()
        viewModel.getMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeTable.frame = view.bounds
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    //MARK: - Actions
    
    @objc func handleRefresh() {
        DispatchQueue.main.async {
            self.homeTable.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    func configureViewModel() {
        viewModel.delegate = self
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        homeTable.register(CarouselViewCell.self, forCellReuseIdentifier: "NowPlayingCarouselCell")
        homeTable.delegate = self
        homeTable.dataSource = self
        
        view.addSubview(homeTable)
        
        
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "FilmHubb"
        let image = UIImage(systemName: "arrow.clockwise")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(handleRefresh))
    }
}

//MARK: - UITableViewDelegate/DataSource

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NowPlayingCarouselCell", for: indexPath) as! CarouselViewCell
        
        
        let cellViewModel = CarouselViewModel(movies: viewModel.sections[indexPath.section].movies)
        cell.configure(with: cellViewModel)
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .darkGray
        header.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = CategoryType(rawValue: section)?.description
        return title
    }
}

extension HomeController: HomeViewModelDelegate {
    func didFetchMovies() {
        handleRefresh()
    }
}
