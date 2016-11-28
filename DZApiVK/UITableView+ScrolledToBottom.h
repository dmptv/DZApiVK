//
//  UITableView+ScrolledToBottom.h
//  DZApiVK
//
//  Created by Dima Tixon on 25/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ScrolledToBottom)

// These will assist and scrolling to the bottom of a table view
// and determining if it is already scrolled to the bottom:

- (bool) scrolledToBottom;
- (void)scrollToBottom:(BOOL)animated;
@end
