#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <version.h>
#import "IgnoreTouchView.h"

@interface UIApplication (Private)
-(BOOL)launchApplicationWithIdentifier:(NSString*)identifier suspended:(BOOL)suspended;
@end

@interface SBAppSwitcherController : UIViewController
- (id)_snapshotViewForDisplayItem:(id)arg1;
@end

@interface SBCCAirStuffSectionController : UIViewController
@end
@interface SBCCSettingsSectionController : UIViewController
@end
@interface SBCCQuickLaunchSectionController : UIViewController
@end
@interface SBCCMediaControlsSectionController : UIViewController
@end
@interface SBCCBrightnessSectionController : UIViewController
@end

@interface SBDisplayItem : NSObject
+ (id)displayItemWithType:(NSString*)arg1 displayIdentifier:(id)arg2;
- (NSString*)displayIdentifier;
@end
@interface SBAppSwitcherSnapshotView : UIView
+ (id)appSwitcherSnapshotViewForDisplayItem:(id)arg1 orientation:(long long)arg2 preferringDownscaledSnapshot:(_Bool)arg3 loadAsync:(_Bool)arg4 withQueue:(dispatch_queue_t)arg5;
- (void)_loadSnapshotAsyncPreferringDownscaled:(_Bool)arg1;
- (void)_loadSnapshotSyncPreferringDownscaled:(_Bool)arg1;
- (SBDisplayItem*)displayItem;
@end
@interface SPUISearchHeader : UIView
-(void)setCancelButtonHidden:(BOOL)arg1 animated:(BOOL)arg2;
- (UITextField*)searchField;
@end
@interface SBDockView : UIView
- (UIView*)controlCenterOnPage:(NSInteger)page;
- (UIView*)musicOnPage:(NSInteger)page;
- (UIView*)dockListView;
@end
@interface SBDockIconListView : UIView
+ (unsigned long long)iconColumnsOrRows;
@end
@interface SBIconController : UIViewController
+ (id)sharedInstance;
- (_Bool)_presentTopEdgeSpotlight:(_Bool)arg1;
- (_Bool)isEditing;
- (void)setIsEditing:(_Bool)arg1;
@end
@interface SBRootFolderView : UIView <UITextFieldDelegate>
@end

@interface SBIcon : NSObject
- (id)application;
@end
@interface SBIconView : UIView
+ (CGSize)defaultIconSize;
+ (CGSize)defaultIconImageSize;
+ (CGPoint)defaultIconImageCenter;
- (UIView*)viewForIcon:(NSString*)bundleID withSize:(CGSize)iconSize;
- (id)icon;
- (id)_iconImageView;
- (id)iconImageSnapshot;
- (_Bool)isInDock;
- (_Bool)isGrabbed;
@end
@interface SBRootIconListView : UIView
- (double)my_topIconInset;
@end
@interface SBIconBadgeView : UIView
@end
@interface SBApplication : NSObject
- (NSString*)bundleIdentifier;
@end
@interface SBIconImageView : UIView
@end


