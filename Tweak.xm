#import "../PS.h"

@interface UIKeyboardEmojiCategory : NSObject {
	int _categoryType;
	NSArray *_emoji;
	int _lastVisibleFirstEmojiIndex;
}
@property int categoryType;
@property(getter=displaySymbol,readonly) NSString *displaySymbol;
@property(retain) NSArray *emoji;
@property NSUInteger lastVisibleFirstEmojiIndex;
@property(getter=name,readonly) NSString *name;
@property(getter=recentDescription,readonly) NSString *recentDescription; // iOS 7+
+ (NSMutableArray *)categories;
+ (UIKeyboardEmojiCategory *)categoryForType:(int)type;
+ (NSArray *)emojiRecentsFromPreferences;
+ (BOOL)hasVariantsForEmoji:(NSString *)emoji; // iOS 7+
+ (NSString *)localizedStringForKey:(NSString *)key;
+ (NSInteger)numberOfCategories;
- (NSString *)displaySymbol;
- (void)releaseCategories;
@end

@interface UIKeyboardEmoji : NSObject {
	NSString *_emojiString;
	BOOL _hasDingbat;
}
@property(retain) NSString *emojiString;
@property BOOL hasDingbat;
+ (UIKeyboardEmoji *)emojiWithString:(NSString *)string;
- (id)initWithString:(NSString *)string;
+ (UIKeyboardEmoji *)emojiWithString:(NSString *)string hasDingbat:(BOOL)dingbat; // iOS 7+
- (id)initWithString:(NSString *)string hasDingbat:(BOOL)dingbat; // iOS 7+
- (BOOL)isEqual:(UIKeyboardEmoji *)emoji;
- (NSString *)key; // emojiString
@end

@interface UIKBRenderConfig : NSObject
@end

@interface UIKBTree : NSObject
@property unsigned int interactionType;
@property unsigned int rendering;
@property int state;
@property(retain, nonatomic) NSString *displayString;
@property(retain, nonatomic) NSString *representedString;
- (NSString *)name;
- (BOOL)_renderAsStringKey;
@end

@interface UIKeyboardEmojiImageView : UIImageView
@end

@protocol UIKeyboardEmojiPressIndicationDelegate;

@interface UIKeyboardEmojiView : UIControl {
	UIKeyboardEmoji *_emoji;
	UIView *_popup;
	UIKeyboardEmojiImageView *_imageView;
	UIKBRenderConfig *_renderConfig;
	UIView <UIKeyboardEmojiPressIndicationDelegate> *_delegate;
}
@property (retain) UIKeyboardEmoji *emoji;
@property (nonatomic, retain) UIKBRenderConfig *renderConfig;
@property (retain) UIView <UIKeyboardEmojiPressIndicationDelegate> *delegate;
@property (retain) UIView *popup;
@property (retain) UIKeyboardEmojiImageView *imageView;
+ (UIKeyboardEmojiView *)emojiViewForEmoji:(UIKeyboardEmoji *)emoji withFrame:(CGRect)frame;
+ (void)recycleEmojiView:(UIKeyboardEmojiImageView *)emojiView;
- (void)uninstallPopup;
- (id)createAndInstallKeyPopupView;
- (UIView *)popup;
- (void)setEmoji:(UIKeyboardEmoji *)emoji withFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame emoji:(UIKeyboardEmoji *)emoji;
@end

/*static NSString *skinToneUnicodeForFitzpatrickType(int type)
{
	// References: http://emojipedia.org/skin-tone-modifiers/
	// Define Type 1-2 as 2 here.
	NSString *format = nil;
	switch (type) {
		case 2:
			format = @"\U0001f3fb";
			break;
		case 3:
			format = @"\U0001f3fc";
			break;
		case 4:
			format = @"\U0001f3fd";
			break;
		case 5:
			format = @"\U0001f3fe";
			break;
		case 6:
			format = @"\U0001f3ff";
			break;
	}
	return format;
}

static BOOL isSkinTone(NSString *emoji)
{
	for (int type = 6; type >= 2; type--) {
		NSString *skin = skinToneUnicodeForFitzpatrickType(type);
		if ([skin isEqualToString:emoji])
			return YES;
	}
	return NO;
}

static NSArray *diverseEmojisForEmojiString(NSString *emoji)
{
	NSMutableArray *emojis = [NSMutableArray arrayWithCapacity:5];
	for (int type = 6; type >= 2; type--) {
		NSString *skin = skinToneUnicodeForFitzpatrickType(type);
		NSString *diverseEmoji = [NSString stringWithFormat:@"%@%@", emoji, skin];
		[emojis addObject:diverseEmoji];
	}
	return emojis;
}*/

