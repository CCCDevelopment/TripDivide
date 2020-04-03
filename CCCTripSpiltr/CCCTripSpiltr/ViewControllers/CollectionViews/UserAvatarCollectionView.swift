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
    
    
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
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
