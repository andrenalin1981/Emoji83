#import "../PS.h"
//#import <CoreText/CoreText.h>

@interface NSCharacterSet (Private)
- (NSUInteger)count;
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
+ (NSString *)stringWithUnichar:(UniChar *)aChar;
- (unichar)_firstLongCharacter;
@end

static NSString *emojiFromUnicode(UniChar *unicode)
{
	return [NSString stringWithUnichar:unicode];
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

static void addFlagEmojis(UIKeyboardEmojiCategory *emojiObject)
{
	NSString *flagsString = @"🇦🇫 🇦🇱 🇩🇿 🇦🇸 🇦🇩 🇦🇴 🇦🇮 🇦🇬 🇦🇷 🇦🇲 🇦🇼 🇦🇺 🇦🇹 🇦🇿 🇧🇸 🇧🇭 🇧🇩 🇧🇧 🇧🇾 🇧🇪 🇧🇿 🇧🇯 🇧🇲 🇧🇹 🇧🇴 🇧🇦 🇧🇼 🇧🇷 🇧🇳 🇧🇬 🇧🇫 🇧🇮 🇰🇭 🇨🇲 🇨🇦 🇨🇻 🇰🇾 🇨🇫 🇨🇱 🇨🇴 🇰🇲 🇨🇩 🇨🇬 🇨🇰 🇨🇷 🇭🇷 🇨🇺 🇨🇼 🇨🇾 🇨🇿 🇩🇰 🇩🇯 🇩🇲 🇩🇴 🇪🇨 🇪🇬 🇸🇻 🇬🇶 🇪🇷 🇪🇪 🇪🇹 🇫🇴 🇫🇯 🇫🇮 🇫🇷 🇬🇫 🇹🇫 🇬🇦 🇬🇲 🇬🇪 🇬🇭 🇬🇮 🇬🇷 🇬🇩 🇬🇵 🇬🇺 🇬🇹 🇬🇳 🇬🇼 🇬🇾 🇭🇹 🇭🇳 🇭🇰 🇭🇺 🇮🇸 🇮🇳 🇮🇩 🇮🇷 🇮🇶 🇮🇪 🇮🇱 🇨🇮 🇯🇲 🇯🇴 🇰🇿 🇰🇪 🇰🇮 🇰🇼 🇰🇬 🇱🇦 🇱🇻 🇱🇧 🇱🇸 🇱🇷 🇱🇾 🇱🇮 🇱🇹 🇱🇺 🇲🇴 🇲🇰 🇲🇬 🇲🇼 🇲🇾 🇲🇻 🇲🇱 🇲🇹 🇲🇶 🇲🇷 🇲🇽 🇲🇩 🇲🇳 🇲🇪 🇲🇸 🇲🇦 🇲🇿 🇲🇲 🇳🇦 🇳🇵 🇳🇱 🇳🇨 🇳🇿 🇳🇮 🇳🇪 🇳🇬 🇳🇺 🇰🇵 🇲🇵 🇳🇴 🇴🇲 🇵🇰 🇵🇼 🇵🇸 🇵🇦 🇵🇬 🇵🇾 🇵🇪 🇵🇭 🇵🇱 🇵🇹 🇵🇷 🇶🇦 🇷🇴 🇷🇼 🇼🇸 🇸🇲 🇸🇹 🇸🇦 🇸🇳 🇷🇸 🇸🇨 🇸🇱 🇸🇬 🇸🇰 🇸🇮 🇸🇧 🇸🇴 🇿🇦 🇸🇸 🇱🇰 🇸🇩 🇸🇷 🇸🇿 🇸🇪 🇨🇭 🇸🇾 🇹🇯 🇹🇿 🇹🇭 🇹🇱 🇹🇬 🇹🇴 🇹🇹 🇹🇳 🇹🇷 🇹🇲 🇹🇨 🇹🇻 🇺🇬 🇺🇦 🇦🇪 🇺🇾 🇺🇿 🇻🇺 🇻🇪 🇻🇳 🇾🇪 🇿🇲 🇿🇼";
	NSArray *flags = [flagsString componentsSeparatedByString:@" "];
	addEmojisForIndexWithDingbat(emojiObject, flags, 4);
}

static void addEmoByUnicodeToArray3(NSMutableArray *array, unsigned short first, unsigned short second, unsigned short skinType)
{
	unichar emo[3] = { first, second, skinType };
	NSString *string = [[NSString alloc] initWithCharacters:emo length:3];
	[array addObject:string];
	[string release];
}

static void addEmoByUnicodeToArray4(NSMutableArray *array, unsigned short first, unsigned short second, unsigned short third, unsigned short skinType)
{
	unichar emo[4] = { first, second, third, skinType };
	NSString *string = [[NSString alloc] initWithCharacters:emo length:4];
	[array addObject:string];
	[string release];
}

static void addEmoByUnicodeToArray8(NSMutableArray *array, unsigned short second, unsigned short fifth, unsigned short eighth)
{
	unichar emo[8] = { 0xD83D, second, 0x200D, 0xD83D, fifth, 0x200D, 0xD83D, eighth };
	NSString *string = [[NSString alloc] initWithCharacters:emo length:8];
	[array addObject:string];
	[string release];
}

static void addEmoByUnicodeToArray11(NSMutableArray *array, unsigned short second, unsigned short fifth, unsigned short eighth, unsigned short eleventh)
{
	unichar emo[11] = { 0xD83D, second, 0x200D, 0xD83D, fifth, 0x200D, 0xD83D, eighth, 0x200D, 0xD83D, eleventh };
	NSString *string = [[NSString alloc] initWithCharacters:emo length:11];
	[array addObject:string];
	[string release];
}

static NSArray *vulcans()
{
	NSMutableArray *array = [NSMutableArray array];
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDD96, 0xD83C, 0xDFFF);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDD96, 0xD83C, 0xDFFE);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDD96, 0xD83C, 0xDFFD);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDD96, 0xD83C, 0xDFFC);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDD96, 0xD83C, 0xDFFB);
	unichar vulcan[2] = { 0xD83D, 0xDD96 };
	NSString *string = [[NSString alloc] initWithCharacters:vulcan length:2];
	[array addObject:string];
	[string release];
	return array;
}

