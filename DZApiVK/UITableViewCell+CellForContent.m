//
//  UITableViewCell+CellForContent.m
//  DZApiVK
//
//  Created by Dima Tixon on 09/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import "UITableViewCell+CellForContent.h"

@implementation UITableViewCell (CellForContent)

+ (UITableViewCell*) getParentCellFor:(UIView*) view {
    UIView* superView = [view superview];
    
    if (!superView) {
        
        return nil;
        
    } else if (![superView isKindOfClass:[UITableViewCell class]]) {
        
        return [self getParentCellFor:superView];
        
    } else {
        return (UITableViewCell*)superView;
    }
    
    return nil;
}

@end
