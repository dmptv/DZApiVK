//
//  UITableView+ScrolledToBottom.m
//  DZApiVK
//
//  Created by Dima Tixon on 25/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import "UITableView+ScrolledToBottom.h"

@implementation UITableView (ScrolledToBottom)

// Returns true if the table is currently scrolled to the bottom
- (bool) scrolledToBottom {
    
    return self.contentOffset.y >= (self.contentSize.height - self.bounds.size.height);
}


// Scrolls the UITableView to the bottom of the last row
- (void)scrollToBottom:(BOOL)animated {
    
    NSInteger lastSection = [self.dataSource numberOfSectionsInTableView:self] - 1;
    NSInteger rowIndex = [self.dataSource tableView:self numberOfRowsInSection:lastSection] - 1;
    
    if (rowIndex >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:lastSection];
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}



@end
