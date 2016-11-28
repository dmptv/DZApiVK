//
//  AKPostCell.h
//  DZApiVK
//
//  Created by Kanat A on 20/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *postCellLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *addLikeButton;
@property (weak, nonatomic) IBOutlet UIButton *addCommentButton;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentPhotoImageView;


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

+ (CGFloat) heightForText:(NSString*) text;

@end

/*
 
 
 
 [cell.postCellLabel sizeToFit];
 [cell.postCellLabel setNeedsDisplay];

*/