Class $UIKeyboardEmoji;

static UIKeyboardEmoji *emojiFromStringAndDingbat(NSString *myEmoji, BOOL dingbat)
{
	UIKeyboardEmoji *emo = [$UIKeyboardEmoji respondsToSelector:@selector(emojiWithString:hasDingbat:)] ?
									[$UIKeyboardEmoji emojiWithString:myEmoji hasDingbat:dingbat] :
									[$UIKeyboardEmoji emojiWithString:myEmoji];
	return emo;
}

static void addEmojisForIndexAtIndex(UIKeyboardEmojiCategory *emojiObject, NSArray *myEmojis, NSUInteger index, NSUInteger emojiIndex, BOOL dingbat)
{
	NSArray *emoji = emojiObject.emoji;
	if (emoji.count != 0 && myEmojis.count != 0) {
		NSMutableArray *array = [NSMutableArray array];
		[array addObjectsFromArray:emoji];
		for (NSString *myEmoji in myEmojis) {
			UIKeyboardEmoji *emo = emojiFromStringAndDingbat(myEmoji, dingbat);
			if (![array containsObject:emo]) {
				if (emojiIndex != 0 && emojiIndex < array.count)
					[array insertObject:emo atIndex:emojiIndex];
				else
					[array addObject:emo];
			}
		}
		emojiObject.emoji = array;
	}
}

static void addEmojisForIndexWithDingbat(UIKeyboardEmojiCategory *emojiObject, NSArray *myEmojis, NSUInteger index)
{
	addEmojisForIndexAtIndex(emojiObject, myEmojis, index, 0, YES);
}

static void addVulcanEmoji(UIKeyboardEmojiCategory *emojiObject)
{
	addEmojisForIndexAtIndex(emojiObject, @[@"🖖"], 1, 123, NO);
}

