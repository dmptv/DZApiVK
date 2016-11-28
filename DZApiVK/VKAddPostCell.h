//
//  VKAddPostCell.h
//  DZApiVK
//
//  Created by Dima Tixon on 05/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKAddPostCell : UITableViewCell

@property (strong, nonatomic) void(^starCallback)();

- (IBAction)addPost:(id)sender;
- (IBAction)addPhoto:(id)sender;


- (void) configureCellWithStarCallback:(void(^)()) starCallback; // похоже на: (NSString*) name

@end
