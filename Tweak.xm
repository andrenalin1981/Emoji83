#import "Emoji.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>

static NSString *emojiFromUnicode(unsigned long unicode)
{
	if (isiOS7Up)
		return [NSString stringWithUnichar:unicode];
	NSString *emoji = [[NSString alloc] initWithBytes:&unicode length:sizeof(unicode) encoding:NSUTF32LittleEndianStringEncoding];
	NSString *_emoji = emoji.copy;
	[emoji autorelease];
	return _emoji;
}

static unsigned long *_unicodeFromEmoji(NSString *emoji)
{
	NSData *data = [emoji dataUsingEncoding:NSUTF32LittleEndianStringEncoding];
	unsigned long *unicode;
	[data getBytes:&unicode length:sizeof(unicode)];
	return unicode;
}

static UIKeyboardEmoji *emojiFromString(NSString *myEmoji)
{
	UIKeyboardEmoji *emo = nil;
	unichar unicode = [myEmoji characterAtIndex:0];
	BOOL dingbat = unicode == 0x261d || unicode == 0x270c;
	emo = [NSClassFromString(@"UIKeyboardEmoji") respondsToSelector:@selector(emojiWithString:hasDingbat:)] ? [NSClassFromString(@"UIKeyboardEmoji") emojiWithString:myEmoji hasDingbat:dingbat]
			: [NSClassFromString(@"UIKeyboardEmoji") emojiWithString:myEmoji];
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

static void addEmojisForIndex(UIKeyboardEmojiCategory *emojiObject, NSArray *myEmojis, NSUInteger index)
{
	addEmojisForIndexAtIndex(emojiObject, myEmojis, index, 0);
}

static void addFlagEmojis(UIKeyboardEmojiCategory *emojiObject)
{
	NSString *flagsString = @"🇦🇫 🇦🇱 🇩🇿 🇦🇸 🇦🇩 🇦🇴 🇦🇮 🇦🇬 🇦🇷 🇦🇲 🇦🇼 🇦🇺 🇦🇹 🇦🇿 🇧🇸 🇧🇭 🇧🇩 🇧🇧 🇧🇾 🇧🇪 🇧🇿 🇧🇯 🇧🇲 🇧🇹 🇧🇴 🇧🇦 🇧🇼 🇧🇷 🇧🇳 🇧🇬 🇧🇫 🇧🇮 🇰🇭 🇨🇲 🇨🇦 🇨🇻 🇰🇾 🇨🇫 🇨🇱 🇨🇴 🇰🇲 🇨🇩 🇨🇬 🇨🇰 🇨🇷 🇭🇷 🇨🇺 🇨🇼 🇨🇾 🇨🇿 🇩🇰 🇩🇯 🇩🇲 🇩🇴 🇪🇨 🇪🇬 🇸🇻 🇬🇶 🇪🇷 🇪🇪 🇪🇹 🇫🇴 🇫🇯 🇫🇮 🇫🇷 🇬🇫 🇹🇫 🇬🇦 🇬🇲 🇬🇪 🇬🇭 🇬🇮 🇬🇷 🇬🇩 🇬🇵 🇬🇺 🇬🇹 🇬🇳 🇬🇼 🇬🇾 🇭🇹 🇭🇳 🇭🇰 🇭🇺 🇮🇸 🇮🇳 🇮🇩 🇮🇷 🇮🇶 🇮🇪 🇮🇱 🇨🇮 🇯🇲 🇯🇴 🇰🇿 🇰🇪 🇰🇮 🇰🇼 🇰🇬 🇱🇦 🇱🇻 🇱🇧 🇱🇸 🇱🇷 🇱🇾 🇱🇮 🇱🇹 🇱🇺 🇲🇴 🇲🇰 🇲🇬 🇲🇼 🇲🇾 🇲🇻 🇲🇱 🇲🇹 🇲🇶 🇲🇷 🇲🇽 🇲🇩 🇲🇳 🇲🇪 🇲🇸 🇲🇦 🇲🇿 🇲🇲 🇳🇦 🇳🇵 🇳🇱 🇳🇨 🇳🇿 🇳🇮 🇳🇪 🇳🇬 🇳🇺 🇰🇵 🇲🇵 🇳🇴 🇴🇲 🇵🇰 🇵🇼 🇵🇸 🇵🇦 🇵🇬 🇵🇾 🇵🇪 🇵🇭 🇵🇱 🇵🇹 🇵🇷 🇶🇦 🇷🇴 🇷🇼 🇼🇸 🇸🇲 🇸🇹 🇸🇦 🇸🇳 🇷🇸 🇸🇨 🇸🇱 🇸🇬 🇸🇰 🇸🇮 🇸🇧 🇸🇴 🇿🇦 🇸🇸 🇱🇰 🇸🇩 🇸🇷 🇸🇿 🇸🇪 🇨🇭 🇸🇾 🇹🇯 🇹🇿 🇹🇭 🇹🇱 🇹🇬 🇹🇴 🇹🇹 🇹🇳 🇹🇷 🇹🇲 🇹🇨 🇹🇻 🇺🇬 🇺🇦 🇦🇪 🇺🇾 🇺🇿 🇻🇺 🇻🇪 🇻🇳 🇾🇪 🇿🇲 🇿🇼";
	NSArray *flags = [flagsString componentsSeparatedByString:@" "];
	addEmojisForIndex(emojiObject, flags, 4);
}

static NSArray *families()
{
	return @[@"👨‍👩‍👧", @"👨‍👩‍👧‍👦", @"👨‍👩‍👦‍👦", @"👨‍👩‍👧‍👧", @"👩‍👩‍👦", @"👩‍👩‍👧", @"👩‍👩‍👧‍👦", @"👩‍👩‍👦‍👦", @"👩‍👩‍👧‍👧", @"👨‍👨‍👦", @"👨‍👨‍👧", @"👨‍👨‍👧‍👦", @"👨‍👨‍👦‍👦", @"👨‍👨‍👧‍👧"];
}

static void addFamilyEmojis(UIKeyboardEmojiCategory *emojiObject)
{
	addEmojisForIndexAtIndex(emojiObject, families(), 1, 129);
}

static NSString *skinnedEmoji(NSString *emoji, NSString *skin)
{
	NSString *_emoji = isiOS7Up ? [NSString stringWithUnichar:[emoji characterAtIndex:0]] : emoji;
	return [NSString stringWithFormat:@"%@%@", _emoji, skin];
}

static NSMutableArray *_paleEmojis(NSArray *diverseTarget)
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSString *emoji in diverseTarget) {
		[array addObject:skinnedEmoji(emoji, @"🏻")];
	}
	return array;
}