static void addFlagEmojis(UIKeyboardEmojiCategory *emojiObject)
{
	NSString *flagsString = @"🇦🇫 🇦🇱 🇩🇿 🇦🇸 🇦🇩 🇦🇴 🇦🇮 🇦🇬 🇦🇷 🇦🇲 🇦🇼 🇦🇺 🇦🇹 🇦🇿 🇧🇸 🇧🇭 🇧🇩 🇧🇧 🇧🇾 🇧🇪 🇧🇿 🇧🇯 🇧🇲 🇧🇹 🇧🇴 🇧🇦 🇧🇼 🇧🇷 🇧🇳 🇧🇬 🇧🇫 🇧🇮 🇰🇭 🇨🇲 🇨🇦 🇨🇻 🇰🇾 🇨🇫 🇨🇱 🇨🇴 🇰🇲 🇨🇩 🇨🇬 🇨🇰 🇨🇷 🇭🇷 🇨🇺 🇨🇼 🇨🇾 🇨🇿 🇩🇰 🇩🇯 🇩🇲 🇩🇴 🇪🇨 🇪🇬 🇸🇻 🇬🇶 🇪🇷 🇪🇪 🇪🇹 🇫🇴 🇫🇯 🇫🇮 🇫🇷 🇬🇫 🇹🇫 🇬🇦 🇬🇲 🇬🇪 🇬🇭 🇬🇮 🇬🇷 🇬🇩 🇬🇵 🇬🇺 🇬🇹 🇬🇳 🇬🇼 🇬🇾 🇭🇹 🇭🇳 🇭🇰 🇭🇺 🇮🇸 🇮🇳 🇮🇩 🇮🇷 🇮🇶 🇮🇪 🇮🇱 🇨🇮 🇯🇲 🇯🇴 🇰🇿 🇰🇪 🇰🇮 🇰🇼 🇰🇬 🇱🇦 🇱🇻 🇱🇧 🇱🇸 🇱🇷 🇱🇾 🇱🇮 🇱🇹 🇱🇺 🇲🇴 🇲🇰 🇲🇬 🇲🇼 🇲🇾 🇲🇻 🇲🇱 🇲🇹 🇲🇶 🇲🇷 🇲🇽 🇲🇩 🇲🇳 🇲🇪 🇲🇸 🇲🇦 🇲🇿 🇲🇲 🇳🇦 🇳🇵 🇳🇱 🇳🇨 🇳🇿 🇳🇮 🇳🇪 🇳🇬 🇳🇺 🇰🇵 🇲🇵 🇳🇴 🇴🇲 🇵🇰 🇵🇼 🇵🇸 🇵🇦 🇵🇬 🇵🇾 🇵🇪 🇵🇭 🇵🇱 🇵🇹 🇵🇷 🇶🇦 🇷🇴 🇷🇼 🇼🇸 🇸🇲 🇸🇹 🇸🇦 🇸🇳 🇷🇸 🇸🇨 🇸🇱 🇸🇬 🇸🇰 🇸🇮 🇸🇧 🇸🇴 🇿🇦 🇸🇸 🇱🇰 🇸🇩 🇸🇷 🇸🇿 🇸🇪 🇨🇭 🇸🇾 🇹🇯 🇹🇿 🇹🇭 🇹🇱 🇹🇬 🇹🇴 🇹🇹 🇹🇳 🇹🇷 🇹🇲 🇹🇨 🇹🇻 🇺🇬 🇺🇦 🇦🇪 🇺🇾 🇺🇿 🇻🇺 🇻🇪 🇻🇳 🇾🇪 🇿🇲 🇿🇼";
	NSArray *flags = [flagsString componentsSeparatedByString:@" "];
	addEmojisForIndexWithDingbat(emojiObject, flags, 4);
}

static void addFamilyEmojis(UIKeyboardEmojiCategory *emojiObject)
{
	NSArray *families = @[@"👨‍👩‍👧", @"👨‍👩‍👦‍👦", @"👨‍👩‍👧‍👧", @"👩‍👩‍👦", @"👩‍👩‍👧", @"👩‍👩‍👧‍👦", @"👩‍👩‍👦‍👦", @"👩‍👩‍👧‍👧", @"👨‍👨‍👦", @"👨‍👨‍👧", @"👨‍👨‍👧‍👦", @"👨‍👨‍👦‍👦", @"👨‍👨‍👧‍👧"];
	addEmojisForIndexAtIndex(emojiObject, families, 1, 129, NO);
}

