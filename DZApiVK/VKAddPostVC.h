//
//  AddPostVC.h
//  DZApiVK
//
//  Created by Dima Tixon on 07/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VKAddPostVC : UIViewController



- (IBAction)cancel:(id)sender;
- (IBAction)sendPost:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *postTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendPost;


@end
