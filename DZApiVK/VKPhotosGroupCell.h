//
//  VKPhotosGroupCell.h
//  DZApiVK
//
//  Created by Dima Tixon on 29/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VKAlbum;

@interface VKPhotosGroupCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView* collectionView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style album:(VKAlbum *)album
                                      reuseIdentifier:(NSString *)reuseIdentifier;


@property(strong, nonatomic) UIImageView* cellImageView;

@end
