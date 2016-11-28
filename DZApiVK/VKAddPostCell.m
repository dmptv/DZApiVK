//
//  VKAddPostCell.m
//  DZApiVK
//
//  Created by Dima Tixon on 05/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import "VKAddPostCell.h"
#import "AKServerManager.h"
#import "VKAddPostVC.h"


@implementation VKAddPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithStarCallback:(void(^)())starCallback {
    self.starCallback = starCallback;
}


- (IBAction)addPost:(id)sender {
    NSLog(@"VKAddPostCell.h addPost");
    
    if (self.starCallback != nil) {
        // проверяет релизован ли блок. он послал сообщение и получил
        // ответное сообщение Callback , что блок реализован и вызвал его
        
        self.starCallback();
    }
    // change the status of the starred attribute on this task
    // resort the list based on this update
}

- (IBAction)addPhoto:(id)sender {
    
    NSLog(@"VKAddPostCell addPhoto");
}














@end





