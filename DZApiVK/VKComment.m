//
//  VKComment.m
//  DZApiVK
//
//  Created by Dima Tixon on 17/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import "VKComment.h"

@implementation VKComment

- (instancetype) initWithServerResponce:(NSDictionary*) responseOnject
{
    self = [super initWithServerResponce:responseOnject];
    if (self) {
        
        self.commentId = [NSString stringWithFormat:@"%@", [responseOnject objectForKey:@"id"]];
        self.from_id = [NSString stringWithFormat:@"%@", [responseOnject objectForKey:@"from_id"]];
       
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        NSDate* dt = [NSDate dateWithTimeIntervalSince1970:[[responseOnject objectForKey:@"date"] doubleValue]];
        [df setDateFormat:@"dd MM yyyy"];
        NSString* date = [df stringFromDate:dt];
        
        self.date =  date;
        self.likesCount = [[[responseOnject objectForKey:@"likes"] objectForKey:@"count"] integerValue];
        self.text = [responseOnject objectForKey:@"text"];
        
        
//        self.post_id =
//        self.attachmentPhotos =
//        self.attachmentVideos =


    }
    return self;
}

/*
 
 responseObject {
      response = {
                  count = 6;
                  groups = (
                           );
 
                items = (
                             {
                             date = 1479391988;
                             "from_id" = 365406896;
                             id = 138919;
                             likes = {
                                     "can_like" = 1;
                                     count = 0;
                                     "user_likes" = 0;
                                     };
 
                             text = "\U0430 \U043d\U0430 \U0433\U043e\U0434 \U0435\U0441\U0442\U044c ?";
                             },
                             
                             { ****
                             attachments  = (
                                                {
                                                 type = video;
                                                 video = {
                                                             "access_key" = 4b798bf341304465f0;
                                                             "can_add" = 1;
                                                             comments = 0;
                                                             date = 1474053981;
                                                             description = "";
                                                             duration = 106;
                                                             height = 1334;
                                                             id = 456239021;
                                                             "owner_id" = 92741778;
                                                             "photo_130" = "https://pp.vk.me/c631929/v631929778/520d9/T6f7_6VaRy8.jpg";
                                                             "photo_320" = "https://pp.vk.me/c631929/v631929778/520d7/kScWcrrMWQ0.jpg";
                                                             "photo_800" = "https://pp.vk.me/c631929/v631929778/520d6/MszeB6hE-ts.jpg";
                                                             title = SpeedTest;
                                                             views = 35;
                                                             width = 750;
                                                          };
                                                 }
                                            );
 
                             date         = 1479416695;
                             "from_id"    = 92741778;
                             id           = 138992;
                             likes        =    {
                                                 "can_like"   = 1;
                                                 count        = 0;
                                                 "user_likes" = 0;
                                                };
 
                             text         = "\U0422";
                             } ****
                    );

 profiles = (
                 {
                     "first_name" = "\U0410\U043d\U0430\U0442\U043e\U043b\U0438\U0439";
                     id = 12168531;
                     "last_name" = "\U0417\U0430\U0432\U044c\U044f\U043b\U043e\U0432";
                     online = 0;
                     "photo_100" = "https://pp.vk.me/c627919/v627919531/3ba3b/IO8BPpw3UUI.jpg";
                     "photo_50" = "https://pp.vk.me/c627919/v627919531/3ba3c/j4g_vDmSIvw.jpg";
                     "screen_name" = id12168531;
                     sex = 2;
                 },
                 {
                     "first_name" = "\U0421\U0435\U0440\U0433\U0435\U0439";
                     id = 35141062;
                     "last_name" = "\U0411\U043e\U0440\U0438\U0447\U0435\U0432";
                     online = 1;
                     "online_app" = 3140623;
                     "online_mobile" = 1;
                     "photo_100" = "https://pp.vk.me/c637518/v637518062/fc40/yg11pG0Yz9Y.jpg";
                     "photo_50" = "https://pp.vk.me/c637518/v637518062/fc41/RLhqmxUkR1k.jpg";
                     "screen_name" = id35141062;
                     sex = 2;
                 },
                 {
                     "first_name" = Gleb;
                     id = 92741778;
                     "last_name" = Radchenko;
                     online = 1;
                     "online_app" = 3140623;
                     "online_mobile" = 1;
                     "photo_100" = "https://pp.vk.me/c630718/v630718778/49707/HEAsvKo2IoY.jpg";
                     "photo_50" = "https://pp.vk.me/c630718/v630718778/49708/iAK2tPt7gco.jpg";
                     "screen_name" = rgs444;
                     sex = 2;
                 },
                 {
                     "first_name" = Orazz;
                     id = 179201149;
                     "last_name" = Ata;
                     online = 0;
                     "photo_100" = "https://pp.vk.me/c636523/v636523149/1a01d/MMHTy21i8i4.jpg";
                     "photo_50" = "https://pp.vk.me/c636523/v636523149/1a01e/ZzYaRIVXpqk.jpg";
                     "screen_name" = "orazz_tm";
                     sex = 2;
                 },
                 {
                     "first_name" = Bat;
                     id = 365406896;
                     "last_name" = Man;
                     online = 0;
                     "photo_100" = "https://pp.vk.me/c636324/v636324896/8140/YZrnfhslfwQ.jpg";
                     "photo_50" = "https://pp.vk.me/c636324/v636324896/8141/Xg4btztXTho.jpg";
                     "screen_name" = id365406896;
                     sex = 2;
                 }
            );

 
 */





@end
