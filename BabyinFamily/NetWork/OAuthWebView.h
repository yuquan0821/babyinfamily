//
//  OAuthWebView.h
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//


@protocol OAuthWebViewDelegate ;
@interface OAuthWebView : UIViewController<UIWebViewDelegate>{
    UIWebView *webV;
    NSString *token;
    
    id <OAuthWebViewDelegate> _delegate;
}
@property (retain, nonatomic) IBOutlet UIWebView *webV;
@property (nonatomic, assign) id <OAuthWebViewDelegate> delegate;

@end

@protocol OAuthWebViewDelegate <NSObject>

- (void) oauthControllerDidFinished:(OAuthWebView *)oauthController;
- (void) oauthControllerDidCancel:(OAuthWebView *)oauthController;

@end