static NSMutableArray *_creamEmojis(NSArray *diverseTarget)
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSString *emoji in diverseTarget) {
		[array addObject:skinnedEmoji(emoji, @"🏼")];
	}
	return array;
}

static NSMutableArray *_moderateBrownEmojis(NSArray *diverseTarget)
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSString *emoji in diverseTarget) {
		[array addObject:skinnedEmoji(emoji, @"🏽")];
	}
	return array;
}

static NSMutableArray *_darkBrownEmojis(NSArray *diverseTarget)
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSString *emoji in diverseTarget) {
		[array addObject:skinnedEmoji(emoji, @"🏾")];
	}
	return array;
}

static NSMutableArray *_blackEmojis(NSArray *diverseTarget)
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSString *emoji in diverseTarget) {
		[array addObject:skinnedEmoji(emoji, @"🏿")];
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

static void addEmoji(NSMutableArray *emojiArray, NSString *string)
{
	UIKeyboardEmoji *emoji = emojiFromString(string);
	if (emoji != nil)
		[emojiArray addObject:emoji];
}

BOOL added1;
BOOL added3;
BOOL added4;

%hook UIKeyboardEmojiCategoryPicker

- (NSString *)symbolForRow:(int)row
{
	return [NSClassFromString(@"UIKeyboardEmojiCategory") categoryForType:row].displaySymbol;
}

- (NSString *)titleForRow:(int)row
{
	return [NSClassFromString(@"UIKeyboardEmojiCategory") categoryForType:row].displayName;
}

%end

/*%hook UIKeyboardEmojiView

- (void)createAndInstallKeyPopupView
{
	%orig;
}

%end*/

/*%hook UIKeyboardEmojiGraphics

- (UIImage *)generateImageWithRect:(CGRect)rect name:(NSString *)name pressed:(BOOL)pressed
{
	return %orig;
}

%end*/

static CGFloat getHeight(NSString *name, CGFloat chocoL, CGFloat chocoP, CGFloat truffleL, CGFloat truffleP, CGFloat l, CGFloat p, CGFloat padL, CGFloat padP)
{
	CGFloat height = 0.0f;
	BOOL isPortrait = [name rangeOfString:@"Portrait"].location != NSNotFound;
	BOOL isLandscape = [name rangeOfString:@"Landscape"].location != NSNotFound || [name rangeOfString:@"Caymen"].location != NSNotFound;
	BOOL choco = [name rangeOfString:@"Choco"].location != NSNotFound;
	BOOL truffle = [name rangeOfString:@"Truffle"].location != NSNotFound;
	if (choco) {
		// iPhone 6
		height = isLandscape ? chocoL : chocoP;
	}
	else if (truffle) {
		// iPhone 6+
		height = isLandscape ? truffleL : truffleP;
	}
	else {
		// 3.5, 4-inches iDevices or iPad
		if (IPAD)
			height = isLandscape ? padL : padP;
		else
			height = isLandscape ? l : p;
	}
	return height;
}

static CGFloat scale()
{
	return UIScreen.mainScreen.scale;
}

static CGFloat getScrollViewHeight(NSString *name)
{
	return getHeight(name, 157.0f, 211.0f, 375.0f/scale(), 576.0f/scale(), 122.0f, 216.0f, 337.0f, 245.0f);
}

static CGFloat getBarHeight(NSString *name)
{
	return getHeight(name, 37.0f, 47.0f, 111.0f/scale(), 102.0f/scale(), 40.0f, 37.0f, 54.0f, 58.0f);
}

static CGFloat getKeyboardHeight(NSString *name)
{
	return getHeight(name, 194.0f, 258.0f, 486.0f/scale(), 678.0f/scale(), 162.0f, 253.0f, 391.0f, 303.0f);
}

%hook UIKBRenderGeometry

+ (UIKBRenderGeometry *)geometryWithFrame:(CGRect)frame paddedFrame:(CGRect)paddedFrame
{
	UIKBRenderGeometry *o = %orig;
	//NSLog(@"%@ %@ -> %@", NSStringFromCGRect(frame), NSStringFromCGRect(paddedFrame), NSStringFromCGRect(o.displayFrame));
	return o;
}

- (CGRect)displayFrame
{
	CGRect p = %orig;
	//NSLog(@"%@", NSStringFromCGRect(p));
	return p;
}

%end

%hook UIKBRenderFactoryEmoji_iPhone

- (UIKBRenderTraits *)_traitsForKey:(UIKBTree *)key onKeyplane:(UIKBTree *)keyplane
{
	// key: displayType 37
	// key: interactionType 19
	UIKBRenderTraits *traits = %orig;
	if (traits) {
		NSString *keyName = key.name;
		NSString *keyplaneName = keyplane.name;
		CGFloat paddedDeltaPosX;
		CGFloat paddedDeltaPosY;
		CGFloat paddedDeltaWidth;
		CGFloat paddedDeltaHeight;
		CGRect oldPaddedFrame;
		CGRect correctFrame;
		CGFloat height2 = getBarHeight(keyplaneName);
		if ([keyName isEqualToString:@"Emoji-Category-Control-Key"]) {
			NSArray *_geometries = traits.variantGeometries;
			NSMutableArray *geometries = [NSMutableArray arrayWithArray:_geometries];
			int count = geometries.count;
			if (count > 1) {
				CGRect barFrame = key.frame;
				CGFloat barWidth = barFrame.size.width;
				CGFloat correctGeometryWidth = barWidth / count;
				CGFloat startX = ((UIKBRenderGeometry *)_geometries[0]).frame.origin.x;
				for (int index = 0; index < count; index++) {
					UIKBRenderGeometry *geometry = _geometries[index];
					CGFloat correctGeometryPosX = startX + correctGeometryWidth*index;
					paddedDeltaPosX = geometry.paddedFrame.origin.x - geometry.frame.origin.x;
					paddedDeltaPosY = geometry.paddedFrame.origin.y - geometry.frame.origin.y;
					paddedDeltaWidth = geometry.paddedFrame.size.width - geometry.frame.size.width;
					paddedDeltaHeight = geometry.paddedFrame.size.height - geometry.frame.size.height;
					correctFrame = CGRectMake(correctGeometryPosX, geometry.frame.origin.y, correctGeometryWidth, height2);
					geometry.frame = correctFrame;
					geometry.displayFrame = correctFrame;
					CGRect symbolFrame = geometry.symbolFrame;
					CGRect correctSymbolFrame = CGRectMake(correctGeometryPosX, symbolFrame.origin.y, correctGeometryWidth, height2);
					geometry.symbolFrame = correctSymbolFrame;
					geometry.paddedFrame = correctFrame;
					oldPaddedFrame = geometry.paddedFrame;
					geometry.paddedFrame = CGRectMake(oldPaddedFrame.origin.x + paddedDeltaPosX, oldPaddedFrame.origin.y + paddedDeltaPosY, oldPaddedFrame.size.width + paddedDeltaWidth, oldPaddedFrame.size.height + paddedDeltaHeight);
					geometries[index] = geometry;
				}
				traits.variantGeometries = geometries;
			}
		}
		else if ([keyName isEqualToString:@"Delete-Key"] || [keyName isEqualToString:@"International-Key"] || [keyName isEqualToString:@"Space-Key"]) {
			UIKBRenderGeometry *inputGeometry = traits.geometry;
			if (inputGeometry && key.state != 16) {
				CGFloat height = getScrollViewHeight(keyplaneName);
				//CGRect displayFrame = inputGeometry.displayFrame;
				CGRect frame = inputGeometry.frame;
				oldPaddedFrame = inputGeometry.paddedFrame;
				paddedDeltaPosX = oldPaddedFrame.origin.x - frame.origin.x;
				paddedDeltaPosY = oldPaddedFrame.origin.y - frame.origin.y;
				paddedDeltaWidth = oldPaddedFrame.size.width - frame.size.width;
				paddedDeltaHeight = oldPaddedFrame.size.height - frame.size.height;
				correctFrame = CGRectMake(frame.origin.x, height, frame.size.width, height2);
				inputGeometry.frame = correctFrame;
				inputGeometry.displayFrame = correctFrame;
				inputGeometry.paddedFrame = correctFrame;
				inputGeometry.paddedFrame = CGRectMake(correctFrame.origin.x + paddedDeltaPosX, correctFrame.origin.y + paddedDeltaPosY, correctFrame.size.width + paddedDeltaWidth, correctFrame.size.height + paddedDeltaHeight);
				traits.geometry = inputGeometry;
			}
		}
	}
	return traits;
}

%end

%hook UIKBDimmingView

- (void)drawRect:(CGRect)rect
{
	%orig;
	UIKBTree *keyplane = MSHookIvar<UIKBTree *>(self, "_keyplane");
	NSString *name = keyplane.name;
	if ([name rangeOfString:@"Emoji"].location != NSNotFound) {
		CGFloat height = getScrollViewHeight(name);
		CGRect frame = keyplane.frame;
		CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
		self.frame = newFrame;
	}
}

%end

%hook UIKBKeyView

%new
- (void)emoji83_positionFixForKeyplane:(UIKBTree *)keyplane key:(UIKBTree *)key withFrame:(CGRect *)beforeFrame
{
	NSString *keyName = key.name;
	NSString *keyplaneName = keyplane.name;
	BOOL targetKey = [keyName isEqualToString:@"International-Key"] || [keyName isEqualToString:@"Delete-Key"] || [keyName isEqualToString:@"Space-Key"];
	BOOL targetKeyplane = [keyplaneName rangeOfString:@"Emoji"].location != NSNotFound;
	if (targetKey && targetKeyplane) {
		CGRect frame = key.frame;
		CGFloat height = getScrollViewHeight(keyplaneName);
		CGFloat height2 = getBarHeight(keyplaneName);
		CGRect newFrame = CGRectMake(frame.origin.x, height, frame.size.width, height2);
		if (key.state != 16) {
			key.frame = newFrame;
			self.drawFrame = newFrame;
			UIKBShape *shape = key.shape;
			CGRect paddedFrame = shape.paddedFrame;
			CGRect newPaddedFrame = CGRectMake(paddedFrame.origin.x, height, paddedFrame.size.width, height2);
			shape.paddedFrame = newPaddedFrame;
			key.shape = shape;
			self.frame = newFrame;
			if (beforeFrame != NULL)
				*beforeFrame = newFrame;
		}
	}
}

- (id)initWithFrame:(CGRect)frame keyplane:(UIKBTree *)keyplane key:(UIKBTree *)key
{
	CGRect frame2 = frame;
	[self emoji83_positionFixForKeyplane:keyplane key:key withFrame:&frame2];
	self = %orig(frame2, keyplane, key);
	return self;
}

- (void)updateForKeyplane:(UIKBTree *)keyplane key:(UIKBTree *)key
{
	%orig;
	[self emoji83_positionFixForKeyplane:keyplane key:key withFrame:NULL];
}

%end

static UIImage *emojiCategoryBar(CGRect frame, NSString *imageName, BOOL pressed)
{
	return [NSClassFromString(@"UIKeyboardEmojiGraphics") imageWithRect:frame name:imageName pressed:pressed];
}

static NSMutableArray *emojiCategoryBarImages(UIKeyboardEmojiCategoryBar *self, BOOL pressed)
{
	CGRect frame = self ? self.frame : CGRectZero;
	NSMutableArray *array = [NSMutableArray array];
	[array addObject:emojiCategoryBar(frame, @"categoryRecents", pressed)];
	[array addObject:emojiCategoryBar(frame, @"categoryPeople", pressed)];
	[array addObject:emojiCategoryBar(frame, @"categoryNature", pressed)];
	[array addObject:emojiCategoryBar(frame, @"categoryFoodAndDrink", pressed)];
	[array addObject:emojiCategoryBar(frame, @"categoryActivity", pressed)];
	[array addObject:emojiCategoryBar(frame, @"categoryObjects", pressed)];
	[array addObject:emojiCategoryBar(frame, @"categoryPlaces", pressed)];
	[array addObject:emojiCategoryBar(frame, @"categorySymbols", pressed)];
	return array;
}

static NSArray *extraIcons()
{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:8];
	[array addObject:@"emoji_recents.png"];
	[array addObject:@"emoji_people.png"];
	[array addObject:@"emoji_nature.png"];
	[array addObject:@"emoji_food-and-drink.png"];
	[array addObject:@"emoji_celebration.png"];
	[array addObject:@"emoji_activity.png"];
	[array addObject:@"emoji_travel-and-places.png"];
	[array addObject:@"emoji_objects-and-symbols.png"];
	return array;
}

