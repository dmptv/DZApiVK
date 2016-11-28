//
//  AKUser.m
//  DZApiVK
//
//  Created by Kanat A on 20/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import "AKUser.h"

@implementation AKUser

- (instancetype) initWithServerResponce:(NSDictionary*) responseOnject
{
    self = [super initWithServerResponce:responseOnject];
    if (self) {
        
        self.firstName = [responseOnject objectForKey:@"first_name"];
        self.lastName = [responseOnject objectForKey:@"last_name"];
        self.user_id = [NSString stringWithFormat:@"%@", [responseOnject objectForKey:@"uid"]];
        
//        self.user_id = [responseOnject objectForKey:@"uid"];
        
        NSString* urlString = [responseOnject objectForKey:@"photo"];
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString]; 
        }
        
    }
    
    return self;
}




@end

/*
 
 2016-11-20 23:30:35.412 DZApiVK[15935:3581002] self.user_id  365406896
 2016-11-20 23:30:35.411 DZApiVK[15935:3581002] self.user_id  179201149
 2016-11-20 23:30:35.409 DZApiVK[15935:3581002] self.user_id  35141062
 2016-11-20 23:30:35.407 DZApiVK[15935:3581002] self.user_id  12168531
 2016-11-20 23:30:35.410 DZApiVK[15935:3581002] self.user_id  92741778 

 2016-11-20 23:30:35.413 DZApiVK[15935:3581002] self.from_id  365406896
 2016-11-20 23:30:35.414 DZApiVK[15935:3581002] self.from_id  179201149
 2016-11-20 23:30:35.415 DZApiVK[15935:3581002] self.from_id  35141062
 2016-11-20 23:30:35.416 DZApiVK[15935:3581002] self.from_id  12168531
 2016-11-20 23:30:35.417 DZApiVK[15935:3581002] self.from_id  92741778
 2016-11-20 23:30:35.418 DZApiVK[15935:3581002] self.from_id  92741778
 
 
 profilesArray (
                 {
                     "first_name" = Denis;
                     "last_name" = Savin;
 
                       uid = 7028439;
 
                     photo = "https://pp.vk.me/c403524/v403524439/354a/YDr73bCXjXw.jpg";
 
 
                     "screen_name" = "savin_denis";
                     sex = 2;
 
                     online = 1;
                 },
 
*/

/*
 
 profiles = (
                 {
                     "first_name" = Orazz;
                     "last_name" = Ata;
 
                     id = 179201149;      photo =  "photo_50"    uid id
                     "photo_50" = "https://pp.vk.me/c636523/v636523149/1a01e/ZzYaRIVXpqk.jpg";
 
                      online = 0;
                     "screen_name" = "orazz_tm";
                     sex = 2;
                 },

 
 */









