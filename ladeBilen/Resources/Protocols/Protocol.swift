//
//  Protocoll.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 25.03.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import Foundation
import UIKit

protocol stationConntactWasUpdated {
    func stationConntactWasUpdated()
}


protocol CollectionViewCellDelegate: class {
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton, action: action, skipConfirmation: Bool)
}

protocol FavoritesCellDelegate: class {
    func favoriteShowOnMap(_ cell: UICollectionViewCell, buttonTapped: UIButton, station: Station)
}
