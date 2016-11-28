//
//  VKMessageVC.h
//  DZApiVK
//
//  Created by Dima Tixon on 07/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessages.h>
#import <JSQMessagesViewController/JSQMessagesBubbleImageFactory.h>



@interface VKMessageVC : JSQMessagesViewController

@property (strong, nonatomic) NSURL *avatarIncoming;
@property (strong, nonatomic) NSURL *avatarOutgoing;


- (IBAction)cancelAction:(UIBarButtonItem *)sender;


@end

