static void addDiverseEmojis(UIKeyboardEmojiCategory *emojiObject)
{
	NSArray *emoji = emojiObject.emoji;
	if (emoji.count == 0)
		return;
	NSMutableArray *array = [NSMutableArray array];
	[array addObjectsFromArray:emoji];
	NSArray *diverseTargets = @[@"👦", @"👧", @"👨", @"👩", @"👮", @"👰", @"👱", @"👲", @"👳", @"👴", @"👵", @"👶", @"👷", @"👸", @"💂", @"👼", @"🎅", @"🙇", @"💁", @"🙅", @"🙆", @"🙋", @"🙎", @"🙍", @"💆", @"💇",
								@"💅", @"👂", @"👃", @"👋", @"👍", @"👎", @"☝", @"👆", @"👇",@"👈", @"👉", @"👌", @"✌", @"👊", @"✊", @"✋", @"💪", @"👐", @"🙌", @"👏", @"🙏", @"🖖"];
	NSString *paleEmojis = @"👦🏻 👧🏻 👨🏻 👩🏻 👮🏻 👰🏻 👱🏻 👲🏻 👳🏻 👴🏻 👵🏻 👶🏻 👷🏻 👸🏻 💂🏻 👼🏻 🎅🏻 🙇🏻 💁🏻 🙅🏻 🙆🏻 🙋🏻 🙎🏻 🙍🏻 💆🏻 💇🏻 💅🏻 👂🏻 👃🏻 👋🏻 👍🏻 👎🏻 ☝🏻 👆🏻 👇🏻 👈🏻 👉🏻 👌🏻 ✌🏻 👊🏻 ✊🏻 ✋🏻 💪🏻 👐🏻 🙌🏻 👏🏻 🙏🏻 🖖🏻️";
	NSString *creamEmojis = @"👦🏼 👧🏼 👨🏼 👩🏼 👮🏼 👰🏼 👱🏼 👲🏼 👳🏼 👴🏼 👵🏼 👶🏼 👷🏼 👸🏼 💂🏼 👼🏼 🎅🏼 🙇🏼 💁🏼 🙅🏼 🙆🏼 🙋🏼 🙎🏼 🙍🏼 💆🏼 💇🏼 💅🏼 👂🏼 👃🏼 👋🏼 👍🏼 👎🏼 ☝🏼 👆🏼 👇🏼 👈🏼 👉🏼 👌🏼 ✌🏼 👊🏼 ✊🏼 ✋🏼 💪🏼 👐🏼 🙌🏼 👏🏼 🙏🏼 🖖🏼️";
	NSString *moderateBrownEmojis = @"👦🏽 👧🏽 👨🏽 👩🏽 👮🏽 👰🏽 👱🏽 👲🏽 👳🏽 👴🏽 👵🏽 👶🏽 👷🏽 👸🏽 💂🏽 👼🏽 🎅🏽 🙇🏽 💁🏽 🙅🏽 🙆🏽 🙋🏽 🙎🏽 🙍🏽 💆🏽 💇🏽 💅🏽 👂🏽 👃🏽 👋🏽 👍🏽 👎🏽 ☝🏽 👆🏽 👇🏽 👈🏽 👉🏽 👌🏽 ✌🏽 👊🏽 ✊🏽 ✋🏽 💪🏽 👐🏽 🙌🏽 👏🏽 🙏🏽 🖖🏽️";
	NSString *darkBrownEmojis = @"👦🏾 👧🏾 👨🏾 👩🏾 👮🏾 👰🏾 👱🏾 👲🏾 👳🏾 👴🏾 👵🏾 👶🏾 👷🏾 👸🏾 💂🏾 👼🏾 🎅🏾 🙇🏾 💁🏾 🙅🏾 🙆🏾 🙋🏾 🙎🏾 🙍🏾 💆🏾 💇🏾 💅🏾 👂🏾 👃🏾 👋🏾 👍🏾 👎🏾 ☝🏾 👆🏾 👇🏾 👈🏾 👉🏾 👌🏾 ✌🏾 👊🏾 ✊🏾 ✋🏾 💪🏾 👐🏾 🙌🏾 👏🏾 🙏🏾 🖖🏾️";
	NSString *blackEmojis = @"👦🏿 👧🏿 👨🏿 👩🏿 👮🏿 👰🏿 👱🏿 👲🏿 👳🏿 👴🏿 👵🏿 👶🏿 👷🏿 👸🏿 💂🏿 👼🏿 🎅🏿 🙇🏿 💁🏿 🙅🏿 🙆🏿 🙋🏿 🙎🏿 🙍🏿 💆🏿 💇🏿 💅🏿 👂🏿 👃🏿 👋🏿 👍🏿 👎🏿 ☝🏿 👆🏿 👇🏿 👈🏿 👉🏿 👌🏿 ✌🏿 👊🏿 ✊🏿 ✋🏿 💪🏿 👐🏿 🙌🏿 👏🏿 🙏🏿 🖖🏿️";
	NSArray *skin2 = [paleEmojis componentsSeparatedByString:@" "];
	NSArray *skin3 = [creamEmojis componentsSeparatedByString:@" "];
	NSArray *skin4 = [moderateBrownEmojis componentsSeparatedByString:@" "];
	NSArray *skin5 = [darkBrownEmojis componentsSeparatedByString:@" "];
	NSArray *skin6 = [blackEmojis componentsSeparatedByString:@" "];
	for (NSUInteger index = 0; index < diverseTargets.count; index++) {
		NSString *diverseTarget = diverseTargets[index];
		for (UIKeyboardEmoji *originalEmo in emoji) {
			if ([originalEmo.emojiString isEqualToString:diverseTarget]) {
				NSUInteger indexOfTarget = [array indexOfObject:originalEmo];
				if (indexOfTarget != NSNotFound) {
					UIKeyboardEmoji *emo6 = emojiFromStringAndDingbat(skin6[index], YES);
					UIKeyboardEmoji *emo5 = emojiFromStringAndDingbat(skin5[index], YES);
					UIKeyboardEmoji *emo4 = emojiFromStringAndDingbat(skin4[index], YES);
					UIKeyboardEmoji *emo3 = emojiFromStringAndDingbat(skin3[index], YES);
					UIKeyboardEmoji *emo2 = emojiFromStringAndDingbat(skin2[index], YES);
					[array insertObject:emo6 atIndex:indexOfTarget + 1];
					[array insertObject:emo5 atIndex:indexOfTarget + 1];
					[array insertObject:emo4 atIndex:indexOfTarget + 1];
					[array insertObject:emo3 atIndex:indexOfTarget + 1];
					[array insertObject:emo2 atIndex:indexOfTarget + 1];
				}
			}
		}
	}
	emojiObject.emoji = array;
}

