//
//  AddComCell.h
//  DZApiVK
//
//  Created by Dima Tixon on 17/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddComCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@property (strong, nonatomic) void(^sendCallback)(); // 1

- (void) configureCellWithSendCallback:(void(^)(NSString* text)) sendCallback; // 2




@end
