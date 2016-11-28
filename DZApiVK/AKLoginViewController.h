//
//  AKLoginViewController.h
//  DZApiVK
//
//  Created by Kanat A on 20/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VKAccessToken;

typedef void(^VKLoginCompletionBlock)(VKAccessToken* token);

@interface AKLoginViewController : UIViewController

- (instancetype) initWithCompletionBlock:(VKLoginCompletionBlock) completionBlock;

@end
