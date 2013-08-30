@interface UIWebDocumentView : NSObject
{
	WebView *_webView;
}

- (WebView *)webView;

@end

@interface UIWebView (DocumentView)

- (UIWebDocumentView *)_documentView;

@end