//
//  CarouselViewCell.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 2.10.2023.
//

import UIKit

protocol CarouselViewCellDelegate: AnyObject {
    func handleShowInspectorController(withId id: Int)
}

private let movieIdentifier = "CarouselViewCell"

class CarouselViewCell: UITableViewCell {
    
    //MARK: - Porperties
    
    var viewModel: CarouselViewModel?
    
    weak var delegate: CarouselViewCellDelegate?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.backgroundView = UIView.init(frame: .zero)
        collectionView.register(MovieViewCell.self, forCellWithReuseIdentifier: movieIdentifier)
        return collectionView
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = contentView.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureCell() {
        contentView.backgroundColor = .white
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configure(with viewModel: CarouselViewModel) {
        self.viewModel = viewModel
        
        if viewModel.type == .nowPlaying {
            collectionView.collectionViewLayout = viewModel.customLayoutForFirstCarousel()
        } else {
            collectionView.collectionViewLayout = viewModel.defaultLayoutForOtherCarousels()
        }
        
        collectionView.reloadData()
        collectionView.contentOffset.x = 0
    }
}

//MARK: - UICollectionViewDelegate/DataSource

extension CarouselViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel else { return 1 }
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieIdentifier, for: indexPath) as! MovieViewCell
        guard let viewModel = viewModel else { return cell}
        let movie = viewModel.movies[indexPath.item]
        cell.configure(viewModel: MovieViewModel(movie: movie))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        delegate?.handleShowInspectorController(withId: viewModel.movies[indexPath.item].id)
    }
    
}
