//
//  UserAvatarCollectionView.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 4/1/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class UserAvatarCollectionView: UICollectionView {

    var selectType: SelectFriendsType?
    
    
    

    
    
    
    func set(selectType: SelectFriendsType) {
        self.selectType = selectType
        register(ExpenseAvatarCell.self, forCellWithReuseIdentifier: ExpenseAvatarCell.reuseID)
    }
    
    override func numberOfItems(inSection section: Int) -> Int {
        return 1
    }
    
    override func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        return FriendCell()
    }
    
    
    

}