static void addVulcanEmojis(UIKeyboardEmojiCategory *emojiObject)
{
	addEmojisForIndexAtIndex(emojiObject, vulcans(), 1, 123);
}

static NSArray *families()
{
	NSMutableArray *array = [NSMutableArray array];
	addEmoByUnicodeToArray11(array, 0xDC68, 0xDC68, 0xDC67, 0xDC67);
	addEmoByUnicodeToArray11(array, 0xDC68, 0xDC68, 0xDC66, 0xDC66);
	addEmoByUnicodeToArray11(array, 0xDC68, 0xDC68, 0xDC67, 0xDC66);
	addEmoByUnicodeToArray8(array, 0xDC68, 0xDC68, 0xDC67);
	addEmoByUnicodeToArray8(array, 0xDC68, 0xDC68, 0xDC66);
	addEmoByUnicodeToArray11(array, 0xDC69, 0xDC69, 0xDC67, 0xDC67);
	addEmoByUnicodeToArray11(array, 0xDC69, 0xDC69, 0xDC66, 0xDC66);
	addEmoByUnicodeToArray11(array, 0xDC69, 0xDC69, 0xDC67, 0xDC66);
	addEmoByUnicodeToArray8(array, 0xDC69, 0xDC69, 0xDC67);
	addEmoByUnicodeToArray8(array, 0xDC69, 0xDC69, 0xDC66);
	addEmoByUnicodeToArray11(array, 0xDC68, 0xDC69, 0xDC67, 0xDC67);
	addEmoByUnicodeToArray11(array, 0xDC68, 0xDC69, 0xDC66, 0xDC66);
	addEmoByUnicodeToArray11(array, 0xDC68, 0xDC69, 0xDC67, 0xDC66);
	addEmoByUnicodeToArray8(array, 0xDC68, 0xDC69, 0xDC67);
	return array;
}

static void addFamilyEmojis(UIKeyboardEmojiCategory *emojiObject)
{
	addEmojisForIndexAtIndex(emojiObject, families(), 1, 134);
}

static NSMutableArray *skinnedEmojis1(unsigned short skinType)
{
	NSMutableArray *array = [NSMutableArray array];
	addEmoByUnicodeToArray4(array, 0xD83C, 0xDFC3, 0xD83C, skinType);
	
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC42, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC43, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC46, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC47, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC48, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC49, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC4A, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC4C, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC4B, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC4D, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC4E, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC4F, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC50, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC66, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC67, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC68, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC69, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC6E, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC70, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC71, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC72, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC73, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC74, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC75, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC76, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC77, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC78, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC7C, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC81, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC82, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC83, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC85, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC86, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDC87, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDCAA, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDE45, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDE46, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDE47, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDE4B, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDE4C, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDE4D, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDE4E, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDE4F, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDEB6, 0xD83C, skinType);
	
	addEmoByUnicodeToArray3(array, 0x261D, 0xD83C, skinType);
	addEmoByUnicodeToArray3(array, 0x270A, 0xD83C, skinType);
	addEmoByUnicodeToArray3(array, 0x270B, 0xD83C, skinType);
	addEmoByUnicodeToArray3(array, 0x270C, 0xD83C, skinType);
	
	return array;
}