%group iOS7Up

static void aHook(UIKeyboardEmojiCategoryBar *self, UIKBTree *key)
{
	UIKBTree *_key = MSHookIvar<UIKBTree *>(self, "m_key");
	[key.subtrees removeAllObjects];
	NSArray *categories = [NSClassFromString(@"UIKeyboardEmojiCategory") categories];
	NSInteger count = categories.count;
	NSMutableArray *keys = [NSMutableArray arrayWithCapacity:count];
	int index = 0;
	do {
		UIKBTree *emojiKey = [[UIKBTree alloc] initWithType:8];
		UIKeyboardEmojiCategory *category = categories[index];
		int categoryType = category.categoryType;
		NSString *image = nil;
		if (categoryType < count) {
			image = extraIcons()[categoryType];
			emojiKey.displayString = image;
			[keys addObject:[emojiKey autorelease]];
		}
		++index;
	} while (index < count);
	[_key.subtrees addObjectsFromArray:keys];
	key = _key;
}

%hook UIKeyboardEmojiCategoryBar

- (id)initWithFrame:(CGRect)frame keyplane:(UIKBTree *)keyplane key:(UIKBTree *)key
{
	CGFloat height = getScrollViewHeight(keyplane.name);
	UIKBShape *shape = key.shape;
	if (shape) {
		CGFloat height2 = getBarHeight(keyplane.name);
		CGRect newFrame = CGRectMake(shape.frame.origin.x, height, shape.frame.size.width, height2);
		shape.frame = newFrame;
		key.shape = shape;
		frame = CGRectMake(shape.frame.origin.x, height, shape.frame.size.width, height2);
	}
	self = %orig(frame, keyplane, key);
	aHook(self, key);
	return self;
}

