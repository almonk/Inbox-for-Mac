 //
//  ViewController.m
//  Inbox for Mac
//
//  Created by Alasdair Lampon-Monk on 9/16/15.
//  Copyright (c) 2015 Alasdair Lampon-Monk. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [webView setPolicyDelegate:self];
    
    NSURL*url=[NSURL URLWithString:@"https://inbox.google.com/u/0/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [webView setCustomUserAgent:@"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"];
    [[webView mainFrame] loadRequest:request];
    
    [webView2 setPolicyDelegate:self];
    
    NSURL*url2=[NSURL URLWithString:@"https://inbox.google.com/u/1/"];
    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2];
    [webView2 setCustomUserAgent:@"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"];
    [[webView2 mainFrame] loadRequest:request2];
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}
//
//- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
//{
//    // HACK: This is all a hack to get around a bug/misfeature in Tiger's WebKit
//    // (should be fixed in Leopard). On Javascript window.open, Tiger sends a null
//    // request here, then sends a loadRequest: to the new WebView, which will
//    // include a decidePolicyForNavigation (which is where we'll open our
//    // external window). In Leopard, we should be getting the request here from
//    // the start, and we should just be able to create a new window.
//    
//    WebView *newWebView = [[WebView alloc] init];
//    [newWebView setUIDelegate:self];
//    [newWebView setPolicyDelegate:self];
//    
//    return newWebView;
//}

- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener {
    if( [sender isEqual:webView] ) {
        [listener use];
    }
    else {
        
        if ([[[actionInformation valueForKey:WebActionOriginalURLKey] absoluteString]containsString:@".google.com"]) {
            [listener use];
        } else {
            [[NSWorkspace sharedWorkspace] openURL:[actionInformation objectForKey:WebActionOriginalURLKey]];
            [listener ignore];
        }

    }
}

- (void)webView:(WebView *)sender decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id<WebPolicyDecisionListener>)listener {
    NSLog(@"%@", [actionInformation valueForKey:WebActionOriginalURLKey]);
    
    if ([[[actionInformation valueForKey:WebActionOriginalURLKey] absoluteString]containsString:@".google.com"]) {
        NSURL*url=[NSURL URLWithString:[[actionInformation valueForKey:WebActionOriginalURLKey] absoluteString]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [[webView mainFrame] loadRequest:request];
        [listener use];
    } else {
        [[NSWorkspace sharedWorkspace] openURL:[actionInformation objectForKey:WebActionOriginalURLKey]];
        [listener ignore];
    }


}

@end
