//
//  CommentCell.h
//  DZApiVK
//
//  Created by Dima Tixon on 15/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *textBodyLabel;

@end