%end

%hook UIKeyboardEmojiCategoryBar_iPhone

- (id)initWithFrame:(CGRect)frame keyplane:(UIKBTree *)keyplane key:(UIKBTree *)key
{
	CGFloat height = getScrollViewHeight(keyplane.name);
	UIKBShape *shape = key.shape;
	if (shape) {
		CGFloat height2 = getBarHeight(keyplane.name);
		CGRect newFrame = CGRectMake(shape.frame.origin.x, height, shape.frame.size.width, height2);
		shape.frame = newFrame;
		key.shape = shape;
		frame = CGRectMake(shape.frame.origin.x, height, shape.frame.size.width, height2);
	}
	self = %orig(frame, keyplane, key);
	aHook(self, key);
	return self;
}

%end


%end

%group preiOS7

%hook UIKeyboardEmojiCategoryBar_iPhone

- (void)updateSegmentImages
{
	%orig;
	NSArray *selectedImages = MSHookIvar<NSArray *>(self, "_selectedImages");
	NSArray *unselectedImages = MSHookIvar<NSArray *>(self, "_unselectedImages");
	[selectedImages release];
	selectedImages = emojiCategoryBarImages(self, YES);
	[unselectedImages release];
	unselectedImages = emojiCategoryBarImages(self, NO);
	[selectedImages retain];
	[unselectedImages retain];
	%orig;
}

