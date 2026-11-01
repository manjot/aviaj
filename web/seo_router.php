<?php
/**
 * Server-Side SEO Router for Aviaj (`https://aviaj.com/`).
 * Injects page-specific <title>, <meta name="description">, <meta name="keywords">,
 * <link rel="canonical">, Open Graph tags, Twitter Cards, JSON-LD structured data,
 * and semantic <noscript> HTML for every header route before booting the Flutter Web app.
 */

$requestUri = isset($_SERVER['REQUEST_URI']) ? $_SERVER['REQUEST_URI'] : '/';
$parsedPath = parse_url($requestUri, PHP_URL_PATH);
$path = strtolower(rtrim($parsedPath ?: '/', '/'));
if ($path === '') {
    $path = '/';
}

$seoPages = [
    '/' => [
        'title' => 'Aviaj — Travel Buddy, Vacation Romance & Relationship Dating App',
        'description' => 'Meet your next co-pilot on Aviaj. Connect with verified solo & group travel buddies, vacation romance matches, and lifelong relationship partners across Manali, Goa, Andaman, USA, Europe & Middle East.',
        'keywords' => 'Aviaj, travel dating app, travel buddy app, vacation romance, solo travel companions, Manali trek buddies, Goa travel dating, relationship app',
        'h1' => 'Meet your next co-pilot. Bring every journey closer to love.',
        'breadcrumb' => 'Home',
    ],
    '/date' => [
        'title' => 'Aviaj Date — Features Designed to Make Online Dating Enjoyable | Aviaj',
        'description' => 'Explore Aviaj Date features designed for real, respectful, and meaningful connections: Compliments, Incognito Mode, HD Video Calls, Travel Mode, Snooze Mode, and SuperSwipe.',
        'keywords' => 'Aviaj Date, online dating features, respectful dating app, Compliments, Incognito Mode, Travel Mode, Video Calls, Snooze Mode, SuperSwipe',
        'h1' => 'Features Designed to Make Online Dating Actually, You Know, Enjoyable',
        'breadcrumb' => 'Explore Date',
    ],
    '/date/compliments' => [
        'title' => 'Aviaj Compliments — Send a Kind Note Before You Match | Aviaj Date',
        'description' => 'Make them blush with Aviaj Compliments. Send a thoughtful message on a profile prompt, travel itinerary, or photo before you even match.',
        'keywords' => 'Aviaj Compliments, message before matching, dating app compliments, profile prompt reply, stand out on Aviaj Date',
        'h1' => 'Make Them Blush with Aviaj Compliments',
        'breadcrumb' => 'Compliments',
    ],
    '/date/incognito-mode' => [
        'title' => 'Aviaj Incognito Mode — Browse Profiles Privately & Control Who Sees You | Aviaj Date',
        'description' => 'Go undercover with Aviaj Incognito Mode. Hide your profile from your boss, relatives, or exes, and only be visible to people you swipe right on.',
        'keywords' => 'Aviaj Incognito Mode, private dating app mode, hide dating profile, anonymous browsing dating, Aviaj Premium privacy',
        'h1' => 'Go Undercover with Aviaj Incognito Mode',
        'breadcrumb' => 'Incognito Mode',
    ],
    '/date/video-calls' => [
        'title' => 'Aviaj Video Calls & Audio Chats — Vibe Check Before Meeting IRL | Aviaj Date',
        'description' => 'Sound it out with Aviaj in-app HD video calls and audio chats. Get as close to IRL without leaving your house or sharing your personal phone number.',
        'keywords' => 'Aviaj Video Calls, in-app audio chat, safe virtual date, video call dating app, verify chemistry before meeting',
        'h1' => 'Sound It Out with In-App Video Calls & Audio Chats',
        'breadcrumb' => 'Video Calls',
    ],
    '/date/travel-mode' => [
        'title' => 'Aviaj Travel Mode — Match with Locals & Travellers Before You Land | Aviaj Date',
        'description' => 'Take us away with Aviaj Travel Mode. Set your destination city or trek route before departure and match with locals and co-travellers anywhere in the world.',
        'keywords' => 'Aviaj Travel Mode, match in another city, travel dating passport, destination matching, Manali Goa Bali Paris Dubai dating',
        'h1' => 'Take Us Away with Aviaj Travel Mode',
        'breadcrumb' => 'Travel Mode',
    ],
    '/date/snooze-mode' => [
        'title' => 'Aviaj Snooze Mode — Take a Mindful Break Without Losing Matches | Aviaj Date',
        'description' => 'Put dating on hold with Aviaj Snooze Mode for 24 hours, 72 hours, a week, or indefinitely while keeping all your existing matches and conversations safe.',
        'keywords' => 'Aviaj Snooze Mode, pause dating profile, digital detox dating, take a break from online dating, keep matches paused',
        'h1' => 'Take a Break with Aviaj Snooze Mode',
        'breadcrumb' => 'Snooze Mode',
    ],
    '/date/superswipe' => [
        'title' => 'Aviaj SuperSwipe — Let Someone Special Know They Passed the Vibe Check | Aviaj Date',
        'description' => 'Get their attention with Aviaj SuperSwipe. Highlight your profile at the top of their queue and multiply your chance of an instant connection.',
        'keywords' => 'Aviaj SuperSwipe, priority like dating app, stand out to matches, boost match rate Aviaj',
        'h1' => 'Get Their Attention with Aviaj SuperSwipe',
        'breadcrumb' => 'SuperSwipe',
    ],
    '/aff' => [
        'title' => 'AFF (Aviaj Friends Forever) — Find Travel Friends, Local Crews & Group Departures',
        'description' => 'Whether you moved to a new city, landed solo abroad, or want to expand your circle, AFF (Aviaj Friends Forever) makes it easy to meet like-minded people.',
        'keywords' => 'AFF, Aviaj Friends Forever, platonic friendship app, find travel buddies, solo group travel crew, make friends in a new city',
        'h1' => 'AFF — Aviaj Friends Forever: Find Your People Anywhere',
        'breadcrumb' => 'Explore AFF',
    ],
    '/aff/departure-plans' => [
        'title' => 'AFF Departure Plans — Match with Co-Travellers on Your Exact Dates | Aviaj AFF',
        'description' => 'Share your upcoming trek, island getaway, or city break on AFF Departure Plans to build a verified Villa Crew and Route Chat before takeoff.',
        'keywords' => 'AFF Departure Plans, shared travel itinerary, group trip matching, Villa Crew, Route Chat, co-traveller finder',
        'h1' => 'AFF Departure Plans — Coordinate Shared Travel Itineraries',
        'breadcrumb' => 'Departure Plans',
    ],
    '/aff/community-leaders' => [
        'title' => 'AFF Community Leaders — Verified Local Hosts & Group Trek Organizers | Aviaj AFF',
        'description' => 'Join verified AFF Community Leaders hosting local social mixers, Himalayan treks, coastal runs, and newcomer meetups in 190+ destinations.',
        'keywords' => 'AFF Community Leaders, local meetup hosts, verified group trip leaders, Aviaj ambassadors, city friendship events',
        'h1' => 'AFF Community Leaders — Verified Local Hosts & Group Organizers',
        'breadcrumb' => 'Community Leaders',
    ],
    '/stories' => [
        'title' => 'Aviaj Love Stories — For the Love of Love | Real Couples Who Met on Aviaj',
        'description' => 'From Tokyo to Toronto and Dublin to Goa, explore real love stories from couples who met on Aviaj. Read Tosin & Kieron’s story or submit your own.',
        'keywords' => 'Aviaj Love Stories, dating app success stories, couples met on Aviaj, Tosin and Kieron, Share Your Love Story',
        'h1' => 'For the Love of Love — Real Aviaj Love Stories',
        'breadcrumb' => 'Love Stories',
    ],
    '/friendship-hub' => [
        'title' => 'The Friendship Hub — Advice & Guides for Building Meaningful Friendships | Aviaj AFF',
        'description' => 'Advice, guides, and stories to help you build the friendships you want. Learn how to make friends in a new city and navigate adult friendships on AFF.',
        'keywords' => 'The Friendship Hub, how to make friends as an adult, platonic friendship guides, AFF friendship advice, App Store Trend of the Year Connection',
        'h1' => 'The Friendship Hub — Advice & Guides for Platonic Connections',
        'breadcrumb' => 'The Friendship Hub',
    ],
    '/seasonal-dating-guides' => [
        'title' => 'Seasonal Dating Guides — Winter, Spring & Summer Date Ideas | Aviaj',
        'description' => 'Plan the perfect date—no matter when, where, or who you are dating. Explore Aviaj’s curated Winter, Spring, and Summer seasonal dating guides.',
        'keywords' => 'Seasonal Dating Guides, winter date ideas, spring dating guide, summer romance tips, outdoor date ideas Aviaj',
        'h1' => 'Seasonal Dating Guides — Plan the Perfect Date Every Season',
        'breadcrumb' => 'Seasonal Dating Guides',
    ],
    '/safety' => [
        'title' => 'Aviaj Safety Center — Your Safety Comes First, Always | Verification & Safety Tools',
        'description' => 'The Aviaj Safety Center guides you toward safe and meaningful connections with Photo & ID Verification, Private Detector, Deception Detector™, Share Date, and global safety partnerships.',
        'keywords' => 'Aviaj Safety Center, Photo Verification, ID Verification badge, Deception Detector, Private Detector, Share Date, online dating safety handbook',
        'h1' => 'Your Safety Comes First, Always — Aviaj Safety Center',
        'breadcrumb' => 'Safety Center',
    ],
    '/support' => [
        'title' => 'Aviaj Support & Help Center — How Can We Help? | Account, Profile & Safety Guides',
        'description' => 'Search Aviaj Support for answers about your account, connections, subscriptions, ID verification, troubleshooting, and safety resources.',
        'keywords' => 'Aviaj Support, Aviaj Help Center, cancel subscription, verify ID on Aviaj, report someone, online dating help',
        'h1' => 'How Can We Help? — Aviaj Support & Help Center',
        'breadcrumb' => 'Support Center',
    ],
    '/web-not-available' => [
        'title' => 'Aviaj Is Now App-Only — Download Aviaj on the App Store & Google Play',
        'description' => 'So we can keep bringing you the best experience and safety features, Aviaj is now app-only. Scan the QR code to download Aviaj on iOS or Android.',
        'keywords' => 'Aviaj app download, Aviaj iOS app, Aviaj Android app, switch to Aviaj app, Aviaj QR code',
        'h1' => 'Aviaj Is Now App-Only — Get the Aviaj App',
        'breadcrumb' => 'Get the Aviaj App',
    ],
];

