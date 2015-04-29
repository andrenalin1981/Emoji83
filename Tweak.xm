#import "Emoji.h"
//#import <CoreGraphics/CoreGraphics.h>
//#import <CoreText/CoreText.h>
#import <CoreFoundation/CoreFoundation.h>

/*static unsigned long *_unicodeFromEmoji(NSString *emoji)
{
	NSData *data = [emoji dataUsingEncoding:NSUTF32LittleEndianStringEncoding];
	unsigned long *unicode;
	[data getBytes:&unicode length:sizeof(unicode)];
	return unicode;
}*/

static UIKeyboardEmoji *emojiFromString(NSString *myEmoji)
{
	UIKeyboardEmoji *emo = nil;
	unichar unicode = [myEmoji characterAtIndex:0];
	BOOL dingbat = (unicode == 0x261D || unicode == 0x270C);
	emo = [NSClassFromString(@"UIKeyboardEmoji") respondsToSelector:@selector(emojiWithString:hasDingbat:)] ? [NSClassFromString(@"UIKeyboardEmoji") emojiWithString:myEmoji hasDingbat:dingbat]
			: [NSClassFromString(@"UIKeyboardEmoji") emojiWithString:myEmoji];
	return emo;
}

static BOOL isSkinUnicode(unichar code)
{
	return code >= 0xDFFB && code <= 0xDFFF;
}

/*
static void addFlagEmojis(UIKeyboardEmojiCategory *emojiObject)
{
	NSString *flagsString = @"🇦🇫 🇦🇱 🇩🇿 🇦🇸 🇦🇩 🇦🇴 🇦🇮 🇦🇬 🇦🇷 🇦🇲 🇦🇼 🇦🇺 🇦🇹 🇦🇿 🇧🇸 🇧🇭 🇧🇩 🇧🇧 🇧🇾 🇧🇪 🇧🇿 🇧🇯 🇧🇲 🇧🇹 🇧🇴 🇧🇦 🇧🇼 🇧🇷 🇧🇳 🇧🇬 🇧🇫 🇧🇮 🇰🇭 🇨🇲 🇨🇦 🇨🇻 🇰🇾 🇨🇫 🇨🇱 🇨🇴 🇰🇲 🇨🇩 🇨🇬 🇨🇰 🇨🇷 🇭🇷 🇨🇺 🇨🇼 🇨🇾 🇨🇿 🇩🇰 🇩🇯 🇩🇲 🇩🇴 🇪🇨 🇪🇬 🇸🇻 🇬🇶 🇪🇷 🇪🇪 🇪🇹 🇫🇴 🇫🇯 🇫🇮 🇫🇷 🇬🇫 🇹🇫 🇬🇦 🇬🇲 🇬🇪 🇬🇭 🇬🇮 🇬🇷 🇬🇩 🇬🇵 🇬🇺 🇬🇹 🇬🇳 🇬🇼 🇬🇾 🇭🇹 🇭🇳 🇭🇰 🇭🇺 🇮🇸 🇮🇳 🇮🇩 🇮🇷 🇮🇶 🇮🇪 🇮🇱 🇨🇮 🇯🇲 🇯🇴 🇰🇿 🇰🇪 🇰🇮 🇰🇼 🇰🇬 🇱🇦 🇱🇻 🇱🇧 🇱🇸 🇱🇷 🇱🇾 🇱🇮 🇱🇹 🇱🇺 🇲🇴 🇲🇰 🇲🇬 🇲🇼 🇲🇾 🇲🇻 🇲🇱 🇲🇹 🇲🇶 🇲🇷 🇲🇽 🇲🇩 🇲🇳 🇲🇪 🇲🇸 🇲🇦 🇲🇿 🇲🇲 🇳🇦 🇳🇵 🇳🇱 🇳🇨 🇳🇿 🇳🇮 🇳🇪 🇳🇬 🇳🇺 🇰🇵 🇲🇵 🇳🇴 🇴🇲 🇵🇰 🇵🇼 🇵🇸 🇵🇦 🇵🇬 🇵🇾 🇵🇪 🇵🇭 🇵🇱 🇵🇹 🇵🇷 🇶🇦 🇷🇴 🇷🇼 🇼🇸 🇸🇲 🇸🇹 🇸🇦 🇸🇳 🇷🇸 🇸🇨 🇸🇱 🇸🇬 🇸🇰 🇸🇮 🇸🇧 🇸🇴 🇿🇦 🇸🇸 🇱🇰 🇸🇩 🇸🇷 🇸🇿 🇸🇪 🇨🇭 🇸🇾 🇹🇯 🇹🇿 🇹🇭 🇹🇱 🇹🇬 🇹🇴 🇹🇹 🇹🇳 🇹🇷 🇹🇲 🇹🇨 🇹🇻 🇺🇬 🇺🇦 🇦🇪 🇺🇾 🇺🇿 🇻🇺 🇻🇪 🇻🇳 🇾🇪 🇿🇲 🇿🇼";
	NSArray *flags = [flagsString componentsSeparatedByString:@" "];
	addEmojisForIndex(emojiObject, flags, 4);
}*/