%end

%end

%hook UIKeyboardEmojiCategoryBar_iPhone

- (void)updateSegmentImages
{
	%orig;
	NSArray *selectedImages = MSHookIvar<NSArray *>(self, "_selectedImages");
	NSArray *unselectedImages = MSHookIvar<NSArray *>(self, "_unselectedImages");
	[selectedImages release];
	selectedImages = emojiCategoryBarImages(self, YES);
	[unselectedImages release];
	unselectedImages = emojiCategoryBarImages(self, NO);
	[selectedImages retain];
	[unselectedImages retain];
	%orig;
}

%end

%hook UIKeyboardEmojiGraphics

%new
- (UIImage *)categoryFoodAndDrinkGenerator:(id)arg
{
	return [self categoryObjectsGenerator:arg];
}

%new
- (UIImage *)categoryActivityGenerator:(id)arg
{
	return [self categoryPlacesGenerator:arg];
}

%end

%hook UIKeyboardEmojiCategory

+ (NSInteger)numberOfCategories
{
	return 8;
}

static NSMutableArray *_categories;

+ (NSMutableArray *)categories
{
	if (_categories == nil) {
		NSInteger count = [self numberOfCategories];
		NSMutableArray *_array = [NSMutableArray arrayWithCapacity:count];
		_categories = [_array retain];
		int categoryType = 0;
		do {
			UIKeyboardEmojiCategory *category = [[[NSClassFromString(@"UIKeyboardEmojiCategory") alloc] init] autorelease];
			category.categoryType = categoryType;
			[_categories addObject:category];
			++categoryType;
		} while (categoryType != count);
	}
	return _categories;
}

- (NSString *)name
{
	NSString *name = nil;
	int categoryType = self.categoryType;
	if (categoryType < [NSClassFromString(@"UIKeyboardEmojiCategory") numberOfCategories]) {
		switch (categoryType) {
			case 0:
				name = @"UIKeyboardEmojiCategoryRecent";
				break;
			case 1:
				name = @"UIKeyboardEmojiCategoryPeople";
				break;
			case 2:
				name = @"UIKeyboardEmojiCategoryNature";
				break;
			case 3:
				name = @"UIKeyboardEmojiCategoryFoodAndDrink";
				break;
			case 4:
				name = @"UIKeyboardEmojiCategoryCelebration";
				break;
			case 5:
				name = @"UIKeyboardEmojiCategoryActivity";
				break;
			case 6:
				name = @"UIKeyboardEmojiCategoryTravelAndPlaces";
				break;
			case 7:
				name = @"UIKeyboardEmojiCategoryObjectsAndSymbols";
				break;
		}
	}
	return name;
}

