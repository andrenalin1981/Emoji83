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

@interface NSString (Addition)
+ (NSString *)stringWithUnichar:(uint32_t)aChar;
@end

static NSString *emojiFromUnicode(uint32_t unicode)
{
	return [NSString stringWithUnichar:unicode];
}

static uint32_t _unicodeFromEmoji(NSString *emoji)
{
	NSData *data = [emoji dataUsingEncoding:NSUTF32LittleEndianStringEncoding];
	uint32_t unicode;
	[data getBytes:&unicode length:sizeof(unicode)];
	return unicode;
}

static NSString *unicodeFromEmoji(NSString *emoji)
{
	uint32_t unicode = _unicodeFromEmoji(emoji);
	return [NSString stringWithFormat:@"%x", unicode];
}

/*static NSArray *fitzpatricks()
{
	return @[@"1f3fb", @"1f3fc", @"1f3fd", @"1f3fe", @"1f3ff"];
}*/

static NSString *skinToneUnicodeForFitzpatrickType(int type)
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

static NSArray *diverseEmojisForEmojiString(NSString *emoji)
{
	NSMutableArray *emojis = [NSMutableArray arrayWithCapacity:5];
	for (int type = 6; type >= 2; type--) {
		NSString *skin = skinToneUnicodeForFitzpatrickType(type);
		NSString *diverseEmoji = [[NSString stringWithFormat:@"%@%@", emoji, skin] precomposedStringWithCanonicalMapping];
		[emojis addObject:diverseEmoji];
	}
	return emojis;
}

/*static BOOL isSkinTone(NSString *emoji)
{
	for (int type = 6; type >= 2; type--) {
		NSString *skin = skinToneUnicodeForFitzpatrickType(type);
		NSString *unicode = unicodeFromEmoji(skin);
		return [fitzpatricks() containsObject:unicode];
	}
	return NO;
}*/

Class $UIKeyboardEmoji;

static UIKeyboardEmoji *emojiFromString(NSString *myEmoji)
{
	NSString *unicode = unicodeFromEmoji(myEmoji);
	BOOL dingbat = [unicode isEqualToString:@"270a"] || [unicode isEqualToString:@"270b"];
	UIKeyboardEmoji *emo = [$UIKeyboardEmoji respondsToSelector:@selector(emojiWithString:hasDingbat:)] ?
									[$UIKeyboardEmoji emojiWithString:myEmoji hasDingbat:dingbat] :
									[$UIKeyboardEmoji emojiWithString:myEmoji];
	return emo;
}

