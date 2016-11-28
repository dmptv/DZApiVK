//
//  VKComment.h
//  DZApiVK
//
//  Created by Dima Tixon on 17/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKServerObject.h"
#import "AKUser.h"
#import "VKGroup.h"
#import "VKPost.h"


@interface VKComment : AKServerObject

@property (strong, nonatomic) NSString* post_id;
@property (strong, nonatomic) NSString* from_id; // от кого коммент
@property (strong, nonatomic) NSString* date;
@property (assign, nonatomic) NSInteger likesCount;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSArray* attachmentPhotos;
@property (strong, nonatomic) NSArray* attachmentVideos;
@property (strong, nonatomic) NSString* commentId; // id коммента

@property (strong, nonatomic) AKUser* user;
@property (strong, nonatomic) VKGroup* fromGroup;


@end

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
 
                             {****
                             attachments  =         (
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
                             likes        =   {
                                                 "can_like"   = 1;
                                                 count        = 0;
                                                 "user_likes" = 0;
                                              };
                             text         = "\U0422\U043e\U043b\U044c\U043a\U043e \U0441\U0435\U0439\U0447\U0430\U0441 \U0437\U0430\U043c\U0435\U0442\U0438\U043b \U0447\U0442\U043e JTAppleCalendar \U0438\U0441\U043f\U043e\U043b\U044c\U0437\U043e\U0432\U0430\U043b\U0441\U044f, \U0442\U0430\U043a \U043d\U0435 \U0438\U043d\U0442\U0435\U0440\U0435\U0441\U043d\U043e, \U0438\U043d\U0442\U0435\U0440\U0435\U0441\U043d\U0435\U0439 \U0441\U0430\U043c\U043e\U043c\U0443 \U043f\U0438\U0441\U0430\U0442\U044c \U0442\U0430\U043a\U0438\U0435 \U0448\U0442\U0443\U043a\U0438)";
                             }****
                  );
 
    profiles = (
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
             };
           }

 
*/