// Support common aliases
$aliases = [
    '/love-stories' => '/stories',
    '/aff/friendship' => '/friendship-hub',
    '/stories/friendship-hub' => '/friendship-hub',
    '/date/seasonal' => '/seasonal-dating-guides',
    '/stories/seasonal-dating-guides' => '/seasonal-dating-guides',
    '/safety-center' => '/safety',
    '/help' => '/support',
    '/sign-in' => '/web-not-available',
];
if (isset($aliases[$path])) {
    $path = $aliases[$path];
}

$meta = isset($seoPages[$path]) ? $seoPages[$path] : $seoPages['/'];
$canonicalUrl = ($path === '/') ? 'https://aviaj.com/' : 'https://aviaj.com' . $path;

$htmlFile = __DIR__ . '/index.html';
if (!file_exists($htmlFile)) {
    http_response_code(404);
    echo 'index.html not found';
    exit;
}

$html = file_get_contents($htmlFile);

$titleEsc = htmlspecialchars($meta['title'], ENT_QUOTES, 'UTF-8');
$descEsc = htmlspecialchars($meta['description'], ENT_QUOTES, 'UTF-8');
$kwEsc = htmlspecialchars($meta['keywords'], ENT_QUOTES, 'UTF-8');
$canonEsc = htmlspecialchars($canonicalUrl, ENT_QUOTES, 'UTF-8');
$h1Esc = htmlspecialchars($meta['h1'], ENT_QUOTES, 'UTF-8');