static NSMutableArray *skinnedEmojis3(unsigned short skinType)
{
	NSMutableArray *array = [NSMutableArray array];
	addEmoByUnicodeToArray4(array, 0xD83C, 0xDF85, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83C, 0xDFC4, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83C, 0xDFC7, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83C, 0xDFCA, 0xD83C, skinType);
	
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDEA3, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDEB4, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDEB5, 0xD83C, skinType);
	addEmoByUnicodeToArray4(array, 0xD83D, 0xDEC0, 0xD83C, skinType);
	
	return array;
}

static NSMutableArray *_paleEmojis()
{
	return skinnedEmojis1(0xDFFB);
}

static NSMutableArray *_creamEmojis()
{
	return skinnedEmojis1(0xDFFC);
}

static NSMutableArray *_moderateBrownEmojis()
{
	return skinnedEmojis1(0xDFFD);
}

static NSMutableArray *_darkBrownEmojis()
{
	return skinnedEmojis1(0xDFFE);
}

static NSMutableArray *_blackEmojis()
{
	return skinnedEmojis1(0xDFFF);
}

static NSString *originalEmojiForSkinnedEmoji(NSString *emoji)
{
	/*NSString *unicode = unicodeFromEmoji(emoji);
	if ([unicode isEqualToString:@"270c"]) {
		return @"✌";
	}
	if ([unicode isEqualToString:@"261d"])
		return @"☝";*/
	UniChar *aChar = _unicodeFromEmoji(emoji);
	return emojiFromUnicode(aChar);
}

static void findOriginalEmojiIndexAndAddDiversity(NSMutableArray *array, NSArray *diverseTargets, NSArray *emoji, NSArray *skin2, NSArray *skin3, NSArray *skin4, NSArray *skin5, NSArray *skin6)
{
	for (NSString *diverseTarget in diverseTargets) {
		for (UIKeyboardEmoji *originalEmo in emoji) {
			if ([originalEmo.emojiString isEqualToString:diverseTarget]) {
				NSUInteger indexOfTarget = [array indexOfObject:originalEmo];
				if (indexOfTarget != NSNotFound) {
					for (NSString *skinnedEmo in skin6) {
						if ([diverseTarget isEqualToString:originalEmojiForSkinnedEmoji(skinnedEmo)]) {
							UIKeyboardEmoji *emo = emojiFromString(skinnedEmo);
							[array insertObject:emo atIndex:indexOfTarget + 1];
						}
					}
					for (NSString *skinnedEmo in skin5) {
						if ([diverseTarget isEqualToString:originalEmojiForSkinnedEmoji(skinnedEmo)]) {
							UIKeyboardEmoji *emo = emojiFromString(skinnedEmo);
							[array insertObject:emo atIndex:indexOfTarget + 1];
						}
					}
					for (NSString *skinnedEmo in skin4) {
						if ([diverseTarget isEqualToString:originalEmojiForSkinnedEmoji(skinnedEmo)]) {
							UIKeyboardEmoji *emo = emojiFromString(skinnedEmo);
							[array insertObject:emo atIndex:indexOfTarget + 1];
						}
					}
					for (NSString *skinnedEmo in skin3) {
						if ([diverseTarget isEqualToString:originalEmojiForSkinnedEmoji(skinnedEmo)]) {
							UIKeyboardEmoji *emo = emojiFromString(skinnedEmo);
							[array insertObject:emo atIndex:indexOfTarget + 1];
						}
					}
					for (NSString *skinnedEmo in skin2) {
						if ([diverseTarget isEqualToString:originalEmojiForSkinnedEmoji(skinnedEmo)]) {
							UIKeyboardEmoji *emo = emojiFromString(skinnedEmo);
							[array insertObject:emo atIndex:indexOfTarget + 1];
						}
					}
				}
			}
		}
	}
}

