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
@property(getter=recentDescription,readonly) NSString *recentDescription;
+ (NSMutableArray *)categories;
+ (UIKeyboardEmojiCategory *)categoryForType:(int)type;
+ (NSArray *)emojiRecentsFromPreferences;
+ (bool)hasVariantsForEmoji:(id)emoji;
+ (NSString *)localizedStringForKey:(NSString *)key;
+ (NSInteger)numberOfCategories;
- (NSString *)displaySymbol;
- (void)releaseCategories;
@end

@interface UIKeyboardEmoji : NSObject {
    NSString *_emojiString;
    bool _hasDingbat;
}
@property(retain) NSString *emojiString;
@property bool hasDingbat;
+ (UIKeyboardEmoji *)emojiWithString:(NSString *)string hasDingbat:(bool)dingbat;
- (id)initWithString:(NSString *)string hasDingbat:(bool)arg2;
- (bool)isEqual:(UIKeyboardEmoji *)emoji;
- (NSString *)key; // emojiString
@end

static void addEmojisForIndexAtIndex(UIKeyboardEmojiCategory *emojiObject, NSArray *myEmojis, NSUInteger index, NSUInteger emojiIndex, BOOL dingbat)
{
	NSArray *emoji = emojiObject.emoji;
	if (emoji.count != 0 && myEmojis.count != 0) {
		NSMutableArray *array = [NSMutableArray array];
		[array addObjectsFromArray:emoji];
		for (NSString *myEmoji in myEmojis) {
			UIKeyboardEmoji *emo = [%c(UIKeyboardEmoji) emojiWithString:myEmoji hasDingbat:dingbat];
			if (![array containsObject:emo]) {
				if (emojiIndex != 0 && emojiIndex < array.count) {
					[array insertObject:emo atIndex:emojiIndex];
				}
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
	addEmojisForIndexAtIndex(emojiObject, families, 1, 129, YES);
}

static void updateCategory(UIKeyboardEmojiCategory *category, int type)
{
	[[%c(UIKeyboardEmojiCategory) categories] replaceObjectAtIndex:type withObject:category];
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

%end

%ctor
{
	%init;
}