static void addEmojisForIndexAtIndex(UIKeyboardEmojiCategory *emojiObject, NSArray *myEmojis, NSUInteger index, NSUInteger emojiIndex)
{
	NSArray *emoji = emojiObject.emoji;
	if (emoji.count != 0 && myEmojis.count != 0) {
		NSMutableArray *array = [NSMutableArray array];
		[array addObjectsFromArray:emoji];
		for (NSString *myEmoji in myEmojis) {
			UIKeyboardEmoji *emo = emojiFromString(myEmoji);
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
	addEmojisForIndexAtIndex(emojiObject, myEmojis, index, 0);
}

static void addVulcanEmoji(UIKeyboardEmojiCategory *emojiObject)
{
	addEmojisForIndexAtIndex(emojiObject, @[@"🖖"], 1, 123);
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
	addEmojisForIndexAtIndex(emojiObject, families, 1, 129);
}

static void addDiverseEmojis1(UIKeyboardEmojiCategory *emojiObject)
{
	NSArray *emoji = emojiObject.emoji;
	if (emoji.count == 0)
		return;
	NSMutableArray *array = [NSMutableArray array];
	[array addObjectsFromArray:emoji];
	NSArray *diverseTargets = @[@"👦", @"👧", @"👨", @"👩", @"👮", @"👰", @"👱", @"👲", @"👳", @"👴", @"👵", @"👶", @"👷", @"👸", @"💂", @"👼", @"🙇", @"💁", @"🙅", @"🙆", @"🙋", @"🙎", @"🙍", @"💆", @"💇",
								@"💅", @"👂", @"👃", @"👋", @"👍", @"👎", @"☝", @"👆", @"👇",@"👈", @"👉", @"👌", @"✌", @"👊", @"✊", @"✋", @"💪", @"👐", @"🙌", @"👏", @"🙏", @"🖖", @"🏃", @"🚶", @"💃"];
	NSString *paleEmojis = @"👦🏻 👧🏻 👨🏻 👩🏻 👮🏻 👰🏻 👱🏻 👲🏻 👳🏻 👴🏻 👵🏻 👶🏻 👷🏻 👸🏻 💂🏻 👼🏻 🙇🏻 💁🏻 🙅🏻 🙆🏻 🙋🏻 🙎🏻 🙍🏻 💆🏻 💇🏻 💅🏻 👂🏻 👃🏻 👋🏻 👍🏻 👎🏻 ☝🏻 👆🏻 👇🏻 👈🏻 👉🏻 👌🏻 ✌🏻 👊🏻 ✊🏻 ✋🏻 💪🏻 👐🏻 🙌🏻 👏🏻 🙏🏻 🖖🏻️ 🏃🏻 🚶🏻 💃🏻";
	NSString *creamEmojis = @"👦🏼 👧🏼 👨🏼 👩🏼 👮🏼 👰🏼 👱🏼 👲🏼 👳🏼 👴🏼 👵🏼 👶🏼 👷🏼 👸🏼 💂🏼 👼🏼 🙇🏼 💁🏼 🙅🏼 🙆🏼 🙋🏼 🙎🏼 🙍🏼 💆🏼 💇🏼 💅🏼 👂🏼 👃🏼 👋🏼 👍🏼 👎🏼 ☝🏼 👆🏼 👇🏼 👈🏼 👉🏼 👌🏼 ✌🏼 👊🏼 ✊🏼 ✋🏼 💪🏼 👐🏼 🙌🏼 👏🏼 🙏🏼 🖖🏼️ 🏃🏼 🚶🏼 💃🏼";
	NSString *moderateBrownEmojis = @"👦🏽 👧🏽 👨🏽 👩🏽 👮🏽 👰🏽 👱🏽 👲🏽 👳🏽 👴🏽 👵🏽 👶🏽 👷🏽 👸🏽 💂🏽 👼🏽 🙇🏽 💁🏽 🙅🏽 🙆🏽 🙋🏽 🙎🏽 🙍🏽 💆🏽 💇🏽 💅🏽 👂🏽 👃🏽 👋🏽 👍🏽 👎🏽 ☝🏽 👆🏽 👇🏽 👈🏽 👉🏽 👌🏽 ✌🏽 👊🏽 ✊🏽 ✋🏽 💪🏽 👐🏽 🙌🏽 👏🏽 🙏🏽 🖖🏽️ 🏃🏽 🚶🏽 💃🏽";
	NSString *darkBrownEmojis = @"👦🏾 👧🏾 👨🏾 👩🏾 👮🏾 👰🏾 👱🏾 👲🏾 👳🏾 👴🏾 👵🏾 👶🏾 👷🏾 👸🏾 💂🏾 👼🏾 🙇🏾 💁🏾 🙅🏾 🙆🏾 🙋🏾 🙎🏾 🙍🏾 💆🏾 💇🏾 💅🏾 👂🏾 👃🏾 👋🏾 👍🏾 👎🏾 ☝🏾 👆🏾 👇🏾 👈🏾 👉🏾 👌🏾 ✌🏾 👊🏾 ✊🏾 ✋🏾 💪🏾 👐🏾 🙌🏾 👏🏾 🙏🏾 🖖🏾️ 🏃🏾 🚶🏾 💃🏾";
	NSString *blackEmojis = @"👦🏿 👧🏿 👨🏿 👩🏿 👮🏿 👰🏿 👱🏿 👲🏿 👳🏿 👴🏿 👵🏿 👶🏿 👷🏿 👸🏿 💂🏿 👼🏿 🙇🏿 💁🏿 🙅🏿 🙆🏿 🙋🏿 🙎🏿 🙍🏿 💆🏿 💇🏿 💅🏿 👂🏿 👃🏿 👋🏿 👍🏿 👎🏿 ☝🏿 👆🏿 👇🏿 👈🏿 👉🏿 👌🏿 ✌🏿 👊🏿 ✊🏿 ✋🏿 💪🏿 👐🏿 🙌🏿 👏🏿 🙏🏿 🖖🏿️ 🏃🏿 🚶🏿 💃🏿";
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
					UIKeyboardEmoji *emo6 = emojiFromString(skin6[index]);
					UIKeyboardEmoji *emo5 = emojiFromString(skin5[index]);
					UIKeyboardEmoji *emo4 = emojiFromString(skin4[index]);
					UIKeyboardEmoji *emo3 = emojiFromString(skin3[index]);
					UIKeyboardEmoji *emo2 = emojiFromString(skin2[index]);
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

static void addDiverseEmojis3(UIKeyboardEmojiCategory *emojiObject)
{
	NSArray *emoji = emojiObject.emoji;
	if (emoji.count == 0)
		return;
	NSMutableArray *array = [NSMutableArray array];
	[array addObjectsFromArray:emoji];
	NSString *emojis = @"🎅 🚣 🏊 🏄 🛀 🚴 🚵 🏇";
	NSArray *diverseTargets = [emojis componentsSeparatedByString:@" "];
	for (NSUInteger index = 0; index < diverseTargets.count; index++) {
		NSString *diverseTarget = diverseTargets[index];
		for (UIKeyboardEmoji *originalEmo in emoji) {
			if ([originalEmo.emojiString isEqualToString:diverseTarget]) {
				NSUInteger indexOfTarget = [array indexOfObject:originalEmo];
				if (indexOfTarget != NSNotFound) {
					NSArray *diverses = diverseEmojisForEmojiString(diverseTarget);
					for (NSString *diverse in diverses) {
						UIKeyboardEmoji *emo = emojiFromString(diverse);
						[array insertObject:emo atIndex:indexOfTarget + 1];
					}
				}
			}
		}
	}
	emojiObject.emoji = array;
}

static void addMMWWEmojis(UIKeyboardEmojiCategory *emojiObject)
{
	addEmojisForIndexAtIndex(emojiObject, @[@"👨‍❤️‍💋‍👨"], 1, 145);
	addEmojisForIndexAtIndex(emojiObject, @[@"👩‍❤️‍💋‍👩"], 1, 145);
	addEmojisForIndexAtIndex(emojiObject, @[@"👨‍❤️‍👨"], 1, 148);
	addEmojisForIndexAtIndex(emojiObject, @[@"👩‍❤️‍👩"], 1, 148);
}

static void updateCategory(UIKeyboardEmojiCategory *category, int type)
{
	[[NSClassFromString(@"UIKeyboardEmojiCategory") categories] replaceObjectAtIndex:type withObject:category];
}

BOOL added1;
BOOL added3;
BOOL added4;

%hook UIKeyboardEmojiCategory

+ (UIKeyboardEmojiCategory *)categoryForType:(int)type
{
	UIKeyboardEmojiCategory *category = %orig;
	if (type == 1 && !added1) {
		addVulcanEmoji(category);
		addFamilyEmojis(category);
		addMMWWEmojis(category);
		addDiverseEmojis1(category);
		updateCategory(category, type);
		added1 = YES;
	}
	if (type == 3 && !added3) {
		addDiverseEmojis3(category);
		updateCategory(category, type);
		added3 = YES;
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
	added3 = NO;
	added4 = NO;
}

%end

/*%hook UIKeyboardImpl

- (void)deleteBackwardAndNotify:(BOOL)notify
{
	BOOL oneMore = NO;
	NSString *text = [[self inputDelegate] text];
	if (text) {
		NSString *lastChar2 = [text substringFromIndex:[text length] - 2];
		oneMore = isSkinTone(lastChar2);
	}
	%orig;
	if (oneMore)
		%orig;
}

%end*/

%ctor
{
	$UIKeyboardEmoji = NSClassFromString(@"UIKeyboardEmoji");
	%init;
}