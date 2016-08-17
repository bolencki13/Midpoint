#import <Preferences/PSListController.h>

@interface MidpointListController: PSListController {
}
@end

@implementation MidpointListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Midpoint" target:self] retain];
	}
	return _specifiers;
}
- (void)respring {
	system("killall backboardd");
}
- (void)AOkhtenberg {
	NSURL *tweetbot = [NSURL URLWithString:@"tweetbot:///user_profile/AOkhtenberg"];
	    if ([[UIApplication sharedApplication] canOpenURL:tweetbot])
	        [[UIApplication sharedApplication] openURL:tweetbot];
	    else {

	        NSURL *twitterapp = [NSURL URLWithString:@"twitter:///user?screen_name=AOkhtenberg"];
	        if ([[UIApplication sharedApplication] canOpenURL:twitterapp])
	            [[UIApplication sharedApplication] openURL:twitterapp];
	        else {
	            NSURL *twitterweb = [NSURL URLWithString:@"http://twitter.com/AOkhtenberg"];
	            [[UIApplication sharedApplication] openURL:twitterweb];
	        }
	    }
}
@end


@interface MPDockCustomization : PSListController {
}
@end

@implementation MPDockCustomization
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Midpoint_Dock" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