static void updateCategory(UIKeyboardEmojiCategory *category, int type)
{
	[[NSClassFromString(@"UIKeyboardEmojiCategory") categories] replaceObjectAtIndex:type withObject:category];
}

BOOL added1;
BOOL added4;

%hook UIKeyboardEmojiCategory

+ (UIKeyboardEmojiCategory *)categoryForType:(int)type
{
	UIKeyboardEmojiCategory *category = %orig;
	if (type == 1 && !added1) {
		addVulcanEmoji(category);
		addFamilyEmojis(category);
		addDiverseEmojis(category);
		updateCategory(category, type);
		added1 = YES;
	}
	if (type == 4 && !added4) {
		addFlagEmojis(category);
		updateCategory(category, type);
		added4 = YES;
	}
	return category;
}

- (void)releaseCategories
{
	%orig;
	added1 = NO;
	added4 = NO;
}

%end

/*%hook UIKeyboardImpl

- (void)deleteBackwardAndNotify:(BOOL)notify
{
	BOOL oneMore = NO;
	NSString *text = [[self inputDelegate] text];
	if (text) {
		NSString *lastChar = [text substringFromIndex:[text length] - 1];
		oneMore = isSkinTone(lastChar);
	}
	%orig;
	if (oneMore)
		%orig;
}

%end*/

%group preiOS7

%hook UIKeyboardEmoji

static char _dingbat;

%new
+ (UIKeyboardEmoji *)emojiWithString:(NSString *)string hasDingbat:(BOOL)dingbat
{
	self = [self emojiWithString:string];
	objc_setAssociatedObject(self, &_dingbat, @(dingbat), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	return self;
}

%new
- (id)initWithString:(NSString *)string hasDingbat:(BOOL)dingbat
{
	self = [[$UIKeyboardEmoji alloc] initWithString:string];
	objc_setAssociatedObject(self, &_dingbat, @(dingbat), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	return self;
}

%new
- (BOOL)hasDingbat
{
	return [objc_getAssociatedObject(self, &_dingbat) boolValue];
}

%end

%hook UIKeyboardEmojiInputController

- (void)emojiUsed:(UIKeyboardEmoji *)emoji
{
	/*if (emoji.hasDingbat)
		emoji.emojiString = [NSString stringWithFormat:@"%@%@", emoji.emojiString];*/
	%orig;
}

%end

%end

%ctor
{
	$UIKeyboardEmoji = NSClassFromString(@"UIKeyboardEmoji");
	if (!isiOS7Up) {
		%init(preiOS7);
	}
	%init;
}