static NSArray *families()
{
	return @[@"👨‍👩‍👧", @"👨‍👩‍👧‍👦", @"👨‍👩‍👦‍👦", @"👨‍👩‍👧‍👧", @"👩‍👩‍👦", @"👩‍👩‍👧", @"👩‍👩‍👧‍👦", @"👩‍👩‍👦‍👦", @"👩‍👩‍👧‍👧", @"👨‍👨‍👦", @"👨‍👨‍👧", @"👨‍👨‍👧‍👦", @"👨‍👨‍👦‍👦", @"👨‍👨‍👧‍👧"];
}

static NSString *skinnedEmoji(NSString *emoji, NSString *skin)
{
	NSString *_emoji = isiOS7Up ? [NSString stringWithUnichar:[emoji _firstLongCharacter]] : emoji; // doesn't work with iOS <= 6
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
					[array removeObjectAtIndex:indexOfTarget];
					[array insertObject:emo6 atIndex:indexOfTarget];
					[array insertObject:emo5 atIndex:indexOfTarget];
					[array insertObject:emo4 atIndex:indexOfTarget];
					[array insertObject:emo3 atIndex:indexOfTarget];
					[array insertObject:emo2 atIndex:indexOfTarget];
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

/*static void updateCategory(UIKeyboardEmojiCategory *category, int type)
{
	[[NSClassFromString(@"UIKeyboardEmojiCategory") categories] replaceObjectAtIndex:type withObject:category];
}*/

static void addEmoji(NSMutableArray *emojiArray, NSString *string)
{
	UIKeyboardEmoji *emoji = emojiFromString(string);
	if (emoji != nil)
		[emojiArray addObject:emoji];
}

/*BOOL added1;
BOOL added3;
BOOL added4;*/

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

static CGFloat getHeight(NSString *name, CGFloat chocoL, CGFloat chocoP, CGFloat truffleL, CGFloat truffleP, CGFloat l, CGFloat p, CGFloat padL, CGFloat padP)
{
	CGFloat height = 0.0f;
	//BOOL isPortrait = [name rangeOfString:@"Portrait"].location != NSNotFound;
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

static CGFloat getBarHeight(NSString *name)
{
	return getHeight(name, 37.0f, 47.0f, 37.0f, 34.0f, 40.0f, 37.0f, 54.0f, 58.0f);
}

static CGFloat getKeyboardHeight(NSString *name)
{
	return getHeight(name, 194.0f, 258.0f, 162.0f, 226.0f, 162.0f, 253.0f, 391.0f, 303.0f);
}

static CGFloat getScrollViewHeight(NSString *name)
{
	return getKeyboardHeight(name) - getBarHeight(name);
}


%hook UIKBRenderGeometry

+ (UIKBRenderGeometry *)geometryWithFrame:(CGRect)frame paddedFrame:(CGRect)paddedFrame
{
	UIKBRenderGeometry *o = %orig;
	//NSLog(@"%@ %@ -> %@", NSStringFromCGRect(frame), NSStringFromCGRect(paddedFrame), NSStringFromCGRect(o.displayFrame));
	return o;
}

%end

static NSArray *targetKeys()
{
	return @[@"Delete-Key", @"International-Key", @"Space-Key", @"Dismiss-Key"];
}

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
		else if ([targetKeys() containsObject:keyName]) {
			UIKBRenderGeometry *inputGeometry = traits.geometry;
			if (inputGeometry && key.state != 16) {
				CGFloat height = getScrollViewHeight(keyplaneName);
				CGRect frame = inputGeometry.frame;
				correctFrame = CGRectMake(frame.origin.x, height, frame.size.width, height2);
				inputGeometry.displayFrame = correctFrame;
				traits.geometry = inputGeometry;
			}
		}
	}
	return traits;
}

%end

/*%hook UIKBDimmingView

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

%end*/

%hook UIKBKeyView

