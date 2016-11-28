//
//  AKLoginViewController.m
//  DZApiVK
//
//  Created by Kanat A on 20/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import "AKLoginViewController.h"
#import "VKAccessToken.h"

@interface AKLoginViewController () <UIWebViewDelegate>

@property (copy, nonatomic) VKLoginCompletionBlock completionBlock;
@property (strong, nonatomic) UIWebView* webView;

@end

@implementation AKLoginViewController

- (instancetype) initWithCompletionBlock:(VKLoginCompletionBlock) completionBlock
{
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;

}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:rect];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:webView];
    self.webView = webView;
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(actionCancel)];
    [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
    self.navigationItem.title = @"Login";
    
       // Необходимо перенаправить браузер пользователя по адресу
       // https://oauth.vk.com/authorize, передав следующие параметры:
    
    NSString* urlString = [NSString stringWithFormat:
                           @"https://oauth.vk.com/authorize?"
                           "client_id=5670544&"  //  5670544
                           "scope=932894&"       // + 2 + 4 + 16 + 131072 + 8192 = + 8 + 1024 + 2048 + 4096 + 262144 + 524288 
                           "redirect_uri=https://oauth.vk.com/blank.html&"
                           "display=mobile&"
                           "v=5.59&"
                           "response_type=token"];
    
    
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    webView.delegate = self;
    [webView loadRequest:request];
    
}


#pragma mark - UIWebViewDelegate <NSObject>

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *) request
                                                 navigationType:(UIWebViewNavigationType) navigationType {
    
    /*
     придет такой request и надо его распарсить чтобы получить из него токен
     
     @"https://oauth.vk.com/blank.html#"
     
     "access_token=f375bc006fb7638a07526929827012259b12fa756c7250ed946901d763b9d7fcdb46ba5f569a25714319c&"
     
     "expires_in=86400&"
     
     "user_id=6071695&"
     
     "state=123456";
     */
    
    if ([request.URL.description rangeOfString:@"access_token"].location != NSNotFound) {
        VKAccessToken* token = [[VKAccessToken alloc] init];
        
        NSArray* array = [request.URL.description componentsSeparatedByString:@"#"];
        
        NSString* str = [NSString new];
        
        if ([array count] > 1) {
            str = [array lastObject];
        }
        
        NSArray* pairsArray = [str componentsSeparatedByString:@"&"];
        
        for (NSString* str in pairsArray) {
            NSArray* tempArray = [str componentsSeparatedByString:@"="];
            
            if ([tempArray count] == 2) {
                NSString* key = [tempArray firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    token.token = [tempArray lastObject];
                }
                else if ([key isEqualToString:@"expires_in"]) {
                    NSTimeInterval interval = [[tempArray lastObject] doubleValue];
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                }
                else if ([key isEqualToString:@"user_id"]) {
                    token.userID = [tempArray lastObject];
                }
            }
        }
        
        self.webView.delegate = nil;
        
        if (self.completionBlock) {
            self.completionBlock(token);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}


- (void) actionCancel {
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
