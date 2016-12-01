//
//  VKPhotosGroupCell.m
//  DZApiVK
//
//  Created by Dima Tixon on 29/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import "VKPhotosGroupCell.h"
#import "VKAlbum.h"
#import "VKPhoto.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"

#import "LineLayout.h"

@interface VKPhotosGroupCell ()

@property (strong,nonatomic) NSMutableArray *photosArray;
@property (assign,nonatomic) BOOL loadingData;



@end

@implementation VKPhotosGroupCell



static NSString *CollectionViewCellIdentifier = @"CollectionViewCellIdentifier";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style album:(VKAlbum *)album
                                                reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (!(self = [super initWithStyle:style
                      reuseIdentifier:reuseIdentifier])) return nil;
 
    
    UIImage* kit = [UIImage imageNamed:@"kit.png"];
    UIImage* kit2 = [UIImage imageNamed:@"kit2"];
    UIImage* kit3 = [UIImage imageNamed:@"kit3"];
    UIImage* kit4 = [UIImage imageNamed:@"kit4"];
    UIImage* kit5 = [UIImage imageNamed:@"kit5"];
    UIImage* kit6 = [UIImage imageNamed:@"kit6"];
    UIImage* kit7 = [UIImage imageNamed:@"kit7"];
    UIImage* kit8 = [UIImage imageNamed:@"kit8"];
    UIImage* kit9 = [UIImage imageNamed:@"kit9"];
    
    self.photosArray =
    [NSMutableArray arrayWithObjects:kit, kit2, kit3, kit4, kit5,
                                     kit6, kit7, kit8, kit9, nil];
    
    
    
    self.backgroundColor =
    [UIColor colorWithRed:0.082 green:0.082 blue:0.082 alpha:1.000];
    
    // Set layout
    //UICollectionViewFlowLayout *layout =
    // [[UICollectionViewFlowLayout alloc] init];
    LineLayout *layout = [[LineLayout alloc] init];
    
    
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 0);
    layout.itemSize = CGSizeMake(46, 46);
    layout.minimumInteritemSpacing = 5.f;
    layout.minimumLineSpacing = 2.f;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // Init collectionView
    self.collectionView =
    [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, self.bounds.size.width, 50)
                       collectionViewLayout:layout];
    
    // Register a class for use in collectionView
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
    // Set collectionView
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor =
    [UIColor colorWithRed:0.082 green:0.082 blue:0.082 alpha:1.000];
    
    [self.contentView addSubview:self.collectionView];
    
    /*
    self.albumNameLabel =
    [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 231, 21)];
    self.albumNameLabel.font = [UIFont systemFontOfSize:15.f];
    self.albumNameLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:self.albumNameLabel];
    
    self.albumPhotosCountLabel =
    [[UILabel alloc] initWithFrame:CGRectMake(10, 29, 231, 21)];
    self.albumPhotosCountLabel.font = [UIFont systemFontOfSize:13.f];
    self.albumPhotosCountLabel.textColor = [UIColor lightGrayColor];
    
    [self addSubview:self.albumPhotosCountLabel];
    
    
    self.album = album;
    self.loadingData = YES; */
    
    
    
    [self getPhotosFromServer];
    
    return self;
}


- (void) getPhotosFromServer {

}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photosArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier
                                              forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
    [cell.contentView addSubview:imageView];
    
    //VKPhoto *photo = [self.photosArray objectAtIndex:indexPath.row];
    
    imageView.image = [self.photosArray objectAtIndex:indexPath.row];
    
    
    
    /*
    NSURLRequest *request =
    [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:photo.src_big]];
    __weak UIImageView *weakimageView = imageView1;
    
    [imageView1
     setImageWithURLRequest:request
     placeholderImage:nil
     success:^(NSURLRequest *request, NSHTTPURLResponse *response,
               UIImage *image) {
         
         [UIView transitionWithView:weakimageView
                           duration:0.3f
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             weakimageView.image = image;
                         }
                         completion:NULL];
         
     }
     failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
               NSError *error) {
         
     }];*/
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //[self.delegete collectionCellPressedAtIndex:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >=
        scrollView.contentSize.height) {
        
        if (!self.loadingData) {
            self.loadingData = YES;
            [self getPhotosFromServer];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(0, 50, self.bounds.size.width, 50);
}

















@end