%new
- (void)emoji83_positionFixForKeyplane:(UIKBTree *)keyplane key:(UIKBTree *)key withFrame:(CGRect *)beforeFrame
{
	NSString *keyName = key.name;
	NSString *keyplaneName = keyplane.name;
	BOOL targetKey = [targetKeys() containsObject:keyName];
	BOOL targetKeyplane = [keyplaneName rangeOfString:@"Emoji"].location != NSNotFound;
	if (targetKey && targetKeyplane) {
		CGRect frame = key.frame;
		CGFloat height = getScrollViewHeight(keyplaneName);
		CGFloat height2 = getBarHeight(keyplaneName);
		CGRect newFrame = CGRectMake(frame.origin.x, height, frame.size.width, height2);
		if (key.state != 16) {
			key.frame = newFrame;
			UIKBShape *shape = key.shape;
			CGRect paddedFrame = shape.paddedFrame;
			CGRect newPaddedFrame = CGRectMake(paddedFrame.origin.x, height, paddedFrame.size.width, height2);
			shape.paddedFrame = newPaddedFrame;
			key.shape = shape;
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
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:CATEGORIES_COUNT];
	[array addObject:@"emoji_recents.png"];
	[array addObject:@"emoji_people.png"];
	[array addObject:@"emoji_nature.png"];
	[array addObject:@"emoji_food-and-drink.png"];
	[array addObject:@"emoji_celebration.png"];
	[array addObject:@"emoji_activity.png"];
	[array addObject:@"emoji_travel-and-places.png"];
	[array addObject:@"emoji_objects-and-symbols.png"];
	[array addObject:@"emoji_diverse.png"]; // temporary
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
	return CATEGORIES_COUNT;
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
			case 8:
				name = @"UIKeyboardEmojiCategoryTemporary"; // temporary
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
			case 8:
				name = @"Diverse Category"; // temporary
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
	switch (categoryType) {
		case 0:
			recentEmoji = [self emojiRecentsFromPreferences];
			break;
		case 2:
			emojiCount = 125; // all
			emojiArray = NatureEmoji;
			break;
		case 3:
			emojiCount = 58; // all
			emojiArray = FoodAndDrinkEmoji;
			break;
		case 4:
			emojiCount = 39; // all
			emojiArray = CelebrationEmoji;
			break;
		case 5:
			emojiCount = 53; // all
			emojiArray = ActivityEmoji;
			break;
		case 6:
			emojiCount = 122; // some extra flags left
			emojiArray = TravelAndPlacesEmoji;
			break;
		case 7:
			emojiCount = 345; // all
			emojiArray = ObjectsAndSymbolsEmoji;
			break;
		case 8:
			emojiCount = 57;
			emojiArray = DiverseEmoji;
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
	unsigned long _emojiUnicode = 0x0;
	unsigned long emojiUnicode = 0x0;
	/*CTFontRef font = NULL;
	if (!isiOS7Up)
		font = CTFontCreateWithName(CFSTR("AppleColorEmoji"), 12.0f, NULL);*/
	do {
		emojiString = nil;
		emoji = nil;
		_emojiUnicode = emojiArray[2 * index]; // emoji to be added
		emojiUnicode = emojiArray[(2 * index) + 1]; // zero unicode check
		if (emojiUnicode == 0x0) {
			if (_emojiUnicode == 0x1F491) {
				addEmoji(_emojiArray, @"💑");
				addEmoji(_emojiArray, mmwws()[1]);
				addEmoji(_emojiArray, mmwws()[0]);
			}
			else if (_emojiUnicode == 0x1F48F) {
				addEmoji(_emojiArray, @"💏");
				addEmoji(_emojiArray, mmwwks()[1]);
				addEmoji(_emojiArray, mmwwks()[0]);
			}
			else {
				if (_emojiUnicode != 0x1F46A)
					emojiString = [NSString stringWithUnichar:_emojiUnicode];
				else {
					addEmoji(_emojiArray, @"👪");
					familiesEmoji = families();
					for (int i = 0; i < familiesEmoji.count; i++) {
						addEmoji(_emojiArray, familiesEmoji[i]);
					}
				}
			}
		}
		else {
			BOOL dingbat = _emojiUnicode == 0x261D || _emojiUnicode == 0x270C;
			if (!dingbat) {
				NSString *unicharEmojiString = [NSString stringWithUnichar:_emojiUnicode];
				if (emojiUnicode != 0xFE0F) {
					NSString *emojiString2 = [NSString stringWithUnichar:emojiUnicode];
					emojiString = [NSString stringWithFormat:@"%@%@", unicharEmojiString, emojiString2];
				}
			} else
				emojiString = [NSString stringWithUnichar:_emojiUnicode];
		}
		if (emojiString)
			emoji = emojiFromString(emojiString);
		if (emoji != nil)
			[_emojiArray addObject:emoji];
		++index;
	} while (index < emojiCount);
	/*if (font)
		CFRelease(font);*/
	if (_emojiArray)
		categoryForType.emoji = _emojiArray;
	if (categoryType == 8) { // temporary
		addDiverseEmojis1(categoryForType);
		addDiverseEmojis3(categoryForType);
	}
	return categoryForType;
}

- (void)releaseCategories
{
	%orig;
	[_categories removeAllObjects];
	/*added1 = NO;
	added3 = NO;
	added4 = NO;*/
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

static CGSize hookSize(CGSize size)
{
	Class layoutClass = [UIKeyboardImpl layoutClassForCurrentInputMode];
	if (layoutClass == objc_getClass("UIKeyboardLayoutStar")) {
		UIKBScreenTraits *screenTraits = [%c(UIKBScreenTraits) traitsWithScreen:[UIKeyboardImpl keyboardScreen] orientation:[[[UIKeyboardImpl activeInstance] _layout] orientation]];
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
	return size;
}

- (void)_resizeForKeyplaneSize:(CGSize)size splitWidthsChanged:(BOOL)changed
{
	%orig(hookSize(size), changed);
}

%end

%hook UIKeyboardLayoutStar

- (void)_resizeForKeyplaneSize:(CGSize)size splitWidthsChanged:(BOOL)changed
{
	%orig(hookSize(size), changed);
}

%end

%end

%group iOS7

%hook UIKeyboardLayoutStar

- (void)resizeForKeyplaneSize:(CGSize)size
{
	int orientation = [[%c(UIKeyboard) activeKeyboard] interfaceOrientation];
	UIKBScreenTraits *screenTraits = [%c(UIKBScreenTraits) traitsWithScreen:[UIKeyboardImpl keyboardScreen] orientation:orientation];
	[screenTraits setOrientationKey:[UIKeyboardImpl orientationKeyForOrientation:orientation]];
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

%end

%end

%hook UIKeyboardEmojiView

- (void)createAndInstallKeyPopupView
{
	%orig;
	
}

%end

static void addAttributes(NSMutableAttributedString *self, UIFont *emojiFont, UIFont *originalFont, BOOL isAlreadyEmoji, NSRange range)
{
	if (self.string.length < range.location + range.length)
		range = NSMakeRange(range.location, self.string.length - range.location);
	[self addAttribute:NSFontAttributeName value:emojiFont range:range];
	if (!isAlreadyEmoji)
		[self addAttribute:@"NSOriginalFont" value:originalFont range:range];
}

static void fixEmoji(NSMutableAttributedString *self)
{
	NSString *string = self.string;
	NSUInteger length = string.length;
	if (length == 0)
		return;
	UIFont *originalFont = nil;
	if ([self respondsToSelector:@selector(font)])
		originalFont = ((_UICascadingTextStorage *)self).font;
	else {
		if ([self respondsToSelector:@selector(attribute:atIndex:effectiveRange:)]) {
			UIFont *aFont = [(NSConcreteTextStorage *)self attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
			if (aFont)
				originalFont = aFont;
		}
	}
	if (originalFont == nil)
		return;
	BOOL isAlreadyEmoji = [originalFont.familyName isEqualToString:@"Apple Color Emoji"];
	UIFont *emojiFont = isAlreadyEmoji ? originalFont : [UIFont fontWithName:@"AppleColorEmoji" size:originalFont.pointSize];
	for (NSInteger charIndex = 0; charIndex < length; charIndex++) {
		unichar stringChar = [string characterAtIndex:charIndex];
		if (stringChar >= 0xDFFB && stringChar <= 0xDFFF) {
			unichar firstSkinChar = [string characterAtIndex:charIndex - 1];
			if (firstSkinChar == 0xD83C) {
     			// found skin variant
     			if (charIndex - 2 >= 0) {
     				unichar checkEmoji = [string characterAtIndex:charIndex - 2];
     				BOOL dingbat = checkEmoji == 0x261D || checkEmoji == 0x270A || checkEmoji == 0x270B || checkEmoji == 0x270C;
     				if (dingbat) {
     					// dingbat
     					NSRange skinDingbatRange = NSMakeRange(charIndex - 2, (checkEmoji == 0x261D || checkEmoji == 0x270C) ? 4 : 3);
     					addAttributes(self, emojiFont, originalFont, isAlreadyEmoji, skinDingbatRange);
					} else {
						if (charIndex - 3 >= 0) {
     						unichar checkEmoji2 = [string characterAtIndex:charIndex - 3];
     						if ((checkEmoji2 == 0xD83C || checkEmoji2 == 0xD83D) && !dingbat) {
     							BOOL isDiversed = NO;
     							for (int i = 0; i < DIVERSE_COUNT; i++) {
     								if (checkEmoji == DiverseEmoji2[i])
     									isDiversed = YES;
     							}
     							if (isDiversed) {
     								NSRange skinRange = NSMakeRange(charIndex - 3, 4);
									addAttributes(self, emojiFont, originalFont, isAlreadyEmoji, skinRange);
								}
							}
						}
     				}
     			}
     		}
     	} else {
     		if (charIndex + 3 < length) {
     			if (stringChar == 0xD83D && [string characterAtIndex:charIndex + 1] == 0xDD96) {
     				BOOL vulcan = YES;
     				unichar skinChar1 = [string characterAtIndex:charIndex + 2];
     				unichar skinChar2 = [string characterAtIndex:charIndex + 3];
     				if (skinChar2 >= 0xDFFB && skinChar2 <= 0xDFFF && skinChar1 == 0xD83C)
     					vulcan = NO;
     				if (vulcan) {
     					NSRange vulcanRange = NSMakeRange(charIndex, 2);
						addAttributes(self, emojiFont, originalFont, isAlreadyEmoji, vulcanRange);
					}
     			}
     			if (charIndex + 6 < length) {
     				if (stringChar == 0xD83D) {
     					BOOL eleven = NO;
     					unichar checkFamilyOrMMWW1 = [string characterAtIndex:charIndex + 2];
     					unichar checkFamilyOrMMWW2 = [string characterAtIndex:charIndex + 3];
     					unichar checkMMWW1 = [string characterAtIndex:charIndex + 4];
     					unichar checkFamilyOrMMWW3 = [string characterAtIndex:charIndex + 5];
     					unichar checkFamilyOrMMWW4 = [string characterAtIndex:charIndex + 6];
     					if (checkFamilyOrMMWW1 == 0x200D) {
     						if (checkFamilyOrMMWW2 == 0xD83D && checkFamilyOrMMWW3 == 0x200D && checkFamilyOrMMWW4 == 0xD83D) {
     							// family variant
     							if (charIndex + 9 < length) {
     								unichar checkFamily1 = [string characterAtIndex:charIndex + 8];
     								unichar checkFamily2 = [string characterAtIndex:charIndex + 9];
     								if (checkFamily1 == 0x200D && checkFamily2 == 0xD83D) {
     									// 4 people family
     									NSRange fourFamilyRange = NSMakeRange(charIndex, 11);
										addAttributes(self, emojiFont, originalFont, isAlreadyEmoji, fourFamilyRange);
     									eleven = YES;
     								}
     							}
     							// 3 people family
     							if (!eleven) {
     								NSRange threeFamilyRange = NSMakeRange(charIndex, 8);
									addAttributes(self, emojiFont, originalFont, isAlreadyEmoji, threeFamilyRange);
								}
     						}
     						else if (checkFamilyOrMMWW2 == 0x2764 && checkMMWW1 == 0xFE0F && checkFamilyOrMMWW3 == 0x200D && checkFamilyOrMMWW4 == 0xD83D) {
     							// mmww variant
     							if (charIndex + 9 < length) {
     								unichar checkMMWW2 = [string characterAtIndex:charIndex + 8];
     								unichar checkMMWW3 = [string characterAtIndex:charIndex + 9];
     								if (checkMMWW2 == 0x200D && checkMMWW3 == 0xD83D) {
     									// mmww with kiss
     									NSRange mmwwkRange = NSMakeRange(charIndex, 11);
										addAttributes(self, emojiFont, originalFont, isAlreadyEmoji, mmwwkRange);
     									eleven = YES;
     								}
     							}
     							// mmww normal
     							if (!eleven) {
     								NSRange mmwwRange = NSMakeRange(charIndex, 8);
									addAttributes(self, emojiFont, originalFont, isAlreadyEmoji, mmwwRange);
     							}
     						}
     					} else {
     						// something wrong
     						// because zero-width joiners are gone!
     						if (charIndex + 5 < length) {
     							int _eleven = 0;
     							unichar _checkGender1 = [string characterAtIndex:charIndex + 1]; // dc68 or dc69
     							unichar _checkFamilyOrMMWW1 = [string characterAtIndex:charIndex + 2]; // d83d vs 2764
     							unichar _checkGenderOrMMWW1 = [string characterAtIndex:charIndex + 3]; // dc68 or dc69 vs fe0f
     							unichar _checkMMWW1 = [string characterAtIndex:charIndex + 4]; // d83d
     							unichar _checkGenderOrMMWW2 = [string characterAtIndex:charIndex + 5]; // dc66 or dc67 vs dc68 or dc69
     							if ((_checkFamilyOrMMWW1 == 0xD83D || _checkFamilyOrMMWW1 == 0x2764) && _checkMMWW1 == 0xD83D) {
     								// incompleted family or mmww kiss emoji
     								if (charIndex + 7 < length) {
     									unichar _checkFamilyOrMMWW2 = [string characterAtIndex:charIndex + 6]; // d83d
     									unichar _checkGender4 = [string characterAtIndex:charIndex + 7]; // dc66 or dc67 vs dc68 or dc69
     									if (_checkFamilyOrMMWW2 == 0xD83D) {
     										if ((_checkGender4 == 0xDC66 || _checkGender4 == 0xDC67)) {
     											// incompleted 4 people family
     											_eleven = 1;
     										}
     										else if ((_checkGender4 == 0xDC68 || _checkGender4 == 0xDC69) && _checkGenderOrMMWW2 == 0xDC8B) {
     											// incompleted mmww kiss
     											_eleven = 2;
     										}
     										if (_eleven > 0) {
     											NSRange _fourRange = NSMakeRange(charIndex, 8);
     											NSString *emoji4String = nil;
     											if (_eleven == 1) {
     												unichar family4[11] = { 0xD83D, _checkGender1, 0x200D, _checkFamilyOrMMWW1, _checkGenderOrMMWW1, 0x200D, _checkMMWW1, _checkGenderOrMMWW2, 0x200D, _checkFamilyOrMMWW2, _checkGender4 };
     												emoji4String = [NSString stringWithCharacters:family4 length:11];
     											}
     											else if (_eleven == 2) {
     												unichar mmww4[11] = { 0xD83D, _checkGender1, 0x200D, 0x2764, 0xFE0F, 0x200D, 0xD83D, 0xDC8B, 0x200D, 0xD83D, _checkGender4 };
     												emoji4String = [NSString stringWithCharacters:mmww4 length:11];
     											}
     											if (emoji4String != nil) {
     												[self replaceCharactersInRange:_fourRange withString:emoji4String];
													addAttributes(self, emojiFont, originalFont, isAlreadyEmoji, NSMakeRange(charIndex, 11));
												}
     										}
     									}
     								}
     								if (_eleven == 0) {
     									int _eight = 0;
     									if ((_checkGenderOrMMWW1 == 0xDC68 || _checkGenderOrMMWW1 == 0xDC69) && (_checkGenderOrMMWW2 == 0xDC66 || _checkGenderOrMMWW2 == 0xDC67)) {
     										// incompleted 3 people family
     										_eight = 1;
     									}     							
     									else if (_checkGenderOrMMWW1 == 0xFE0F && (_checkGenderOrMMWW2 == 0xDC68 || _checkGenderOrMMWW2 == 0xDC69)) {
     										// incompleted mmww
     										_eight = 2;
     									}
     									if (_eight > 0) {
     										NSRange _threeRange = NSMakeRange(charIndex, 6);
     										NSString *emoji3String = nil;
     										if (_eight == 1) {
     											unichar family3[8] = { 0xD83D, _checkGender1, 0x200D, _checkFamilyOrMMWW1, _checkGenderOrMMWW1, 0x200D, _checkMMWW1, _checkGenderOrMMWW2 };
     											emoji3String = [NSString stringWithCharacters:family3 length:8];
     										}
     										else if (_eight == 2) {
     											unichar mmww3[8] = { 0xD83D, _checkGender1, 0x200D, 0x2764, 0xFE0F, 0x200D, 0xD83D, _checkGenderOrMMWW2 };
     											emoji3String = [NSString stringWithCharacters:mmww3 length:8];
     										}
     										if (emoji3String != nil) {
     											[self replaceCharactersInRange:_threeRange withString:emoji3String];
												addAttributes(self, emojiFont, originalFont, isAlreadyEmoji, NSMakeRange(charIndex, 8));
											}
										}
     								}
								}
     						}
     					}
     				}
     			}
     		}
     	}
     }
}

%hook NSConcreteMutableAttributedString

- (id)initWithString:(NSString *)str attributes:(id)attr
{
	self = %orig;
	[self fixFontAttributeInRange:NSMakeRange(0, self.length)];
	return self;
}

%end

%hook NSConcreteAttributedString

- (id)initWithAttributedString:(NSAttributedString *)str
{
	NSConcreteMutableAttributedString *mutableStr = [[%c(NSConcreteMutableAttributedString) alloc] initWithAttributedString:str];
	[mutableStr fixFontAttributeInRange:NSMakeRange(0, self.length)];
	return (NSConcreteAttributedString *)mutableStr;
}

%end

%hook NSMutableAttributedString

- (void)fixFontAttributeInRange:(NSRange)range
{
	%orig;
	fixEmoji(self);
}

%end

BOOL prevent = NO;

%hook NSAssertionHandler

- (void)handleFailureInMethod:(id)method object:(id)object file:(id)file lineNumber:(int)number description:(id)description
{
	if (prevent)
		return;
	%orig;
}

%end

%hook UILabel

- (float)_capOffsetFromBoundsTop
{
	prevent = YES;
	float cap = %orig;
	prevent = NO;
	return cap;
}

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

/*MSHook(NSArray *, getFlickPopupInfoArray, id arg1, NSString *key)
{
	NSArray *orig = _getFlickPopupInfoArray(arg1, key);
	NSLog(@"%@ %@ -> %@", arg1, key, orig);
	return orig;
}*/

typedef enum {
    kCFStringGramphemeCluster = 1, /* Unicode Grapheme Cluster (not different from kCFStringComposedCharacterCluster right now) */
    kCFStringComposedCharacterCluster = 2, /* Compose all non-base (including spacing marks) */
    kCFStringCursorMovementCluster = 3, /* Cluster suitable for cursor movements */
    kCFStringBackwardDeletionCluster = 4 /* Cluster suitable for backward deletion */
} CFStringCharacterClusterType;

extern "C" CFRange CFStringGetRangeOfCharacterClusterAtIndex(CFStringRef string, CFIndex charIndex, CFStringCharacterClusterType type);
MSHook(CFRange, CFStringGetRangeOfCharacterClusterAtIndex, CFStringRef string, CFIndex charIndex, CFStringCharacterClusterType type)
{
	CFRange range = _CFStringGetRangeOfCharacterClusterAtIndex(string, charIndex, type);
	if (type == kCFStringBackwardDeletionCluster) {
		CFIndex length = CFStringGetLength(string);
		if (length >= 3) {
			// 270a, 270b
			CFRange threeRange = CFRangeMake(length - 3, 3);
			CFStringRef threeSkin = CFStringCreateWithSubstring(kCFAllocatorDefault, string, threeRange);
			UniChar threeUnicode = CFStringGetCharacterAtIndex(threeSkin, 0);
			if (threeUnicode == 0x270A || threeUnicode == 0x270B) {
				UniChar _skin3Unicode = CFStringGetCharacterAtIndex(threeSkin, 1);
				UniChar skin3Unicode = CFStringGetCharacterAtIndex(threeSkin, 2);
				if (isSkinUnicode(skin3Unicode) && _skin3Unicode == 0xD83C)
					return threeRange;
			}
			if (length >= 4) {
				CFRange fourRange = CFRangeMake(length - 4, 4);
				CFStringRef emojiSkin = CFStringCreateWithSubstring(kCFAllocatorDefault, string, fourRange);
				UniChar lastUnicode = CFStringGetCharacterAtIndex(emojiSkin, 3);
				BOOL dingbat = lastUnicode == 0xFE0F;
				if (dingbat) {
					// 261d, 270c
					UniChar dingbatUnicode = CFStringGetCharacterAtIndex(emojiSkin, 0);
					if (dingbatUnicode == 0x261D || dingbatUnicode == 0x270C) {
						UniChar _dingbatSkinUnicode = CFStringGetCharacterAtIndex(emojiSkin, 1);
						UniChar dingbatSkinUnicode = CFStringGetCharacterAtIndex(emojiSkin, 2);
						if (isSkinUnicode(dingbatSkinUnicode) && _dingbatSkinUnicode == 0xD83C)
							return fourRange;
					}
				}
				// normal skin emoji
				UniChar _skinUnicode = CFStringGetCharacterAtIndex(emojiSkin, 2);
				if (isSkinUnicode(lastUnicode) && _skinUnicode == 0xD83C)
					return fourRange;
				if (length >= 8) {
					CFRange eightRange = CFRangeMake(length - 8, 8);
					CFStringRef eightEmoji = CFStringCreateWithSubstring(kCFAllocatorDefault, string, eightRange);
					UniChar _8d83dUnicode1 = CFStringGetCharacterAtIndex(eightEmoji, 0);
					UniChar _8d83dUnicode2 = CFStringGetCharacterAtIndex(eightEmoji, 6);
					UniChar _8200dUnicode1 = CFStringGetCharacterAtIndex(eightEmoji, 2);
					UniChar _8200dUnicode2 = CFStringGetCharacterAtIndex(eightEmoji, 5);
					if (_8d83dUnicode1 == 0xD83D && _8d83dUnicode2 == 0xD83D && _8200dUnicode1 == 0x200D && _8200dUnicode2 == 0x200D) {
						UniChar d81 = CFStringGetCharacterAtIndex(eightEmoji, 3);
						UniChar d82 = CFStringGetCharacterAtIndex(eightEmoji, 4);
						if (d81 == 0xD83D && (d82 == 0xDC68 || d82 == 0xDC69)) {
							UniChar p81 = CFStringGetCharacterAtIndex(eightEmoji, 1);
							UniChar c8 = CFStringGetCharacterAtIndex(eightEmoji, 7);
							if ((p81 == 0xDC68 || p81 == 0xDC69) && (c8 == 0xDC66 || c8 == 0xDC67)) {
								// 3 people family
								return eightRange;
							}
						}
						else if (d81 == 0x2764 && d82 == 0xFE0F) {
							UniChar mw1 = CFStringGetCharacterAtIndex(eightEmoji, 1);
							UniChar mw2 = CFStringGetCharacterAtIndex(eightEmoji, 7);
							if ((mw1 == 0xDC68 && mw2 == 0xDC68) || (mw1 == 0xDC69 && mw2 == 0xDC69)) {
								// mmww normal
								return eightRange;
							}
						}
					}
					if (length >= 11) {
						CFRange elevenRange = CFRangeMake(length - 11, 11);
						CFStringRef elevenEmoji = CFStringCreateWithSubstring(kCFAllocatorDefault, string, elevenRange);
						UniChar _11d83dUnicode1 = CFStringGetCharacterAtIndex(elevenEmoji, 0);
						UniChar _11d83dUnicode2 = CFStringGetCharacterAtIndex(elevenEmoji, 6);
						UniChar _11d83dUnicode3 = CFStringGetCharacterAtIndex(elevenEmoji, 9);
						UniChar _11200dUnicode1 = CFStringGetCharacterAtIndex(elevenEmoji, 2);
						UniChar _11200dUnicode2 = CFStringGetCharacterAtIndex(elevenEmoji, 5);
						UniChar _11200dUnicode3 = CFStringGetCharacterAtIndex(elevenEmoji, 8);
						if (_11d83dUnicode1 == 0xD83D && _11d83dUnicode2 == 0xD83D && _11d83dUnicode3 == 0xD83D && _11200dUnicode1 == 0x200D && _11200dUnicode2 == 0x200D && _11200dUnicode3 == 0x200D) {
							UniChar d111 = CFStringGetCharacterAtIndex(elevenEmoji, 3);
							UniChar d112 = CFStringGetCharacterAtIndex(elevenEmoji, 4);
							UniChar d113 = CFStringGetCharacterAtIndex(elevenEmoji, 7);
							if (d111 == 0x2764 && d112 == 0xFE0F && d113 == 0xDC8B) {
								UniChar mwk1 =CFStringGetCharacterAtIndex(elevenEmoji, 1);
								UniChar mwk2 = CFStringGetCharacterAtIndex(elevenEmoji, 10);
								if ((mwk1 == 0xDC68 && mwk2 == 0xDC68) || (mwk1 == 0xDC69 && mwk2 == 0xDC69)) {
									// mmww kiss
									return elevenRange;
								}
							}
							else if (d111 == 0xD83D) {
								UniChar p111 = CFStringGetCharacterAtIndex(elevenEmoji, 1);
								UniChar p112 = CFStringGetCharacterAtIndex(elevenEmoji, 4);
								UniChar c111 = CFStringGetCharacterAtIndex(elevenEmoji, 7);
								UniChar c112 = CFStringGetCharacterAtIndex(elevenEmoji, 10);
								BOOL family4 = NO;
								BOOL mw = (p111 == 0xDC68 && p112 == 0xDC69);
								BOOL ww = (p111 == 0xDC69 && p112 == 0xDC69);
								BOOL mm = (p111 == 0xDC68 && p112 == 0xDC68);
								BOOL gb = (c111 == 0xDC67 && c112 == 0xDC66);
								BOOL bb = (c111 == 0xDC66 && c112 == 0xDC66);
								BOOL gg = (c111 == 0xDC67 && c112 == 0xDC67);
								family4 = (mw || ww || mm) && (gb || bb || gg);
								if (family4) {
									// 4 people family
									return elevenRange;
								}
							}
						}
					}
				}
			}
		}
	}
	return range;
}

%ctor
{
	NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
	NSUInteger count = args.count;
	if (count != 0) {
		NSString *executablePath = args[0];
		if (executablePath) {
			BOOL isApplication = [executablePath rangeOfString:@"/Application"].location != NSNotFound;
			BOOL isSpringBoard = [[executablePath lastPathComponent] isEqualToString:@"SpringBoard"];
			if (isApplication || isSpringBoard) {
				MSImageRef ref = MSGetImageByName("/System/Library/Frameworks/UIKit.framework/UIKit");
				UIKeyboardGetKBStarName = (NSString *(*)(UIKeyboardInputMode *, UIKBScreenTraits *, int, int))MSFindSymbol(ref, "_UIKeyboardGetKBStarName");
				dlopen("/System/Library/PrivateFrameworks/UIFoundation.framework/UIFoundation", RTLD_LAZY);
				%init;
				//NSArray *(*getFlickPopupInfoArray)(id, NSString *) = (NSArray *(*)(id, NSString *))MSFindSymbol(ref, "_getFlickPopupInfoArray");
				//MSHookFunction(getFlickPopupInfoArray, MSHake(getFlickPopupInfoArray));
				MSHookFunction(_UIImageWithName, MSHake(_UIImageWithName));
				MSHookFunction(CFStringGetRangeOfCharacterClusterAtIndex, MSHake(CFStringGetRangeOfCharacterClusterAtIndex));
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
		}
	}
}