#pragma mark - Icons (layout) & search
%hook SBRootIconListView
+ (void)initialize {
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class myClass = [self class];

        SEL originalSelector = @selector(topIconInset);
        SEL swizzledSelector = @selector(my_topIconInset);

        Method originalMethod = class_getInstanceMethod(myClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(myClass, swizzledSelector);

        BOOL didAddMethod = class_addMethod(myClass,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(myClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
				HBLogDebug(@"Swizzling '-(double)topIconInset;'");
    });
}
+ (unsigned long long)iconRowsForInterfaceOrientation:(long long)arg1 {
	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.bolencki13.zentrum"];
	if ([prefs integerForKey:@"valid_Sections"] != 3) {
		if ([UIScreen mainScreen].bounds.size.height == 736) {
			return %orig;
		}
		return (%orig-1);
	}

	if (![self isKindOfClass:objc_getClass("SBFolderIconListView")] && ![self isKindOfClass:objc_getClass("SBDockIconListView")]) {
		if ([UIScreen mainScreen].bounds.size.height == 736) {
			return (%orig-1);
		}
		return (%orig-2);
	}
	return %orig;
}
- (id)initWithModel:(id)arg1 orientation:(long long)arg2 viewMap:(id)arg3 {
	self = %orig;

	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.bolencki13.zentrum"];
	if ([prefs integerForKey:@"valid_Sections"] == 2) {
		return self;
	}
	if (![self isKindOfClass:NSClassFromString(@"SBDockIconListView")]) {
		SPUISearchHeader *srfSpotlight = [[NSClassFromString(@"SPUISearchHeader") alloc] initWithFrame:CGRectMake(8,7.5,[UIScreen mainScreen].bounds.size.width-16,30)];
		[srfSpotlight setCancelButtonHidden:YES animated:NO];
		[self addSubview:srfSpotlight];

		NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.bolencki13.zentrum"];
		if ([prefs boolForKey:@"google"] == NO) {
			UIView *tapView = [[UIView alloc] initWithFrame:srfSpotlight.bounds];
			tapView.userInteractionEnabled = YES;
			[srfSpotlight addSubview:tapView];

			UITapGestureRecognizer *tgrSpotlight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
			[tapView addGestureRecognizer:tgrSpotlight];
		} else {
			[[srfSpotlight searchField] setUserInteractionEnabled:YES];
			[[srfSpotlight searchField] addTarget:self action:@selector(searchGoogle:) forControlEvents:UIControlEventEditingDidEndOnExit];
		}
	}

	return self;
}
- (double)verticalIconPadding {
	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.bolencki13.zentrum"];
	if ([prefs integerForKey:@"valid_Sections"] == 1) {
		return %orig;
	}

	if (![self isKindOfClass:objc_getClass("SBFolderIconListView")] && ![self isKindOfClass:objc_getClass("SBDockIconListView")]) {
		return 15;
	}
	return %orig;
}
- (double)topIconInset {
	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.bolencki13.zentrum"];
	if ([prefs integerForKey:@"valid_Sections"] == 2) {
		return %orig;
	}

	return 65;
}
%new
- (double)my_topIconInset {
	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.bolencki13.zentrum"];
	if ([prefs integerForKey:@"valid_Sections"] == 2) {
		return [self my_topIconInset];
	}

	return 65;
}
%new
- (void)handleTap:(UITapGestureRecognizer*)recognizer {
	[[NSClassFromString(@"SBIconController") sharedInstance] _presentTopEdgeSpotlight:YES];
}
%new
- (void)searchGoogle:(UITextField*)sender {
	[sender resignFirstResponder];
	if ([sender.text containsString:@"http"]) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:sender.text]];
	} else {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com/#q=%@",[sender.text stringByReplacingOccurrencesOfString:@" " withString:@"+"]]]];
	}
}
%end



