//
//  FavoriteMoviesController.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 8.10.2023.
//

import UIKit

private let favoriteIdentifier = "favoriteIdentifier"

class FavoriteMoviesController: UICollectionViewController {
    
    //MARK: - Properties
    
    var viewModel = FavoriteMoviesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Lifecycle
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Favorite Movies"
        
        collectionView.register(MovieViewCell.self, forCellWithReuseIdentifier: favoriteIdentifier)
    }
    func reloadData() {
        DispatchQueue.main.async {
            self.viewModel = FavoriteMoviesViewModel()
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UICollecitonViewControllerDelegate/DataSource

extension FavoriteMoviesController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.ids.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoriteIdentifier, for: indexPath) as! MovieViewCell
        cell.configure(viewModel: MovieViewModel(posterImageUrl: viewModel.posterImageUrls[indexPath.item]))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showLoader(true)
        let id = viewModel.ids[indexPath.item]
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

//MARK: - UICollectionViewDelegateFlowLayout

extension FavoriteMoviesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
}
