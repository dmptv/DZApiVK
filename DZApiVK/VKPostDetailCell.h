//
//  VKPostDetailCell.h
//  DZApiVK
//
//  Created by Dima Tixon on 15/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKPostDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *datePostLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *textBody;

@property (weak, nonatomic) IBOutlet UIImageView *AvatarImage;
@property (weak, nonatomic) IBOutlet UIImageView *attachementImage;
@property (weak, nonatomic) IBOutlet UIImageView *attachementImage2;
@property (weak, nonatomic) IBOutlet UIImageView *attachementImage3;





@end
