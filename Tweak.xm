#import "../PS.h"
#import <CoreGraphics/CoreGraphics.h>

@interface NSCharacterSet (Private)
- (NSUInteger)count;
@end

@interface NSString (Private)
- (BOOL)_containsEmoji;
@end

@protocol textInputDelegate
- (NSString *)text;
@end

@interface UIKeyboardImpl : NSObject
- (id <textInputDelegate> )inputDelegate;
@end

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
+ (NSString *)stringWithUnichar:(unsigned long)aChar;
- (unichar)_firstLongCharacter;
@end

static NSString *emojiFromUnicode(UniChar *unicode)
{
	NSString *_emoji = [[NSString alloc] initWithBytes:&unicode length:sizeof(unicode) encoding:NSUTF32LittleEndianStringEncoding];
	NSString *emoji = _emoji;
	[_emoji release];
	return emoji;
	//return [NSString stringWithUnichar:unicode];
}

static UniChar *_unicodeFromEmoji(NSString *emoji)
{
	NSData *data = [emoji dataUsingEncoding:NSUTF32LittleEndianStringEncoding];
	UniChar *unicode;
	[data getBytes:&unicode length:sizeof(unicode)];
	return unicode;
}

static NSString *unicodeFromEmoji(NSString *emoji)
{
	UniChar *unicode = _unicodeFromEmoji(emoji);
	return [NSString stringWithFormat:@"%lx", (unsigned long)unicode];
}

Class $UIKeyboardEmoji;

static UIKeyboardEmoji *emojiFromString(NSString *myEmoji)
{
	NSString *unicode = unicodeFromEmoji(myEmoji);
	BOOL dingbat = [unicode isEqualToString:@"261d"] || [unicode isEqualToString:@"270c"];
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

static void addFlagEmojis(UIKeyboardEmojiCategory *emojiObject)
{
	NSString *flagsString = @"🇦🇫 🇦🇱 🇩🇿 🇦🇸 🇦🇩 🇦🇴 🇦🇮 🇦🇬 🇦🇷 🇦🇲 🇦🇼 🇦🇺 🇦🇹 🇦🇿 🇧🇸 🇧🇭 🇧🇩 🇧🇧 🇧🇾 🇧🇪 🇧🇿 🇧🇯 🇧🇲 🇧🇹 🇧🇴 🇧🇦 🇧🇼 🇧🇷 🇧🇳 🇧🇬 🇧🇫 🇧🇮 🇰🇭 🇨🇲 🇨🇦 🇨🇻 🇰🇾 🇨🇫 🇨🇱 🇨🇴 🇰🇲 🇨🇩 🇨🇬 🇨🇰 🇨🇷 🇭🇷 🇨🇺 🇨🇼 🇨🇾 🇨🇿 🇩🇰 🇩🇯 🇩🇲 🇩🇴 🇪🇨 🇪🇬 🇸🇻 🇬🇶 🇪🇷 🇪🇪 🇪🇹 🇫🇴 🇫🇯 🇫🇮 🇫🇷 🇬🇫 🇹🇫 🇬🇦 🇬🇲 🇬🇪 🇬🇭 🇬🇮 🇬🇷 🇬🇩 🇬🇵 🇬🇺 🇬🇹 🇬🇳 🇬🇼 🇬🇾 🇭🇹 🇭🇳 🇭🇰 🇭🇺 🇮🇸 🇮🇳 🇮🇩 🇮🇷 🇮🇶 🇮🇪 🇮🇱 🇨🇮 🇯🇲 🇯🇴 🇰🇿 🇰🇪 🇰🇮 🇰🇼 🇰🇬 🇱🇦 🇱🇻 🇱🇧 🇱🇸 🇱🇷 🇱🇾 🇱🇮 🇱🇹 🇱🇺 🇲🇴 🇲🇰 🇲🇬 🇲🇼 🇲🇾 🇲🇻 🇲🇱 🇲🇹 🇲🇶 🇲🇷 🇲🇽 🇲🇩 🇲🇳 🇲🇪 🇲🇸 🇲🇦 🇲🇿 🇲🇲 🇳🇦 🇳🇵 🇳🇱 🇳🇨 🇳🇿 🇳🇮 🇳🇪 🇳🇬 🇳🇺 🇰🇵 🇲🇵 🇳🇴 🇴🇲 🇵🇰 🇵🇼 🇵🇸 🇵🇦 🇵🇬 🇵🇾 🇵🇪 🇵🇭 🇵🇱 🇵🇹 🇵🇷 🇶🇦 🇷🇴 🇷🇼 🇼🇸 🇸🇲 🇸🇹 🇸🇦 🇸🇳 🇷🇸 🇸🇨 🇸🇱 🇸🇬 🇸🇰 🇸🇮 🇸🇧 🇸🇴 🇿🇦 🇸🇸 🇱🇰 🇸🇩 🇸🇷 🇸🇿 🇸🇪 🇨🇭 🇸🇾 🇹🇯 🇹🇿 🇹🇭 🇹🇱 🇹🇬 🇹🇴 🇹🇹 🇹🇳 🇹🇷 🇹🇲 🇹🇨 🇹🇻 🇺🇬 🇺🇦 🇦🇪 🇺🇾 🇺🇿 🇻🇺 🇻🇪 🇻🇳 🇾🇪 🇿🇲 🇿🇼";
	NSArray *flags = [flagsString componentsSeparatedByString:@" "];
	addEmojisForIndexWithDingbat(emojiObject, flags, 4);
}

static NSArray *families()
{
	return @[@"👨‍👨‍👧‍👧", @"👨‍👨‍👦‍👦", @"👨‍👨‍👧‍👦", @"👨‍👨‍👧", @"👨‍👨‍👦", @"👩‍👩‍👧‍👧", @"👩‍👩‍👦‍👦", @"👩‍👩‍👧‍👦", @"👩‍👩‍👧", @"👩‍👩‍👦", @"👨‍👩‍👧‍👧", @"👨‍👩‍👦‍👦", @"👨‍👩‍👧"];
}

static void addFamilyEmojis(UIKeyboardEmojiCategory *emojiObject)
{
	addEmojisForIndexAtIndex(emojiObject, families(), 1, 129);
}

static NSMutableArray *_paleEmojis(NSArray *diverseTarget)
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSString *emoji in diverseTarget) {
		NSString *skin = [NSString stringWithFormat:@"%@%@", [NSString stringWithUnichar:[emoji _firstLongCharacter]], @"🏻"];
		[array addObject:skin];
	}
	return array;
}

