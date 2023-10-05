//
//  CarouselViewModel.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 2.10.2023.
//

import UIKit

struct CarouselViewModel {
    
    //MARK: - Properties
    
    var movies: [Movie]
    var type: CategoryType
    
    //MARK: - Lifecycle
    
    init(movies: [Movie], type: CategoryType) {
        self.movies = movies
        self.type = type
    }
    
    //MARK: - Helpers
    
    func customLayoutForFirstCarousel() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 210, height: 300)
        return layout
    }
    
    func defaultLayoutForOtherCarousels() -> UICollectionViewLayout {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 140, height: 200)
            return layout
        }
    
}