- (NSString *)displayName
{
	NSString *name = nil;
	int categoryType = self.categoryType;
	if (categoryType < [NSClassFromString(@"UIKeyboardEmojiCategory") numberOfCategories]) {
		switch (categoryType) {
			case 0:
				name = @"Recents Category";
				break;
			case 1:
				name = @"People Category";
				break;
			case 2:
				name = @"Nature Category";
				break;
			case 3:
				name = @"Food & Drink Category";
				break;
			case 4:
				name = @"Celebration Category";
				break;
			case 5:
				name = @"Activity Category";
				break;
			case 6:
				name = @"Travel & Places Category";
				break;
			case 7:
				name = @"Objects & Symbols Category";
				break;
		}
	}
	return [NSClassFromString(@"UIKeyboardEmojiCategory") localizedStringForKey:name];
}

- (NSString *)displaySymbol
{
	int categoryType = self.categoryType;
	if (categoryType < [NSClassFromString(@"UIKeyboardEmojiCategory") numberOfCategories])
		return extraIcons()[categoryType];
	return %orig;
}

+ (UIKeyboardEmojiCategory *)categoryForType:(int)categoryType
{
	NSArray *categories = [self categories];
	UIKeyboardEmojiCategory *categoryForType = [categories objectAtIndex:categoryType];
	NSArray *emojiForType = categoryForType.emoji;
	if (emojiForType.count > 0)
		return categoryForType;
	if (categoryType > [self numberOfCategories])
		return nil;
	NSArray *recentEmoji = nil;
	NSString *emojiString = nil;
	NSArray *familiesEmoji = nil;
	UIKeyboardEmoji *emoji = nil;
	int emojiCount = 136; // all (135) + vulcan (1)
	unsigned long *emojiArray = PeopleEmoji;
	//NSArray *emojiArrayLegacy = PeopleEmoji_Legacy();
	switch (categoryType) {
		case 0:
			recentEmoji = [self emojiRecentsFromPreferences];
			break;
		case 2:
			emojiCount = 125; // all
			emojiArray = NatureEmoji;
			//emojiArrayLegacy = NatureEmoji_Legacy();
			break;
		case 3:
			emojiCount = 58; // all
			emojiArray = FoodAndDrinkEmoji;
			//emojiArrayLegacy = FoodAndDrinkEmoji_Legacy();
			break;
		case 4:
			emojiCount = 39; // all
			emojiArray = CelebrationEmoji;
			//emojiArrayLegacy = CelebrationEmoji_Legacy();
			break;
		case 5:
			emojiCount = 53; // all
			emojiArray = ActivityEmoji;
			//emojiArrayLegacy = ActivityEmoji_Legacy();
			break;
		case 6:
			emojiCount = 122; // some extra flags left
			emojiArray = TravelAndPlacesEmoji;
			//emojiArrayLegacy = TravelAndPlacesEmoji_Legacy();
			break;
		case 7:
			emojiCount = 345; // all
			emojiArray = ObjectsAndSymbolsEmoji;
			//emojiArrayLegacy = ObjectsAndSymbolsEmoji_Legacy();
			break;
		case 8:
			emojiCount = 30; // Apple seems don't use this
			emojiArray = PrePopulatedEmoji;
			break;
		case 1:
			break;
		default:
			return nil;
	}
	if (recentEmoji != nil) {
		categoryForType.emoji = recentEmoji;
		return categoryForType;
	}
	NSMutableArray *_emojiArray = [NSMutableArray arrayWithCapacity:emojiCount];
	int index = 0;
	unsigned long _emojiUnicode;
	unsigned long emojiUnicode;
	/*CTFontRef font = NULL;
	if (!isiOS7Up)
		font = CTFontCreateWithName(CFSTR("AppleColorEmoji"), 12.0f, NULL);*/
	do {
		_emojiUnicode = emojiArray[2 * index];
		emojiUnicode = emojiArray[(2 * index) + 1];
		if (emojiUnicode == 0x0) {
			if (_emojiUnicode == 0x1F491) {
				emojiString = @"💑";
				addEmoji(_emojiArray, mmwws()[1]);
				addEmoji(_emojiArray, mmwws()[0]);
			}
			else if (_emojiUnicode == 0x1F48F) {
				emojiString = @"💏";
				addEmoji(_emojiArray, mmwwks()[1]);
				addEmoji(_emojiArray, mmwwks()[0]);
			}
			else {
				if (_emojiUnicode != 0x1F46A) {
					emojiString = emojiFromUnicode(_emojiUnicode);
				} else {
					emojiString = @"👪";
					familiesEmoji = families();
					for (int i = 0; i < familiesEmoji.count; i++) {
						addEmoji(_emojiArray, familiesEmoji[i]);
					}
				}
			}
			emoji = emojiFromString(emojiString);
		}
		else {
			BOOL dingbat = _emojiUnicode == 0x261D || _emojiUnicode == 0x270C;
			if (!dingbat) {
				NSString *unicharEmojiString = emojiFromUnicode(_emojiUnicode);
				if (emojiUnicode != 0xFE0F) {
					NSString *emojiString2 = emojiFromUnicode(emojiUnicode);
					emojiString = [NSString stringWithFormat:@"%@%@", unicharEmojiString, emojiString2];
				}
			} else
				emojiString = emojiFromUnicode(_emojiUnicode);
			emoji = emojiFromString(emojiString);
		}
		if (emoji == nil)
			++index;
		else {
			/*if (!isiOS7Up) {
				NSString *string = emojiString;
				NSDictionary *attributes = @{NSFontAttributeName : (id)font};
				NSAttributedString *_string = [[[NSAttributedString alloc] initWithString:string attributes:attributes] autorelease];
				CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)_string);
				if (line) {
					CFArrayRef glyphRuns = CTLineGetGlyphRuns(line);
					if (glyphRuns) {
						const UniChar *chars;
						chars = CFStringGetCharactersPtr((CFStringRef)@"🎀 🎁 🎂 🎃 🎄 🎋 🎍 🎑 🎆 🎇 🎉 🎊 🎈 💫 ✨ 💥 🎓 👑 🎎 🎏 🎐 🎌");
						if (chars) {
							unsigned short idx = 0;
							do {
								NSLog(@"%x %x %x", chars[idx], emojiUnicode, _emojiUnicode);
								if (chars[idx] == _emojiUnicode) {
									emoji.glyph = idx;
								}
								++idx;
							} while (idx < emojiCount);
						}

					}
				}*/
			[_emojiArray addObject:emoji];
			++index;
		}
	} while (index < emojiCount);
	/*if (font)
		CFRelease(font);*/
	if (_emojiArray)
		categoryForType.emoji = _emojiArray;
	return categoryForType;
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
	NSString *unicode = [NSString stringWithFormat:@"%lx", (unsigned long)_unicodeFromEmoji(skin)];
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
	if ([self respondsToSelector:@selector(inputDelegate)]) {
		id inputDelegate = [self inputDelegate];
		if ([inputDelegate respondsToSelctor:@selector(text)]) {
			NSString *text = [inputDelegate text];
			if (text) {
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

%hook UIKeyboardEmojiScrollView

- (id)initWithFrame:(CGRect)frame keyplane:(UIKBTree *)keyplane key:(UIKBTree *)key
{
	NSString *keyplaneName = keyplane.name;
	BOOL emoji = [key.name isEqualToString:@"Emoji-InputView-Key"];
	if (key && [keyplaneName rangeOfString:@"Emoji"].location != NSNotFound && emoji) {
		UIKBShape *shape2 = key.shape;
		CGFloat height = getScrollViewHeight(keyplaneName);
		CGRect newFrame2 = CGRectMake(shape2.frame.origin.x, shape2.frame.origin.y, shape2.frame.size.width, height);
		shape2.frame = newFrame2;
		CGRect paddedFrame2 = CGRectMake(shape2.paddedFrame.origin.x, shape2.paddedFrame.origin.y, shape2.paddedFrame.size.width, height);
		shape2.paddedFrame = paddedFrame2;
		key.shape = shape2;
		frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
	}
	id orig = %orig(frame, keyplane, key);
	return orig;
}

%end

%group iOS8

%hook UIKeyboardImpl

extern "C" UIKeyboardInputMode *UIKeyboardGetCurrentInputMode();
NSString *(*UIKeyboardGetKBStarName)(UIKeyboardInputMode *, UIKBScreenTraits *, int, int);

- (void)_resizeForKeyplaneSize:(CGSize)size splitWidthsChanged:(BOOL)changed
{
	Class layoutClass = [UIKeyboardImpl layoutClassForCurrentInputMode];
	if (layoutClass == objc_getClass("UIKeyboardLayoutStar")) {
		UIKBScreenTraits *screenTraits = [%c(UIKBScreenTraits) traitsWithScreen:[UIKeyboardImpl keyboardScreen] orientation:[[self _layout] orientation]];
		UIKeyboardInputMode *currentInputMode = UIKeyboardGetCurrentInputMode();
		NSString *name = UIKeyboardGetKBStarName(currentInputMode, screenTraits, 0, 0);
		UIKBTree *tree = [layoutClass keyboardFromFactoryWithName:name screen:[UIKeyboardImpl keyboardScreen]];
		if (tree && [name rangeOfString:@"Emoji"].location != NSNotFound) {
			UIKBShape *shape = tree.shape;
			CGFloat height = getKeyboardHeight(name);
			CGRect newFrame = CGRectMake(shape.frame.origin.x, shape.frame.origin.y, shape.frame.size.width, height);
			size = newFrame.size;
		}
	}
	%orig(size, changed);
}

%end

%end

%group iOS7

/*%hook UIKeyboardImpl

+ (CGSize)sizeForInterfaceOrientation:(int)orientation
{
	UIKeyboardInputMode *currentInputMode = UIKeyboardGetCurrentInputMode();
	UIKBScreenTraits *screenTraits = [%c(UIKBScreenTraits) traitsWithScreen:[UIKeyboardImpl keyboardScreen] orientation:orientation];
	NSString *name = UIKeyboardGetKBStarName(currentInputMode, screenTraits, 0, 0);
	return [name rangeOfString:@"Emoji"].location != NSNotFound ? CGSizeMake(%orig.width, (orientation == 1 || orientation == 2) ? 253.0f : 162.0f) : %orig;
}

+ (CGSize)keyboardSizeForInterfaceOrientation:(int)orientation
{
	UIKeyboardInputMode *currentInputMode = UIKeyboardGetCurrentInputMode();
	UIKBScreenTraits *screenTraits = [%c(UIKBScreenTraits) traitsWithScreen:[UIKeyboardImpl keyboardScreen] orientation:orientation];
	NSString *name = UIKeyboardGetKBStarName(currentInputMode, screenTraits, 0, 0);
	return [name rangeOfString:@"Emoji"].location != NSNotFound ? CGSizeMake(%orig.width, (orientation == 1 || orientation == 2) ? 253.0f : 162.0f) : %orig;
}

+ (CGSize)keyboardSizeForInputMode:(UIKeyboardInputMode *)inputMode screenTraits:(UIKBScreenTraits *)screenTraits
{
	int orientation = MSHookIvar<int>(self, "m_orientation");
	NSString *name = UIKeyboardGetKBStarName(inputMode, screenTraits, 0, 0);
	return [name rangeOfString:@"Emoji"].location != NSNotFound ? CGSizeMake(%orig.width, (orientation == 1 || orientation == 2) ? 253.0f : 162.0f) : %orig;
}

%end

%hook UIKeyboardLayoutStar

- (void)resizeForKeyplaneSize:(CGSize)size
{
	UIKBScreenTraits *screenTraits = [%c(UIKBScreenTraits) traitsWithScreen:[UIKeyboardImpl keyboardScreen] orientation:[[%c(UIKeyboard) activeKeyboard] interfaceOrientation]];
	UIKeyboardInputMode *currentInputMode = UIKeyboardGetCurrentInputMode();
	NSString *name = UIKeyboardGetKBStarName(currentInputMode, screenTraits, 0, 0);
	UIKBTree *tree = [%c(UIKeyboardLayoutStar) keyboardFromFactoryWithName:name screen:[UIKeyboardImpl keyboardScreen]];
	if (tree && [name rangeOfString:@"Emoji"].location != NSNotFound) {
		UIKBShape *shape = tree.shape;
		CGFloat height = getKeyboardHeight(name);
		CGRect newFrame = CGRectMake(shape.frame.origin.x, shape.frame.origin.y, shape.frame.size.width, height);
		size = newFrame.size;
	}
	%orig(size);
}

+ (CGSize)keyboardSizeForInputMode:(UIKeyboardInputMode *)inputMode screenTraits:(UIKBScreenTraits *)screenTraits
{
	int orientation = MSHookIvar<int>([UIKeyboardImpl activeInstance], "m_orientation");
	NSString *name = UIKeyboardGetKBStarName(inputMode, screenTraits, 0, 0);
	return [name rangeOfString:@"Emoji"].location != NSNotFound ? CGSizeMake(%orig.width, (orientation == 1 || orientation == 2) ? 253.0f : 162.0f) : %orig;
}

%end*/

%end

extern "C" UIImage *_UIImageWithName(NSString *name);
MSHook(UIImage *, _UIImageWithName, NSString *name)
{
	if ([extraIcons() containsObject:name]) {
		UIImage *image = [UIImage imageNamed:name inBundle:[NSBundle bundleWithPath:@"/System/Library/Frameworks/UIKit.framework"]];
		return image;
	}
	return __UIImageWithName(name);
}

%ctor
{
	MSImageRef ref = MSGetImageByName("/System/Library/Frameworks/UIKit.framework/UIKit");
	UIKeyboardGetKBStarName = (NSString *(*)(UIKeyboardInputMode *, UIKBScreenTraits *, int, int))MSFindSymbol(ref, "_UIKeyboardGetKBStarName");
	%init;
	MSHookFunction(_UIImageWithName, MSHake(_UIImageWithName));
	if (isiOS7Up) {
		%init(iOS7Up);
		if (isiOS8Up) {
			%init(iOS8);
		} else {
			%init(iOS7);
		}
	} else {
		%init(preiOS7);
	}
}