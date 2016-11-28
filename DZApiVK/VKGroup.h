//
//  VKGroup.h
//  DZApiVK
//
//  Created by Dima Tixon on 26/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKServerObject.h"

@interface VKGroup : AKServerObject

@property (strong, nonatomic) NSString *gid;
@property (strong, nonatomic) NSString *photo_200;
@property (strong, nonatomic) NSString* photo_50;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) BOOL is_closed;
@property (strong, nonatomic) NSString* screen_name;




@end
