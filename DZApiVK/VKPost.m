//
//  VKPost.m
//  DZApiVK
//
//  Created by Kanat A on 21/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import "VKPost.h"
#import "AKUser.h"
#import "VKGroup.h"
#import "VKPhoto.h"

@implementation VKPost

- (instancetype) initWithServerResponce:(NSDictionary*) responseOnject
{
    self = [super initWithServerResponce:responseOnject];
    if (self) {
        
         //NSLog(@" VKPost responseOnject %@", responseOnject); // 139549
        
        
        NSDictionary* commments = [responseOnject objectForKey:@"comments"];
        NSDictionary* likes = [responseOnject objectForKey:@"likes"];
        
        self.commentsCount = [[commments objectForKey:@"count"] integerValue];
        self.likesCount = [[likes objectForKey:@"count"] integerValue];
        
        self.text = [responseOnject objectForKey:@"text"];
        self.text = [self.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        self.from_id = [NSString stringWithFormat:@"%@", [responseOnject objectForKey:@"from_id"]];  
        self.to_id = [NSString stringWithFormat:@"%@", [responseOnject objectForKey:@"to_id"]];
        self.Id = [NSString stringWithFormat:@"%@", [responseOnject objectForKey:@"id"]];
        
        
        NSArray* attachments = [responseOnject objectForKey:@"attachments"];
        
        NSMutableArray* tempArray = [NSMutableArray array];
        
        for (NSDictionary* dic in attachments) {
              // make VKPhoto-attachment for post
            if ([[dic objectForKey:@"type"] isEqualToString:@"photo"]) {
                NSDictionary* valueDic = [dic objectForKey:@"photo"];
                VKPhoto* atachmentPhoto = [[VKPhoto alloc] initWithServerResponce:valueDic];
                [tempArray addObject:atachmentPhoto];
            }
        }
        
        // массив с фото атташмент
        self.attachmentPhotos = tempArray;

        
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        NSDate* dt = [NSDate dateWithTimeIntervalSince1970:[[responseOnject objectForKey:@"date"] floatValue]];
        [df setDateFormat:@"dd MM yyyy"];
        NSString* date = [df stringFromDate:dt];
        
        self.date =  date;
        
    }
    
    return self;
}

/*
 
 comments =     {
 count = 0;
 };
 date = 1477988937;
 "from_id" = 16571913;
 id = 136896;
 
 self.attachments (
     {
 photo = {
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
 )
 
 */

/*
 self.attachments  (
   {
 type = video;
 video =         {
          "access_key" = ddf316c1544516c9bd;
          date = 1477917608;
          description = "In this tutorial I show you how to change application icon in Xcode project.<br><br>Hi let\U2019s start!<br>1.Select image size 1024x1024.<br>2.Go to site https://makeappicon.com<br>3.Upload image.<br>4.Enter your email.<br>5.Go to your email.<br>6.Dowload .zip file.<br>7.Unzip to folder.<br>8.Open folder.<br>9.Select AppIcon.appiconset folder.<br>10.Open your Xcode project.<br>11.Select Assets.xcassets.<br>12.Delete AppIcon.<br>13.Drag and drop AppIcon.appiconset to Assets.xcassets.<br>14. cmd+r run project.<br>Well done!!!";
         duration = 240;
         image = "https://pp.vk.me/c636425/u18794185/video/l_1357fdb5.jpg";
         "image_big" = "https://pp.vk.me/c636425/u18794185/video/l_1357fdb5.jpg";
         "image_small" = "https://pp.vk.me/c636425/u18794185/video/s_cb448614.jpg";
         "image_xbig" = "https://pp.vk.me/c636425/u18794185/video/y_8e156e12.jpg";
         "owner_id" = 18794185;
         platform = YouTube;
         title = "How to change app icon iOS";
         vid = 456239047;
         views = 21;
        };
   }
 )
 */


@end
