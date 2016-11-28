//
//  VKGroup.m
//  DZApiVK
//
//  Created by Dima Tixon on 26/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import "VKGroup.h"

@implementation VKGroup

- (instancetype) initWithServerResponce:(NSDictionary*) responseOnject
{
    self = [super initWithServerResponce:responseOnject];
    if (self) {

        self.gid = [NSString stringWithFormat:@"%@", [responseOnject objectForKey:@"gid"]];
        self.photo_50 = [responseOnject objectForKey:@"photo_50"];
        self.name = [responseOnject objectForKey:@"name"];
        
    }
    
    return self;
}

@end
