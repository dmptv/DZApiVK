//
//  VKPhoto.m
//  DZApiVK
//
//  Created by Dima Tixon on 27/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import "VKPhoto.h"

NSString* kPhoto_75 = @"photo_75";
NSString* kPhoto_130 = @"photo_130";
NSString* kPhoto_604 = @"photo_604";
NSString* kPhoto_807 = @"photo_807";
NSString* kPhoto_1208 = @"photo_1208";
NSString* kPhoto_2560 = @"photo_2560";

@implementation VKPhoto

- (instancetype) initWithServerResponce:(NSDictionary *) responseOnject {

    self = [super initWithServerResponce:responseOnject];
    if (self) {
        
        self.width = [[responseOnject objectForKey:@"width"] integerValue];
        self.height = [[responseOnject objectForKey:@"height"] integerValue];
        
        self.src = [responseOnject objectForKey:@"src"];
        self.src_big = [responseOnject objectForKey:@"src_big"];
        self.src_small = [responseOnject objectForKey:@"src_small"];
        self.src_xbig = [responseOnject objectForKey:@"src_xbig"];
        self.src_xxbig = [responseOnject objectForKey:@"src_xxbig"];
        self.src_xxxbig = [responseOnject objectForKey:@"src_xxxbig"];
        
        self.post_id = [responseOnject objectForKey:@"post_id"];
        

    }
    return self;
}


/*
 
 NSLog(@"attachments photo %@", [[[dict valueForKey:@"attachments"] objectAtIndex:0] objectForKey:@"photo"]);
 
 self.attachments (
    {
 photo =   {
             "access_key" = 591289001c619db717;
             aid = "-8";
             created = 1477918823;
             height = 885;
             "owner_id" = "-58860049";
             pid = 440988172;
             "post_id" = 136806;
             src = "https://pp.vk.me/c626627/v626627388/319a1/5MFwpIpBnJk.jpg";
             "src_big" = "https://pp.vk.me/c626627/v626627388/319a2/LFy8XV3158M.jpg";
             "src_small" = "https://pp.vk.me/c626627/v626627388/319a0/0dq9uFijfMo.jpg";
             "src_xbig" = "https://pp.vk.me/c626627/v626627388/319a3/cePnGo6uu48.jpg";
             "src_xxbig" = "https://pp.vk.me/c626627/v626627388/319a4/O7cJXA28YLA.jpg";
             "src_xxxbig" = "https://pp.vk.me/c626627/v626627388/319a5/irH5rwVs3sg.jpg";
             text = "";
             "user_id" = 244033388;
             width = 1392;
          };
 
 type = photo;
 
   }
 
 */

@end















