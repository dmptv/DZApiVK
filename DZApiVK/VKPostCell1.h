//
//  VKPostCell1.h
//  DZApiVK
//
//  Created by Dima Tixon on 05/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKPostCell1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *postCellLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *addLikeButton;
@property (weak, nonatomic) IBOutlet UIButton *addCommentButton;

@end