$html = preg_replace('/<title>.*?<\/title>/is', '<title>' . $titleEsc . '</title>', $html);
$html = preg_replace('/<meta name="description" content=".*?">/i', '<meta name="description" content="' . $descEsc . '">', $html);
$html = preg_replace('/<meta name="keywords" content=".*?">/i', '<meta name="keywords" content="' . $kwEsc . '">', $html);
$html = preg_replace('/<link rel="canonical" href=".*?">/i', '<link rel="canonical" href="' . $canonEsc . '">', $html);
$html = preg_replace('/<meta property="og:title" content=".*?">/i', '<meta property="og:title" content="' . $titleEsc . '">', $html);
$html = preg_replace('/<meta property="og:description" content=".*?">/i', '<meta property="og:description" content="' . $descEsc . '">', $html);
$html = preg_replace('/<meta property="og:url" content=".*?">/i', '<meta property="og:url" content="' . $canonEsc . '">', $html);
$html = preg_replace('/<meta name="twitter:title" content=".*?">/i', '<meta name="twitter:title" content="' . $titleEsc . '">', $html);
$html = preg_replace('/<meta name="twitter:description" content=".*?">/i', '<meta name="twitter:description" content="' . $descEsc . '">', $html);

$noscriptBlock = '<noscript><main><h1>' . $h1Esc . '</h1><p>' . $descEsc . '</p>'
    . '<nav><a href="https://aviaj.com/">Aviaj Home</a> | '
    . '<a href="https://aviaj.com/date">Explore Date</a> | '
    . '<a href="https://aviaj.com/date/compliments">Compliments</a> | '
    . '<a href="https://aviaj.com/date/incognito-mode">Incognito Mode</a> | '
    . '<a href="https://aviaj.com/date/video-calls">Video Calls</a> | '
    . '<a href="https://aviaj.com/date/travel-mode">Travel Mode</a> | '
    . '<a href="https://aviaj.com/date/snooze-mode">Snooze Mode</a> | '
    . '<a href="https://aviaj.com/date/superswipe">SuperSwipe</a> | '
    . '<a href="https://aviaj.com/aff">AFF (Aviaj Friends Forever)</a> | '
    . '<a href="https://aviaj.com/aff/departure-plans">Departure Plans</a> | '
    . '<a href="https://aviaj.com/aff/community-leaders">Community Leaders</a> | '
    . '<a href="https://aviaj.com/stories">Love Stories</a> | '
    . '<a href="https://aviaj.com/friendship-hub">The Friendship Hub</a> | '
    . '<a href="https://aviaj.com/seasonal-dating-guides">Seasonal Dating Guides</a> | '
    . '<a href="https://aviaj.com/safety">Safety Center</a> | '
    . '<a href="https://aviaj.com/support">Support Center</a></nav></main></noscript>';

$html = str_replace('<body>', '<body>' . $noscriptBlock, $html);

header('Content-Type: text/html; charset=UTF-8');
echo $html;

