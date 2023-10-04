//
//  CarouselViewCell.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 2.10.2023.
//

import UIKit

private let movieIdentifier = "CarouselViewCell"

class CarouselViewCell: UITableViewCell {
    
    //MARK: - Porperties
    
    var viewModel: CarouselViewModel?
    
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
            collectionView.collectionViewLayout = customLayoutForFirstCarousel()
        } else {
            collectionView.collectionViewLayout = defaultLayoutForOtherCarousels()
        }
        
        collectionView.reloadData()
    }
    
    private func customLayoutForFirstCarousel() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 210, height: 300)
        return layout
    }
    
    private func defaultLayoutForOtherCarousels() -> UICollectionViewLayout {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 140, height: 200)
            return layout
        }
}

extension CarouselViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel else { return 1 }
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieIdentifier, for: indexPath) as! MovieViewCell
        guard let viewModel else { return cell}
        let movie = viewModel.movies[indexPath.item]
        cell.configure(viewModel: MovieViewModel(movie: movie))
        return cell
    }
    
}
