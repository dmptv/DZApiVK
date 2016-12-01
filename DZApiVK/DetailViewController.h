//
//  DetailViewController.h
//  DZApiVK
//
//  Created by Dima Tixon on 27/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) UIImage* photo;
- (IBAction)backAction:(id)sender;

@property (assign, nonatomic) CGFloat previousScale;
@property (assign, nonatomic) CGFloat previousRotation;


@property (assign, nonatomic) CGFloat beginX;
@property (assign, nonatomic) CGFloat beginY;


@end