static void addDiverseEmojis1(UIKeyboardEmojiCategory *emojiObject)
{
	NSArray *emoji = emojiObject.emoji;
	if (emoji.count == 0)
		return;
	NSMutableArray *array = [NSMutableArray array];
	[array addObjectsFromArray:emoji];
	NSArray *diverseTargets = @[@"👦", @"👧", @"👨", @"👩", @"👮", @"👰", @"👱", @"👲", @"👳", @"👴", @"👵", @"👶", @"👷", @"👸", @"💂", @"👼", @"🙇", @"💁", @"🙅", @"🙆", @"🙋", @"🙎", @"🙍", @"💆", @"💇",
								@"💅", @"👂", @"👃", @"👋", @"👍", @"👎", @"☝", @"👆", @"👇",@"👈", @"👉", @"👌", @"✌", @"👊", @"✊", @"✋", @"💪", @"👐", @"🙌", @"👏", @"🙏", @"🏃", @"🚶", @"💃"];
	NSArray *skin2 = _paleEmojis();
	NSArray *skin3 = _creamEmojis();
	NSArray *skin4 = _moderateBrownEmojis();
	NSArray *skin5 = _darkBrownEmojis();
	NSArray *skin6 = _blackEmojis();
	findOriginalEmojiIndexAndAddDiversity(array, diverseTargets, emoji, skin2, skin3, skin4, skin5, skin6);
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
	NSArray *skin2 = skinnedEmojis3(0xDFFB);
	NSArray *skin3 = skinnedEmojis3(0xDFFC);
	NSArray *skin4 = skinnedEmojis3(0xDFFD);
	NSArray *skin5 = skinnedEmojis3(0xDFFE);
	NSArray *skin6 = skinnedEmojis3(0xDFFF);
	findOriginalEmojiIndexAndAddDiversity(array, diverseTargets, emoji, skin2, skin3, skin4, skin5, skin6);
	emojiObject.emoji = array;
}

static NSArray *mmwws()
{
	NSMutableArray *array = [NSMutableArray array];
	unichar mm[11] = { 0xD83D, 0xDC68, 0x200D, 0x2764, 0xFE0F, 0x200D, 0xD83D, 0xDC68 };
	NSString *mms = [[NSString alloc] initWithCharacters:mm length:8];
	[array addObject:mms];
	[mms release];
	unichar ww[11] = { 0xD83D, 0xDC69, 0x200D, 0x2764, 0xFE0F, 0x200D, 0xD83D, 0xDC69 };
	NSString *wws = [[NSString alloc] initWithCharacters:ww length:8];
	[array addObject:wws];
	[wws release];
	return array;
}

static NSArray *mmwwks()
{
	NSMutableArray *array = [NSMutableArray array];
	unichar mmk[11] = { 0xD83D, 0xDC68, 0x200D, 0x2764, 0xFE0F, 0x200D, 0xD83D, 0xDC8B, 0x200D, 0xD83D, 0xDC68 };
	NSString *mmks = [[NSString alloc] initWithCharacters:mmk length:11];
	[array addObject:mmks];
	[mmks release];
	unichar wwk[11] = { 0xD83D, 0xDC69, 0x200D, 0x2764, 0xFE0F, 0x200D, 0xD83D, 0xDC8B, 0x200D, 0xD83D, 0xDC69 };
	NSString *wwks = [[NSString alloc] initWithCharacters:wwk length:11];
	[array addObject:wwks];
	[wwks release];
	return array;
}

static void addMMWWEmojis(UIKeyboardEmojiCategory *emojiObject)
{
	addEmojisForIndexAtIndex(emojiObject, @[mmwwks()[0]], 1, 151);
	addEmojisForIndexAtIndex(emojiObject, @[mmwwks()[1]], 1, 151);
	addEmojisForIndexAtIndex(emojiObject, @[mmwws()[0]], 1, 154);
	addEmojisForIndexAtIndex(emojiObject, @[mmwws()[1]], 1, 154);
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
	if (text.length >= 2) {
		NSString *skinLike = [text substringFromIndex:text.length - 2];
		skin = isSkinTone(skinLike);
		if (text.length >= 8) {
			NSString *like8 = [text substringFromIndex:text.length - 8];
			mmww = [mmwws() containsObject:like8];
			fam3 = [families() containsObject:like8];
			if (text.length >= 11) {
				NSString *like11 = [text substringFromIndex:text.length - 11];
				mmwwk = [mmwwks() containsObject:like11];
				fam4 = [families() containsObject:like11];
			}
		}
	}
	if (skin)
		count++;
	if (mmww || fam3)
		count += 4;
	if (mmwwk || fam4)
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