static NSMutableArray *_creamEmojis(NSArray *diverseTarget)
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSString *emoji in diverseTarget) {
		NSString *skin = [NSString stringWithFormat:@"%@%@", [NSString stringWithUnichar:[emoji _firstLongCharacter]], @"🏼"];
		[array addObject:skin];
	}
	return array;
}

static NSMutableArray *_moderateBrownEmojis(NSArray *diverseTarget)
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSString *emoji in diverseTarget) {
		NSString *skin = [NSString stringWithFormat:@"%@%@", [NSString stringWithUnichar:[emoji _firstLongCharacter]], @"🏽"];
		[array addObject:skin];
	}
	return array;
}

static NSMutableArray *_darkBrownEmojis(NSArray *diverseTarget)
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSString *emoji in diverseTarget) {
		NSString *skin = [NSString stringWithFormat:@"%@%@", [NSString stringWithUnichar:[emoji _firstLongCharacter]], @"🏾"];
		[array addObject:skin];
	}
	return array;
}

static NSMutableArray *_blackEmojis(NSArray *diverseTarget)
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSString *emoji in diverseTarget) {
		NSString *skin = [NSString stringWithFormat:@"%@%@", [NSString stringWithUnichar:[emoji _firstLongCharacter]], @"🏿"];
		[array addObject:skin];
	}
	return array;
}

static void findOriginalEmojiIndexAndAddDiversity(NSMutableArray *array, NSArray *diverseTargets, NSArray *emoji)
{
	NSArray *skin2 = _paleEmojis(diverseTargets);
	NSArray *skin3 = _creamEmojis(diverseTargets);
	NSArray *skin4 = _moderateBrownEmojis(diverseTargets);
	NSArray *skin5 = _darkBrownEmojis(diverseTargets);
	NSArray *skin6 = _blackEmojis(diverseTargets);
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
}

