//
//  VKPhoto.h
//  DZApiVK
//
//  Created by Dima Tixon on 27/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKServerObject.h"



@interface VKPhoto : AKServerObject

@property (assign, nonatomic) NSInteger width;
@property (assign, nonatomic) NSInteger height;

@property (strong, nonatomic) NSString* src;
@property (strong, nonatomic) NSString* src_big;
@property (strong, nonatomic) NSString* src_small;
@property (strong, nonatomic) NSString* src_xbig;
@property (strong, nonatomic) NSString* src_xxbig;
@property (strong, nonatomic) NSString* src_xxxbig;

@property (strong, nonatomic) NSString* post_id;





@end

/*
{
    photo =         {
        "access_key" = 61002e489f8810c2c9;
        aid = "-8";
        created = 1477925818;
        height = 900;
        "owner_id" = "-58860049";
        pid = 441009278;
        "post_id" = 136816;
        src = "https://pp.vk.me/c638622/v638622659/85c2/BgUlwSay3H8.jpg";
        "src_big" = "https://pp.vk.me/c638622/v638622659/85c3/icim1e2yeaQ.jpg";
        "src_small" = "https://pp.vk.me/c638622/v638622659/85c1/8T5cA2gA998.jpg";
        "src_xbig" = "https://pp.vk.me/c638622/v638622659/85c4/pM0-19mV5oU.jpg";
        "src_xxbig" = "https://pp.vk.me/c638622/v638622659/85c5/jnlJeK0Ixdo.jpg";
        "src_xxxbig" = "https://pp.vk.me/c638622/v638622659/85c6/ge4pkDsZkRI.jpg";
        text = "";
        "user_id" = 43509659;
        width = 1440;
    };
    type = photo;
}
*/