#pragma mark - Icons (Preview)
%hook SBIconView
- (void)layoutSubviews {
	%orig;

	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.bolencki13.zentrum"];
	if ([prefs integerForKey:@"valid_Sections"] == 1) {
		return;
	}

	if ([self isKindOfClass:[NSClassFromString(@"SBFolderIconView") class]] || UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
		return;
	}

	if(sizeof(int*) == 8) {
    //system is 64-bit
		if ([self isInDock] == YES) {
				[[self viewWithTag:13] removeFromSuperview];
				UIView *viewPreview = [self viewForIcon:[[[self icon] application] bundleIdentifier] withSize:[NSClassFromString(@"SBIconView") defaultIconImageSize]];
				viewPreview.tag = 13;
				[self addSubview:viewPreview];
		} else {
			[[self viewWithTag:13] removeFromSuperview];
		}
	}
}
%new
- (UIView*)viewForIcon:(NSString*)bundleID withSize:(CGSize)iconSize {
	iconSize.width = iconSize.width+7.5;
	UIView *view = [UIView new];
	view.backgroundColor = [UIColor whiteColor];
	view.userInteractionEnabled = YES;
	[view setFrame:CGRectMake(([NSClassFromString(@"SBIconView") defaultIconSize].width-78.5)/2,0,78.5,135)];
	// if ([NSClassFromString(@"SBDockIconListView" ) iconColumnsOrRows] > 4) {
		CGFloat scaleFactor = (iconSize.width/78.5);
		[view setFrame:CGRectMake(([NSClassFromString(@"SBIconView") defaultIconSize].width-iconSize.width)/2,0,iconSize.width,view.frame.size.height*scaleFactor)];
	// }

	#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
	if (SYSTEM_VERSION_LESS_THAN(@"9.2")) {
		SBAppSwitcherSnapshotView *snapshotView = [NSClassFromString(@"SBAppSwitcherSnapshotView") appSwitcherSnapshotViewForDisplayItem:[NSClassFromString(@"SBDisplayItem") displayItemWithType:@"App" displayIdentifier:bundleID] orientation:0 preferringDownscaledSnapshot:YES loadAsync:YES withQueue:dispatch_queue_create("BTO_zentrum_Queue", DISPATCH_QUEUE_CONCURRENT)];
	 [snapshotView _loadSnapshotAsyncPreferringDownscaled:YES];
	 // [snapshotView _loadSnapshotSyncPreferringDownscaled:YES];
	 [snapshotView setTransform:CGAffineTransformMakeScale(view.frame.size.width / [[UIScreen mainScreen] bounds].size.width, view.frame.size.height / [[UIScreen mainScreen] bounds].size.height)];
	 [snapshotView setFrame:view.bounds];
	 [view addSubview:snapshotView];
	 HBLogDebug(@"creation %@",[[snapshotView displayItem] displayIdentifier]);
	}


	CGFloat size = view.frame.size.width-35;
	UIImageView *imgViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10,view.frame.size.height-(size)/2,size,size)];
	imgViewIcon.center = CGPointMake(view.center.x-([NSClassFromString(@"SBIconView") defaultIconSize].width-view.frame.size.width)/2,imgViewIcon.center.y);
	imgViewIcon.image = [self iconImageSnapshot];
	[view addSubview:imgViewIcon];

	return view;
}
%end
%hook SBIconBadgeView
- (void)layoutSubviews {
	%orig;
	[self.superview bringSubviewToFront:self];
}
%end


#pragma mark - Dock
static SBDockView *_dockView;
static UIScrollView *scvDockIcons;