static void addVulcanEmojis(UIKeyboardEmojiCategory *emojiObject)
{
	addEmojisForIndexAtIndex(emojiObject, @[[NSString stringWithUnichar:0x1F596]], 1, 123);
}

static void addDiverseEmojis1(UIKeyboardEmojiCategory *emojiObject)
{
	NSArray *emoji = emojiObject.emoji;
	if (emoji.count == 0)
		return;
	NSMutableArray *array = [NSMutableArray array];
	[array addObjectsFromArray:emoji];
	NSArray *diverseTargets = @[@"👦", @"👧", @"👨", @"👩", @"👮", @"👰", @"👱", @"👲", @"👳", @"👴", @"👵", @"👶", @"👷", @"👸", @"💂", @"👼", @"🙇", @"💁", @"🙅", @"🙆", @"🙋", @"🙎", @"🙍", @"💆", @"💇",
								@"💅", @"👂", @"👃", @"👋", @"👍", @"👎", @"☝", @"👆", @"👇",@"👈", @"👉", @"👌", @"✌", @"👊", @"✊", @"✋", @"💪", @"👐", @"🙌", @"👏", @"🙏", @"🏃", @"🚶", @"💃", [NSString stringWithUnichar:0x1F596]];
	findOriginalEmojiIndexAndAddDiversity(array, diverseTargets, emoji);
	emojiObject.emoji = array;
}

static void addDiverseEmojis3(UIKeyboardEmojiCategory *emojiObject)
{
	NSArray *emoji = emojiObject.emoji;
	if (emoji.count == 0)
		return;
	NSMutableArray *array = [NSMutableArray array];
	[array addObjectsFromArray:emoji];
	NSArray *diverseTargets = @[@"🎅", @"🚣", @"🏊", @"🏄", @"🛀", @"🚴", @"🚵", @"🏇"];
	findOriginalEmojiIndexAndAddDiversity(array, diverseTargets, emoji);
	emojiObject.emoji = array;
}

static NSArray *mmwws()
{
	return @[@"👨‍❤️‍👨", @"👩‍❤️‍👩"];
}

static NSArray *mmwwks()
{
	return @[@"👨‍❤️‍💋‍👨", @"👩‍❤️‍💋‍👩"];
}

static void addMMWWEmojis(UIKeyboardEmojiCategory *emojiObject)
{
	addEmojisForIndexAtIndex(emojiObject, @[mmwwks()[0]], 1, 145);
	addEmojisForIndexAtIndex(emojiObject, @[mmwwks()[1]], 1, 145);
	addEmojisForIndexAtIndex(emojiObject, @[mmwws()[0]], 1, 148);
	addEmojisForIndexAtIndex(emojiObject, @[mmwws()[1]], 1, 148);
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
		addVulcanEmojis(category);
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

static BOOL isSkinTone(NSString *skin)
{
	NSString *unicode = unicodeFromEmoji(skin);
	return [unicode hasPrefix:@"1f3f"];
}

%hook UIKeyboardImpl

- (void)deleteBackwardAndNotify:(BOOL)notify
{
	NSInteger count = 0;
	BOOL skin = NO;
	BOOL mmww = NO;
	BOOL mmwwk = NO;
	BOOL fam3 = NO;
	BOOL fam4 = NO;
	NSString *text = [[self inputDelegate] text];
	NSUInteger length = text.length;
	if (length >= 2) {
		NSString *skinLike = [text substringFromIndex:length - 2];
		skin = isSkinTone(skinLike);
		if (length >= 8) {
			NSString *like8 = [text substringFromIndex:length - 8];
			mmww = [mmwws() containsObject:like8];
			fam3 = [families() containsObject:like8];
			if (length >= 11) {
				NSString *like11 = [text substringFromIndex:length - 11];
				mmwwk = [mmwwks() containsObject:like11];
				fam4 = [families() containsObject:like11];
			}
		}
	}
	if (skin)
		count++;
	else if (mmww || fam3)
		count += 4;
	else if (mmwwk || fam4)
		count += 6;
	%orig;
	if (count > 0) {
		do {
			%orig;
			count--;
		} while (count > 0);
	}
}

%end

%ctor
{
	$UIKeyboardEmoji = NSClassFromString(@"UIKeyboardEmoji");
	%init;
}