%hook SBDockView
static CGSize contentSize;
+ (double)defaultHeight {
	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.bolencki13.zentrum"];
	if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) || [prefs integerForKey:@"valid_Sections"] == 1) {
		return %orig;
  }
	return 180.0;
}
- (void)layoutSubviews {
	%orig;

	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.bolencki13.zentrum"];
	if ([prefs integerForKey:@"valid_Sections"] == 1) {
		return;
	}

	NSInteger left = 1;
	if ([prefs integerForKey:@"segment_left"]) {
		left = [prefs integerForKey:@"segment_left"];
	}
	NSInteger middle = 2;
	if ([prefs integerForKey:@"segment_middle"]) {
		middle = [prefs integerForKey:@"segment_middle"];
	}
	NSInteger right = 3;
	if ([prefs integerForKey:@"segment_right"]) {
		right = [prefs integerForKey:@"segment_right"];
	}

	if (!scvDockIcons) {
		scvDockIcons = [[UIScrollView alloc] initWithFrame:self.bounds];
		scvDockIcons.showsHorizontalScrollIndicator = NO;
		// scvDockIcons.backgroundColor = [UIColor redColor];
		scvDockIcons.pagingEnabled = YES;
		scvDockIcons.canCancelContentTouches = NO;
		[self addSubview:scvDockIcons];

		[[self dockListView] removeFromSuperview];
		[scvDockIcons addSubview:[self dockListView]];
		_dockView = self;

		/*ADD PAGE 1 ITEM*/
		if (left == 1) {
			[scvDockIcons addSubview:[self controlCenterOnPage:0]];
		} else if (left == 3) {
			[scvDockIcons addSubview:[self musicOnPage:0]];
		}
		/*---------------*/

		/*ADD PAGE 2 ITEM*/
		if (middle == 1) {
			[scvDockIcons addSubview:[self controlCenterOnPage:1]];
		} else if (middle == 3) {
			[scvDockIcons addSubview:[self musicOnPage:1]];
		}
		/*---------------*/

		/*ADD PAGE 3 ITEM*/
		if (right == 1) {
			[scvDockIcons addSubview:[self controlCenterOnPage:2]];
		} else if (right == 3) {
			[scvDockIcons addSubview:[self musicOnPage:2]];
		}
		/*---------------*/
	}
	scvDockIcons.frame = self.bounds;
	contentSize = CGSizeMake(CGRectGetWidth(scvDockIcons.frame)*3, CGRectGetHeight(scvDockIcons.frame));
	scvDockIcons.contentSize = contentSize;

	CGRect dock = [self dockListView].frame;
  if (middle == 2) {
		dock.origin.x = dock.origin.x+dock.size.width;
	} else if (right == 2) {
		dock.origin.x = dock.origin.x+dock.size.width*2;
	}
	[[self dockListView] setFrame:dock];
	scvDockIcons.alpha = self.alpha;
}
%new
- (UIView*)controlCenterOnPage:(NSInteger)page {
	IgnoreTouchView *view = [[IgnoreTouchView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*page,0,[UIScreen mainScreen].bounds.size.width,200)];
	view.backgroundColor = [UIColor clearColor];

	SBCCSettingsSectionController *ccSettingsSection = [[NSClassFromString(@"SBCCSettingsSectionController") alloc] init];
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.a3tweaks.auxo-le.list"]) {
		[[ccSettingsSection view] setFrame:CGRectMake(25, 10, [UIScreen mainScreen].bounds.size.width-50, 75)];
	} else {
		[[ccSettingsSection view] setFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 65)];
	}
	[[ccSettingsSection view] setBackgroundColor:[UIColor clearColor]];
	[view addSubview:[ccSettingsSection view]];

	SBCCQuickLaunchSectionController *ccQuickLaunch = [[NSClassFromString(@"SBCCQuickLaunchSectionController") alloc] init];
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.a3tweaks.auxo-le.list"]) {
		[[ccQuickLaunch view] setFrame:CGRectMake(30, 80, [UIScreen mainScreen].bounds.size.width-60, 64)];
	} else {
		[[ccQuickLaunch view] setFrame:CGRectMake(7.5, 80, [UIScreen mainScreen].bounds.size.width-15, 54)];
	}
	[[ccQuickLaunch view] setBackgroundColor:[UIColor clearColor]];
	[view addSubview:[ccQuickLaunch view]];

	SBCCBrightnessSectionController *ccBrightness = [[NSClassFromString(@"SBCCBrightnessSectionController") alloc] init];
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.a3tweaks.auxo-le.list"]) {
		[[ccBrightness view] setFrame:CGRectMake(30, 140, [UIScreen mainScreen].bounds.size.width-60, 35)];
	} else {
		[[ccBrightness view] setFrame:CGRectMake(7.5, 140, [UIScreen mainScreen].bounds.size.width-15, 35)];
		[[ccBrightness view] setTintColor:[UIColor clearColor]];
	}
	[[ccBrightness view] setBackgroundColor:[UIColor clearColor]];
	[view addSubview:[ccBrightness view]];

	return view;
}
%new
- (UIView*)musicOnPage:(NSInteger)page {
	SBCCMediaControlsSectionController *ccMediaSection = [[NSClassFromString(@"SBCCMediaControlsSectionController") alloc] init];
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.a3tweaks.auxo-le.list"]) {
		[[ccMediaSection view] setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width*page, 5, [UIScreen mainScreen].bounds.size.width, 200)];
	} else {
		[[ccMediaSection view] setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width*page, 5, [UIScreen mainScreen].bounds.size.width, 180)];
	}
	[[ccMediaSection view] setBackgroundColor:[UIColor clearColor]];

	return [ccMediaSection view];
}
%end

%hook SBIconScrollView
- (void)setContentOffset:(struct CGPoint)arg1 {
	CGRect dock = [_dockView dockListView].frame; //store original frame
	%orig;
	scvDockIcons.alpha = _dockView.alpha;
	[_dockView dockListView].frame = dock; //reset original frame after system moves it
}
%end


#pragma mark - Rotation
%hook Springboard
- (_Bool)homeScreenSupportsRotation {
	return NO;
}
%end
