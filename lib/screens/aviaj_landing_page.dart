import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter, lerpDouble;
import 'package:flutter/material.dart';
import '../data/regional_data.dart';
import '../models/models.dart';
import '../services/ad_service.dart';
import '../services/localization_service.dart';
import '../services/seo_service.dart';
import '../services/stripe_service.dart';
import '../state/aviaj_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

/// Lengthy, spacious, editorial Marketing Landing Page for Web (`aviaj.com`).
/// Features the two-stage animated full-bleed Red Love hero banner:
///   1) Giant edge-to-edge `Aviaj` brand name staggered entrance animation
///   2) 3D angled perspective Profiles Slider fan-out + continuous smooth carousel
class AviajLandingPage extends StatefulWidget {
  final AviajState state;
  final VoidCallback onOpenFullMobilePreview;

  const AviajLandingPage({
    super.key,
    required this.state,
    required this.onOpenFullMobilePreview,
  });

  @override
  State<AviajLandingPage> createState() => _AviajLandingPageState();
}

class _AviajLandingPageState extends State<AviajLandingPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _safetyPartnersScrollController = ScrollController();
  final GlobalKey _modesKey = GlobalKey();
  final GlobalKey _dateSectionKey = GlobalKey();
  final GlobalKey _affKey = GlobalKey();
  final GlobalKey _radarKey = GlobalKey();
  final GlobalKey _storiesKey = GlobalKey();
  final GlobalKey _friendshipHubKey = GlobalKey();
  final GlobalKey _seasonalGuidesKey = GlobalKey();
  final GlobalKey _safetyCenterKey = GlobalKey();
  final GlobalKey _supportCenterKey = GlobalKey();
  final GlobalKey _appOnlyKey = GlobalKey();
  final GlobalKey _pricingKey = GlobalKey();
  int _selectedHeroIndex = 0;
  int _selectedStoryIndex = 0;
  String _supportSearchQuery = '';
  AviajSeoPage _activeSeoPage = AviajSeoPage.home;
  bool _showDateMegaMenu = false;
  bool _showAffMegaMenu = false;
  bool _showStoriesMegaMenu = false;
  bool _showPrivacyBanner = !SeoService.hasPrivacyConsent();
  bool _optOutMarketingPartners = false;

  void _setPrivacyConsentAccepted(bool accepted) {
    setState(() {
      _showPrivacyBanner = !accepted;
    });
    SeoService.setPrivacyConsent(accepted);
    widget.state.setPrivacyConsent(accepted);
  }

  late final AnimationController _bannerIntroController;
  late final AnimationController _profileSliderController;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _activeSeoPage = SeoService.detectInitialPage();
    final initialLangCode = SeoService.detectInitialLangCode();
    if (initialLangCode != null && initialLangCode != 'en') {
      final matchedLabel =
          AviajLocalizationService.labelFromCode(initialLangCode);
      if (matchedLabel != null) {
        _userSelectedLanguage = true;
        _selectedLanguageLabel = matchedLabel;
        final matchOpt = _languageOptions
            .where((o) => o.label == _selectedLanguageLabel)
            .toList();
        if (matchOpt.isNotEmpty) {
          widget.state.setRegion(matchOpt.first.region);
        }
      }
    }
    _applyCurrentSeo(pushHistory: false);
    SeoService.listenPopState((page) {
      if (!mounted) return;
      final poppedLang = SeoService.detectInitialLangCode();
      setState(() {
        _activeSeoPage = page;
        if (poppedLang != null && poppedLang != 'en') {
          final matchedLabel =
              AviajLocalizationService.labelFromCode(poppedLang);
          if (matchedLabel != null) {
            _userSelectedLanguage = true;
            _selectedLanguageLabel = matchedLabel;
          }
        }
        _showDateMegaMenu = false;
        _showAffMegaMenu = false;
        _showStoriesMegaMenu = false;
      });
      _applyCurrentSeo(pushHistory: false);
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });

    // Phase 1 (0.0 -> 0.55): Giant "Aviaj" display letters animate in.
    // Phase 2 (0.42 -> 1.00): 3D angled profile cards fan out over the center.
    _bannerIntroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1650),
    )..forward();

    // Phase 3: Continuous smooth 3D profile slider morphing Slot 3 -> 2 -> 1 -> 0 -> -1.
    _profileSliderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          setState(() {
            _selectedHeroIndex =
                (_selectedHeroIndex + 1) % widget.state.allProfiles.length;
          });
          _profileSliderController.reset();
        }
      });

    // Immediately detect visitor's live IP / VPN region (e.g. Turbo VPN USA -> Americas)
    _checkLiveIpRegion();

    // Automatically advance the 3D profiles slider and re-check live VPN IP region.
    _autoSlideTimer = Timer.periodic(
      const Duration(milliseconds: 2900),
      (_) {
        if (!mounted) return;
        _checkLiveIpRegion();
        if (_bannerIntroController.isCompleted &&
            !_profileSliderController.isAnimating) {
          _profileSliderController.forward(from: 0);
        }
      },
    );
  }

  Future<void> _checkLiveIpRegion() async {
    if (_userSelectedLanguage) return;
    final changed = await widget.state.refreshRegionFromLiveIp();
    if (changed && mounted) {
      setState(() {
        _selectedHeroIndex = 0;
      });
      _replayBannerAnimation();
    }
  }

  void _triggerNextProfileSlide() {
    if (_profileSliderController.isAnimating) return;
    _profileSliderController.forward(from: 0);
  }

  void _replayBannerAnimation() {
    _profileSliderController.reset();
    _bannerIntroController.forward(from: 0);
  }

  String _selectedLanguageLabel = 'English (United Kingdom)';
  bool _userSelectedLanguage = false;

  AviajLangPack get _langPack =>
      AviajLocalizationService.packForLabel(_selectedLanguageLabel);

  void _applyCurrentSeo({bool pushHistory = true}) {
    final pack = _langPack;
    SeoService.applyPageSeo(
      _activeSeoPage,
      pushHistory: pushHistory,
      langCode: pack.code,
      localizedTitle:
          AviajLocalizationService.seoTitleFor(_activeSeoPage, pack),
    );
  }

  static const List<({String label, AviajRegion region})> _languageOptions = [
    (label: 'English (United States)', region: AviajRegion.americas),
    (label: 'English (United Kingdom)', region: AviajRegion.europe),
    (label: 'English (Canada)', region: AviajRegion.americas),
    (label: 'English (Australia)', region: AviajRegion.asiaPacific),
    (label: 'English (India)', region: AviajRegion.india),
    (label: 'Deutsch', region: AviajRegion.europe),
    (label: 'Français', region: AviajRegion.europe),
    (label: 'Français (Canada)', region: AviajRegion.americas),
    (label: 'Español (España)', region: AviajRegion.europe),
    (label: 'Italiano', region: AviajRegion.europe),
    (label: 'Português (Brasil)', region: AviajRegion.americas),
    (label: 'Русский', region: AviajRegion.europe),
    (label: '中文 (简体)', region: AviajRegion.asiaPacific),
    (label: 'Bahasa Indonesia', region: AviajRegion.asiaPacific),
    (label: 'Dansk', region: AviajRegion.europe),
    (label: 'Español (México)', region: AviajRegion.americas),
    (label: 'Español (Colombia)', region: AviajRegion.americas),
    (label: 'Español (Argentina)', region: AviajRegion.americas),
    (label: 'Nederlands', region: AviajRegion.europe),
    (label: 'Norsk bokmål', region: AviajRegion.europe),
    (label: 'Polski', region: AviajRegion.europe),
    (label: 'Português (Portugal)', region: AviajRegion.europe),
    (label: 'Suomi', region: AviajRegion.europe),
    (label: 'Svenska', region: AviajRegion.europe),
    (label: 'हिंदी', region: AviajRegion.india),
    (label: '中文 (繁體)', region: AviajRegion.asiaPacific),
    (label: '日本語', region: AviajRegion.asiaPacific),
    (label: '한국어', region: AviajRegion.asiaPacific),
  ];

  void _selectRegion(AviajRegion region, {String? languageLabel}) {
    setState(() {
      _selectedHeroIndex = 0;
      _userSelectedLanguage = true;
      if (languageLabel != null) {
        _selectedLanguageLabel = languageLabel;
      } else {
        _selectedLanguageLabel = region.languageLabel;
      }
    });
    widget.state.setRegion(region);
    _applyCurrentSeo(pushHistory: true);
    _replayBannerAnimation();
  }

  void _openLanguageSelectorMenu(BuildContext pillContext) {
    final box = pillContext.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(pillContext).context.findRenderObject() as RenderBox?;
    Offset anchor = const Offset(100, 24);
    Size pillSize = const Size(98, 44);
    if (box != null && overlay != null) {
      anchor = box.localToGlobal(Offset.zero, ancestor: overlay);
      pillSize = box.size;
    }

    showGeneralDialog<void>(
      context: pillContext,
      barrierDismissible: true,
      barrierLabel: 'Close language selector',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 140),
      pageBuilder: (dialogContext, anim1, anim2) {
        final screenSize = MediaQuery.of(dialogContext).size;
        const menuWidth = 248.0;
        const menuCardHeight = 472.0;
        final tabHeight = pillSize.height;
        final totalHeight = menuCardHeight + tabHeight;

        final left = (anchor.dx + pillSize.width - menuWidth)
            .clamp(12.0, math.max(12.0, screenSize.width - menuWidth - 16.0))
            .toDouble();
        final top = anchor.dy
            .clamp(12.0, math.max(12.0, screenSize.height - totalHeight - 16.0))
            .toDouble();
        final tabLeftOffset =
            (anchor.dx - left).clamp(0.0, menuWidth - pillSize.width);

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.of(dialogContext).pop(),
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              left: left,
              top: top,
              child: Material(
                color: Colors.transparent,
                child: _LanguageSelectorDropdownCard(
                  selectedLanguageLabel: _selectedLanguageLabel,
                  options: _languageOptions,
                  tabLeftOffset: tabLeftOffset,
                  tabWidth: pillSize.width,
                  tabHeight: pillSize.height,
                  onSelect: (option) {
                    Navigator.of(dialogContext).pop();
                    _selectRegion(
                      option.region,
                      languageLabel: option.label,
                    );
                  },
                  onClose: () => Navigator.of(dialogContext).pop(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRegionSelectorPill({
    required bool isDarkPill,
    required bool showFullLanguageLabel,
  }) {
    return Builder(
      builder: (pillContext) {
        return InkWell(
          onTap: () => _openLanguageSelectorMenu(pillContext),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: showFullLanguageLabel ? 18 : 18,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isDarkPill ? const Color(0xFF220207) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: isDarkPill
                  ? Border.all(color: Colors.white24, width: 1)
                  : Border.all(
                      color: const Color(0xFFE0DFD9),
                      width: 1.1,
                    ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language_rounded,
                  color: isDarkPill ? Colors.white : const Color(0xFF1E1E1E),
                  size: 20,
                ),
                if (showFullLanguageLabel) ...[
                  const SizedBox(width: 8),
                  Text(
                    _selectedLanguageLabel,
                    style: TextStyle(
                      color:
                          isDarkPill ? Colors.white : const Color(0xFF1E1E1E),
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isDarkPill ? Colors.white : const Color(0xFF1E1E1E),
                  size: 22,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _bannerIntroController.dispose();
    _profileSliderController.dispose();
    _scrollController.dispose();
    _safetyPartnersScrollController.dispose();
    super.dispose();
  }

  void _navigateToSeoPage(
    AviajSeoPage page, {
    bool pushHistory = true,
    bool closeMegaMenus = true,
  }) {
    setState(() {
      _activeSeoPage = page;
      if (closeMegaMenus) {
        _showDateMegaMenu = false;
        _showAffMegaMenu = false;
        _showStoriesMegaMenu = false;
      }
    });
    _applyCurrentSeo(pushHistory: pushHistory);
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _scrollToSection(GlobalKey key) {
    if (key == _modesKey) {
      _navigateToSeoPage(AviajSeoPage.home);
      return;
    }
    if (key == _dateSectionKey) {
      _navigateToSeoPage(AviajSeoPage.date);
      return;
    }
    if (key == _affKey) {
      _navigateToSeoPage(AviajSeoPage.aff);
      return;
    }
    if (key == _storiesKey) {
      _navigateToSeoPage(AviajSeoPage.stories);
      return;
    }
    if (key == _friendshipHubKey) {
      _navigateToSeoPage(AviajSeoPage.friendshipHub);
      return;
    }
    if (key == _seasonalGuidesKey) {
      _navigateToSeoPage(AviajSeoPage.seasonalGuides);
      return;
    }
    if (key == _safetyCenterKey) {
      _navigateToSeoPage(AviajSeoPage.safety);
      return;
    }
    if (key == _supportCenterKey) {
      _navigateToSeoPage(AviajSeoPage.support);
      return;
    }
    if (key == _appOnlyKey) {
      _navigateToSeoPage(AviajSeoPage.appOnly);
      return;
    }

    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  List<Widget> _buildActiveSeoPageSections(
    BuildContext context,
    bool isDesktop,
  ) {
    switch (_activeSeoPage) {
      case AviajSeoPage.home:
        return [
          _buildSpaciousHeroSection(context, isDesktop),
          _buildBelowBannerIntroStrip(context, isDesktop),
          _buildRegionalTreksAndBeachesSection(context, isDesktop),
          Container(
            key: _radarKey,
            child: _buildDepartureCircleSection(context, isDesktop),
          ),
          Container(
            key: _modesKey,
            child: _buildThreeModesPillarSection(context, isDesktop),
          ),
          _buildGetTheAppQrPhonesBanner(context, isDesktop),
          Container(
            key: _pricingKey,
            child: _buildMinimalCabinUpgradesSection(context, isDesktop),
          ),
          _buildConversionBannerAndFooter(context, isDesktop),
        ];

      case AviajSeoPage.date:
        return [
          _buildStandalonePageHeaderBar(context, isDesktop),
          Container(
            key: _dateSectionKey,
            child: _buildExploreDateFullSection(context, isDesktop),
          ),
          _buildGetTheAppQrPhonesBanner(context, isDesktop),
          _buildConversionBannerAndFooter(context, isDesktop),
        ];

      case AviajSeoPage.dateCompliments:
      case AviajSeoPage.dateIncognito:
      case AviajSeoPage.dateVideoCalls:
      case AviajSeoPage.dateTravelMode:
      case AviajSeoPage.dateSnoozeMode:
      case AviajSeoPage.dateSuperSwipe:
        return [
          _buildStandalonePageHeaderBar(context, isDesktop),
          _buildDedicatedDateFeatureSeoSection(
            context,
            isDesktop,
            _activeSeoPage,
          ),
          _buildExploreDateFullSection(context, isDesktop),
          _buildConversionBannerAndFooter(context, isDesktop),
        ];

      case AviajSeoPage.aff:
        return [
          _buildStandalonePageHeaderBar(context, isDesktop),
          Container(
            key: _affKey,
            child: _buildAffFriendsForeverSection(context, isDesktop),
          ),
          _buildDepartureCircleSection(context, isDesktop),
          _buildConversionBannerAndFooter(context, isDesktop),
        ];

      case AviajSeoPage.affDeparturePlans:
      case AviajSeoPage.affCommunityLeaders:
        return [
          _buildStandalonePageHeaderBar(context, isDesktop),
          _buildDedicatedAffFeatureSeoSection(
            context,
            isDesktop,
            _activeSeoPage,
          ),
          _buildAffFriendsForeverSection(context, isDesktop),
          _buildDepartureCircleSection(context, isDesktop),
          _buildConversionBannerAndFooter(context, isDesktop),
        ];

      case AviajSeoPage.stories:
        return [
          _buildStandalonePageHeaderBar(context, isDesktop),
          Container(
            key: _storiesKey,
            child: _buildStoriesSection(context, isDesktop),
          ),
          _buildConversionBannerAndFooter(context, isDesktop),
        ];

      case AviajSeoPage.friendshipHub:
        return [
          _buildStandalonePageHeaderBar(context, isDesktop),
          Container(
            key: _friendshipHubKey,
            child: _buildFriendshipHubSection(context, isDesktop),
          ),
          _buildConversionBannerAndFooter(context, isDesktop),
        ];

      case AviajSeoPage.seasonalGuides:
        return [
          _buildStandalonePageHeaderBar(context, isDesktop),
          Container(
            key: _seasonalGuidesKey,
            child: _buildSeasonalDatingGuidesSection(context, isDesktop),
          ),
          _buildConversionBannerAndFooter(context, isDesktop),
        ];

      case AviajSeoPage.safety:
        return [
          _buildStandalonePageHeaderBar(context, isDesktop),
          Container(
            key: _safetyCenterKey,
            child: _buildSafetyCenterSection(context, isDesktop),
          ),
          _buildConversionBannerAndFooter(context, isDesktop),
        ];

      case AviajSeoPage.support:
        return [
          _buildStandalonePageHeaderBar(context, isDesktop),
          Container(
            key: _supportCenterKey,
            child: _buildSupportCenterSection(context, isDesktop),
          ),
          _buildConversionBannerAndFooter(context, isDesktop),
        ];

      case AviajSeoPage.appOnly:
        return [
          _buildStandalonePageHeaderBar(context, isDesktop),
          Container(
            key: _appOnlyKey,
            child: _buildAppOnlySwitchSection(context, isDesktop),
          ),
          _buildConversionBannerAndFooter(context, isDesktop),
        ];
    }
  }

  Widget _buildStandalonePageHeaderBar(BuildContext context, bool isDesktop) {
    final isSubFeaturePage = _activeSeoPage == AviajSeoPage.dateCompliments ||
        _activeSeoPage == AviajSeoPage.dateIncognito ||
        _activeSeoPage == AviajSeoPage.dateVideoCalls ||
        _activeSeoPage == AviajSeoPage.dateTravelMode ||
        _activeSeoPage == AviajSeoPage.dateSnoozeMode ||
        _activeSeoPage == AviajSeoPage.dateSuperSwipe ||
        _activeSeoPage == AviajSeoPage.affDeparturePlans ||
        _activeSeoPage == AviajSeoPage.affCommunityLeaders ||
        _activeSeoPage == AviajSeoPage.appOnly;
    final isRedHeader = !isSubFeaturePage &&
        (_activeSeoPage.navGroup == 'Date' ||
            _activeSeoPage.navGroup == 'AFF');
    final bgColor = isSubFeaturePage
        ? const Color(0xFFFFF8D6)
        : (isRedHeader ? AviajTheme.loveRed : Colors.white);
    final wordmarkColor = isRedHeader ? Colors.white : const Color(0xFF242424);

    final isAnyMegaMenuOpen =
        _showDateMegaMenu || _showAffMegaMenu || _showStoriesMegaMenu;

    return Container(
      width: double.infinity,
      color: bgColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              isDesktop ? 48 : 20,
              isDesktop ? 22 : 14,
              isDesktop ? 48 : 20,
              14,
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => _navigateToSeoPage(AviajSeoPage.home),
                  borderRadius: BorderRadius.circular(12),
                  child: Text(
                    'Aviaj',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 36,
                      letterSpacing: -1.4,
                      color: wordmarkColor,
                    ),
                  ),
                ),
                const Spacer(),
                if (isDesktop)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isRedHeader || isSubFeaturePage
                          ? Colors.white
                          : const Color(0xFFF5F4F0),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _NavbarLink(
                          label: 'Date',
                          isHighlighted: isAnyMegaMenuOpen
                              ? _showDateMegaMenu
                              : _activeSeoPage.navGroup == 'Date',
                          onTap: () {
                            setState(() {
                              _showDateMegaMenu = !_showDateMegaMenu;
                              _showAffMegaMenu = false;
                              _showStoriesMegaMenu = false;
                            });
                          },
                        ),
                        _NavbarLink(
                          label: 'AFF',
                          isHighlighted: isAnyMegaMenuOpen
                              ? _showAffMegaMenu
                              : _activeSeoPage.navGroup == 'AFF',
                          onTap: () {
                            setState(() {
                              _showAffMegaMenu = !_showAffMegaMenu;
                              _showDateMegaMenu = false;
                              _showStoriesMegaMenu = false;
                            });
                          },
                        ),
                        _NavbarLink(
                          label: _langPack.navStories,
                          isHighlighted: isAnyMegaMenuOpen
                              ? _showStoriesMegaMenu
                              : _activeSeoPage.navGroup == 'Stories',
                          onTap: () {
                            setState(() {
                              _showStoriesMegaMenu = !_showStoriesMegaMenu;
                              _showDateMegaMenu = false;
                              _showAffMegaMenu = false;
                            });
                          },
                        ),
                        _NavbarLink(
                          label: _langPack.navSafety,
                          isHighlighted: !isAnyMegaMenuOpen &&
                              _activeSeoPage == AviajSeoPage.safety,
                          onTap: () => _navigateToSeoPage(AviajSeoPage.safety),
                        ),
                        _NavbarLink(
                          label: _langPack.navSupport,
                          isHighlighted: !isAnyMegaMenuOpen &&
                              _activeSeoPage == AviajSeoPage.support,
                          onTap: () => _navigateToSeoPage(AviajSeoPage.support),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                _buildRegionSelectorPill(
                  isDarkPill: false,
                  showFullLanguageLabel: false,
                ),
              ],
            ),
          ),
          if (_showDateMegaMenu)
            Padding(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 48 : 16,
                4,
                isDesktop ? 48 : 16,
                16,
              ),
              child: _buildExploreDateMegaMenuCard(context, isDesktop),
            ),
          if (_showAffMegaMenu)
            Padding(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 48 : 16,
                4,
                isDesktop ? 48 : 16,
                16,
              ),
              child: _buildExploreAffMegaMenuCard(context, isDesktop),
            ),
          if (_showStoriesMegaMenu)
            Padding(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 48 : 16,
                4,
                isDesktop ? 48 : 16,
                16,
              ),
              child: _buildExploreStoriesMegaMenuCard(context, isDesktop),
            ),
        ],
      ),
    );
  }

  /// Interactive Split Feature Showcase Section matching `media_1793514258409_e9cf2354.jpg`:
  /// Left: Warm golden-yellow card (`#FFCB28`) with iPhone Mockup (`नवीन, 32 ✪` / `मार्केटिंग मैनेजर` / `इंडियन यूनिवर्सिटी`,
  /// protruding Compliment bubble `उन्होंने आपकी फ़ोटो की तारीफ़ की` / `"अरे वाह! ये फ़ोटो कहाँ ली गई थी? यह बहुत जानी-पहचानी लग रही है!"`,
  /// and 5 localized bottom tabs: `प्रोफ़ाइल`, `खोज`, `लोग`, `आपको पसंद किया`, `चैट`).
  /// Right: Stacked bold display headline keeping the SEO segment name in English (`COMPLIMENTS फ़ीचर कैसे काम करता है`),
  /// localized body paragraph keeping `Aviaj`, `Compliments`, and `Premium+` in English for SEO, and dark pill button (`Aviaj को डाउनलोड करें`).
  Widget _buildLocalizedFeatureShowcaseSplitSection({
    required BuildContext context,
    required bool isDesktop,
    required String seoSegmentUpper,
    required String seoSegmentName,
  }) {
    final lp = _langPack;

    Widget buildBottomTab(
      IconData icon,
      String label, {
      bool isActive = false,
    }) {
      return Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive
                  ? const Color(0xFF1E1E1E)
                  : const Color(0xFF5A5A5A),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isActive
                    ? const Color(0xFF1E1E1E)
                    : const Color(0xFF5A5A5A),
                fontSize: 10.5,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                height: 1.15,
              ),
            ),
          ],
        ),
      );
    }

    final phoneShowcaseCard = Container(
      width: isDesktop ? 510 : double.infinity,
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 28 : 14,
        0,
        isDesktop ? 28 : 14,
        28,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCB28),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Center(
        child: SizedBox(
          width: isDesktop ? 420 : 340,
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              // iPhone Frame (Flush at top, rounded bottom bezel)
              Container(
                width: isDesktop ? 344 : 296,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(44),
                  ),
                  border: Border(
                    left: BorderSide(color: Color(0xFF242424), width: 6),
                    right: BorderSide(color: Color(0xFF242424), width: 6),
                    bottom: BorderSide(color: Color(0xFF242424), width: 6),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile Portrait Card inside iPhone
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(22),
                        ),
                        child: SizedBox(
                          height: isDesktop ? 305 : 265,
                          width: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              const AviajNetworkImage(
                                imageUrl:
                                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=900&q=85',
                                width: double.infinity,
                                height: 305,
                                fallbackLabel: 'Naveen, 32',
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.18),
                                      Colors.black.withValues(alpha: 0.72),
                                    ],
                                  ),
                                ),
                              ),
                              // Profile Name, Role, University & Compliment Heart Bubble on Bottom-Left
                              Positioned(
                                left: 16,
                                right: 76,
                                bottom: 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            lp.mockupProfileNameAge,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: -0.4,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.verified_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.work_outline_rounded,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            lp.mockupProfileRole,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.school_outlined,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            lp.mockupProfileUni,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    // Yellow Compliment Heart-Speech-Bubble Badge
                                    Container(
                                      width: 34,
                                      height: 34,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFFCB28),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.mark_chat_unread_rounded,
                                        color: Color(0xFF242424),
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Large Yellow SuperSwipe Star Circle on Bottom-Right
                              Positioned(
                                right: 14,
                                bottom: 14,
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFCB28),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFF242424),
                                    size: 32,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Spacer for the protruding Compliment Bubble Card
                    SizedBox(height: isDesktop ? 132 : 138),
                    // Bottom 5-Icon Localized App Navigation Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildBottomTab(
                            Icons.person_outline_rounded,
                            lp.mockupTabProfile,
                          ),
                          buildBottomTab(
                            Icons.workspace_premium_outlined,
                            lp.mockupTabDiscover,
                          ),
                          buildBottomTab(
                            Icons.subject_rounded,
                            lp.mockupTabPeople,
                            isActive: true,
                          ),
                          buildBottomTab(
                            Icons.favorite_border_rounded,
                            lp.mockupTabLikedYou,
                          ),
                          buildBottomTab(
                            Icons.chat_bubble_outline_rounded,
                            lp.mockupTabChats,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Protruding Floating Compliment Message Card (overlapping left & right edges of iPhone)
              Positioned(
                top: isDesktop ? 292 : 254,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3B0),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              lp.mockupComplimentHeader,
                              style: const TextStyle(
                                color: Color(0xFF242424),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              lp.mockupComplimentQuote,
                              style: TextStyle(
                                color: const Color(0xFF1E1E1E),
                                fontSize: isDesktop ? 17.5 : 15,
                                fontWeight: FontWeight.w900,
                                height: 1.24,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: const AviajNetworkImage(
                          imageUrl:
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
                          width: 68,
                          height: 76,
                          fallbackLabel: 'Sender',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final rightCopyColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          lp.howFeatureWorksTitle(seoSegmentUpper),
          style: TextStyle(
            color: const Color(0xFF242424),
            fontSize: isDesktop ? 64 : 38,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.6,
            height: 1.06,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          lp.howFeatureWorksBody(seoSegmentName),
          style: TextStyle(
            color: const Color(0xFF242424),
            fontSize: isDesktop ? 17.5 : 15.5,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: () => showMobileAppDownloadModal(context),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF242424),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: Text(
            lp.downloadAviajBtn,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15.5,
            ),
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      color: const Color(0xFFFFEC19),
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 64 : 20,
        isDesktop ? 56 : 36,
        isDesktop ? 64 : 20,
        isDesktop ? 56 : 36,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    phoneShowcaseCard,
                    const SizedBox(width: 64),
                    Expanded(child: rightCopyColumn),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    phoneShowcaseCard,
                    const SizedBox(height: 32),
                    rightCopyColumn,
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildDedicatedDateFeatureSeoSection(
    BuildContext context,
    bool isDesktop,
    AviajSeoPage page,
  ) {
    final pack = widget.state.regionalPack;
    final lp = _langPack;
    final seoSegmentUpper = switch (page) {
      AviajSeoPage.dateCompliments => 'COMPLIMENTS',
      AviajSeoPage.dateIncognito => 'INCOGNITO MODE',
      AviajSeoPage.dateVideoCalls => 'VIDEO CALLS',
      AviajSeoPage.dateTravelMode => 'TRAVEL MODE',
      AviajSeoPage.dateSnoozeMode => 'SNOOZE MODE',
      _ => 'SUPERSWIPE',
    };
    final seoSegmentName = page.breadcrumbLabel;
    final featureConfig = switch (page) {
      AviajSeoPage.dateCompliments => (
          heroTitle: lp.featureOnAviajTitle('COMPLIMENTS'),
          heroSubtitle: lp.featureOnAviajSubtitle('Compliments'),
          heroPhotoUrl:
              'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?auto=format&fit=crop&w=1400&q=85',
          lead:
              'Stand out before you even match. Send a thoughtful Compliment on someone’s photo, bio prompt, or upcoming travel route so your first move feels personal and genuine.',
          steps: [
            (
              num: '01',
              title: 'Spot a prompt or travel photo you love',
              body:
                  'Tap the yellow heart speech-bubble icon on any profile photo, bio prompt, or destination badge.'
            ),
            (
              num: '02',
              title: 'Write a personal, kind note',
              body:
                  'Share why their Manali trek photo, Goa beach prompt, or travel bucket list caught your eye.'
            ),
            (
              num: '03',
              title: 'Jump straight to the top of their queue',
              body:
                  'Your Compliment appears directly in their matches & likes feed so they can reply and start chatting immediately.'
            ),
          ],
          faqs: [
            (
              q: 'How do Compliments work on Aviaj Date?',
              a: 'Compliments let you send a short, personalized message on a specific part of someone’s profile before matching, prioritizing your profile in their feed.'
            ),
            (
              q: 'Can I send a Compliment on a travel itinerary?',
              a: 'Yes! You can compliment a member’s destination badge, bio prompt, or portrait photo to break the ice effortlessly.'
            ),
          ],
        ),
      AviajSeoPage.dateIncognito => (
          heroTitle: lp.featureOnAviajTitle('INCOGNITO MODE'),
          heroSubtitle: lp.featureOnAviajSubtitle('Incognito Mode'),
          heroPhotoUrl: pack.storyCoupleImageUrl,
          lead:
              'Date on your own terms with complete privacy. Hide your profile from your boss, relatives, coworkers, or exes—only the people you swipe right on will ever see your profile.',
          steps: [
            (
              num: '01',
              title: 'Toggle Incognito Mode in Settings',
              body:
                  'Activate Incognito Mode with one tap whenever you want private browsing at home or while travelling.'
            ),
            (
              num: '02',
              title: 'Browse every profile invisibly',
              body:
                  'Your profile remains completely hidden from the public discovery deck and local departure radars.'
            ),
            (
              num: '03',
              title: 'Reveal yourself only to people you like',
              body:
                  'When you swipe right or send a Compliment, your profile becomes visible exclusively to that person.'
            ),
          ],
          faqs: [
            (
              q: 'Who can see me when Incognito Mode is turned on?',
              a: 'Only the members you actively swipe right on (and your existing matches) can see your profile.'
            ),
            (
              q: 'Does Incognito Mode work with Travel Mode?',
              a: 'Yes. You can privately scout matches in your upcoming destination city without appearing in the public feed.'
            ),
          ],
        ),
      AviajSeoPage.dateVideoCalls => (
          heroTitle: lp.featureOnAviajTitle('VIDEO CALLS'),
          heroSubtitle: lp.featureOnAviajSubtitle('Video Calls'),
          heroPhotoUrl:
              'https://images.unsplash.com/photo-1522529599102-193c0d76b5b6?auto=format&fit=crop&w=1400&q=85',
          lead:
              'Get as close to IRL without leaving your house. Verify chemistry, plan a shared trek, or have a virtual coffee date using encrypted HD video calls and audio chats—without ever sharing your phone number.',
          steps: [
            (
              num: '01',
              title: 'Match and start a conversation',
              body:
                  'Once you and your match have exchanged a message, the video and voice call icons unlock at the top of your chat.'
            ),
            (
              num: '02',
              title: 'Tap Video Call or Audio Chat',
              body:
                  'Start a spontaneous voice check-in or schedule a face-to-face HD video date right inside the Aviaj app.'
            ),
            (
              num: '03',
              title: 'Keep your personal phone number private',
              body:
                  'All calls run over Aviaj’s secure in-app network so your personal contact details stay 100% private.'
            ),
          ],
          faqs: [
            (
              q: 'Does my match see my phone number during an Aviaj Video Call?',
              a: 'Never. Aviaj Video Calls and Audio Chats are completely in-app, so your phone number and personal details remain private.'
            ),
            (
              q: 'Can I switch between audio and video during a call?',
              a: 'Yes, you can toggle your camera or microphone on and off at any moment during the call.'
            ),
          ],
        ),
      AviajSeoPage.dateTravelMode => (
          heroTitle: lp.featureOnAviajTitle('TRAVEL MODE'),
          heroSubtitle: lp.featureOnAviajSubtitle('Travel Mode'),
          heroPhotoUrl:
              'https://images.unsplash.com/photo-1530789253388-582c481c54b0?auto=format&fit=crop&w=1400&q=85',
          lead:
              'Find your duty-free snack and match anywhere in the world before you even pack your bags. Set your city to Manali, Goa, Andaman, Bali, Paris, Dubai, or New York and line up dates before you land.',
          steps: [
            (
              num: '01',
              title: 'Pick your upcoming destination',
              body:
                  'Open Travel Mode and select any city, beach coast, or mountain trekking hub worldwide.'
            ),
            (
              num: '02',
              title: 'Display your Travel Mode badge',
              body:
                  'A planes-and-passport badge lets locals and fellow travellers know you are visiting soon.'
            ),
            (
              num: '03',
              title: 'Match and plan IRL meetups before arrival',
              body:
                  'Chat with verified locals and solo travellers so your first sunset or trek is already planned when you touch down.'
            ),
          ],
          faqs: [
            (
              q: 'How far in advance can I use Aviaj Travel Mode?',
              a: 'You can switch your location to any destination worldwide for up to 7 days at a time and change cities whenever your itinerary updates.'
            ),
            (
              q: 'Will people know I am using Travel Mode?',
              a: 'Yes, your profile displays a clear Travel Mode indicator showing the city you are visiting.'
            ),
          ],
        ),
      AviajSeoPage.dateSnoozeMode => (
          heroTitle: lp.featureOnAviajTitle('SNOOZE MODE'),
          heroSubtitle: lp.featureOnAviajSubtitle('Snooze Mode'),
          heroPhotoUrl:
              'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=1400&q=85',
          lead:
              'Put online dating on hold whenever you need offline time. Pause your profile for 24 hours, 72 hours, a week, or indefinitely—without losing a single match or conversation.',
          steps: [
            (
              num: '01',
              title: 'Choose your Snooze duration',
              body:
                  'Select 24 hours, 72 hours, 1 week, or Indefinitely from your Aviaj profile settings.'
            ),
            (
              num: '02',
              title: 'Set an optional away status',
              body:
                  'Let existing matches know you are travelling, focusing on work, or taking a digital detox.'
            ),
            (
              num: '03',
              title: 'Return whenever you are ready',
              body:
                  'Disable Snooze Mode with one tap to pick up every conversation right where you left off.'
            ),
          ],
          faqs: [
            (
              q: 'Do I lose my matches when I turn on Snooze Mode?',
              a: 'No! All of your existing matches and chat threads remain intact while your profile is hidden from new swipes.'
            ),
            (
              q: 'Can I still message my current matches while snoozed?',
              a: 'Yes, your existing conversations remain accessible whenever you want to check in.'
            ),
          ],
        ),
      _ => (
          heroTitle: lp.featureOnAviajTitle('SUPERSWIPE'),
          heroSubtitle: lp.featureOnAviajSubtitle('SuperSwipe'),
          heroPhotoUrl:
              'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=1400&q=85',
          lead:
              'Seen someone who passed the vibe check 100%? Send a SuperSwipe to place your profile at the front of their queue with a golden star badge so they know you’re genuinely interested.',
          steps: [
            (
              num: '01',
              title: 'Tap the golden Star icon on their profile',
              body:
                  'When someone’s travel style, values, and photos stand out, tap SuperSwipe instead of a standard swipe.'
            ),
            (
              num: '02',
              title: 'Priority placement in their feed',
              body:
                  'Your profile is boosted to the top of their discovery deck with a highlighted SuperSwipe badge.'
            ),
            (
              num: '03',
              title: 'Up to 3x higher match probability',
              body:
                  'Members who receive a SuperSwipe know you intentionally chose them, sparking faster, more engaged conversations.'
            ),
          ],
          faqs: [
            (
              q: 'What does a SuperSwipe do on Aviaj?',
              a: 'A SuperSwipe notifies the other member that you really stood out to them and places your profile at the top of their match queue.'
            ),
            (
              q: 'How many SuperSwipes do Aviaj Premium members get?',
              a: 'Business Class and First Class VIP members receive weekly complimentary SuperSwipes that renew automatically.'
            ),
          ],
        ),
    };

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFFFFF8D6),
          padding: EdgeInsets.fromLTRB(
            isDesktop ? 64 : 20,
            isDesktop ? 42 : 24,
            isDesktop ? 64 : 20,
            isDesktop ? 64 : 40,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Centered Condensed Display Headline ("COMPLIMENTS ON AVIAJ" / localized)
                  Text(
                    featureConfig.heroTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF242424),
                      fontSize: isDesktop ? 76 : 40,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2.4,
                      height: 0.98,
                    ),
                  ),
                  const SizedBox(height: 18),
                  // 2. Centered Subtitle ("Want to make their day? Sounds like you’re ready to use Compliments.")
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Text(
                      featureConfig.heroSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF242424),
                        fontSize: isDesktop ? 19 : 15.5,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: isDesktop ? 42 : 26),
                  // 3. Wide Rounded Couple Hero Photograph
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: SizedBox(
                      width: double.infinity,
                      height: isDesktop ? 490 : 280,
                      child: AviajNetworkImage(
                        imageUrl: featureConfig.heroPhotoUrl,
                        width: double.infinity,
                        height: isDesktop ? 490 : 280,
                        fallbackLabel: featureConfig.heroTitle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildLocalizedFeatureShowcaseSplitSection(
          context: context,
          isDesktop: isDesktop,
          seoSegmentUpper: seoSegmentUpper,
          seoSegmentName: seoSegmentName,
        ),
        Container(
          width: double.infinity,
          color: const Color(0xFFFFF8D6),
          padding: EdgeInsets.fromLTRB(
            isDesktop ? 64 : 20,
            isDesktop ? 56 : 36,
            isDesktop ? 64 : 20,
            isDesktop ? 72 : 44,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 4. 3-Step "How It Works" SEO Cards
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      lp.howFeatureWorksTitle(seoSegmentUpper).replaceAll('\n', ' '),
                      style: TextStyle(
                        color: const Color(0xFF1E1E1E),
                        fontSize: isDesktop ? 36 : 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.9,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (isDesktop)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (int i = 0;
                              i < featureConfig.steps.length;
                              i++) ...[
                            if (i > 0) const SizedBox(width: 24),
                            Expanded(
                              child: _buildSeoStepCard(
                                numLabel: featureConfig.steps[i].num,
                                title: featureConfig.steps[i].title,
                                body: featureConfig.steps[i].body,
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        for (int i = 0;
                            i < featureConfig.steps.length;
                            i++) ...[
                          if (i > 0) const SizedBox(height: 16),
                          _buildSeoStepCard(
                            numLabel: featureConfig.steps[i].num,
                            title: featureConfig.steps[i].title,
                            body: featureConfig.steps[i].body,
                          ),
                        ],
                      ],
                    ),

                  const SizedBox(height: 48),

                  // 5. SEO FAQ Block
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Frequently asked questions about ${page.breadcrumbLabel}',
                      style: TextStyle(
                        color: const Color(0xFF1E1E1E),
                        fontSize: isDesktop ? 30 : 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (final faq in featureConfig.faqs)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE8E4DC)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            faq.q,
                            style: const TextStyle(
                              color: Color(0xFF1E1E1E),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            faq.a,
                            style: const TextStyle(
                              color: Color(0xFF4A3B40),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeoStepCard({
    required String numLabel,
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5CC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'STEP $numLabel',
              style: const TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: const TextStyle(
              color: Color(0xFF4A3B40),
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDedicatedAffFeatureSeoSection(
    BuildContext context,
    bool isDesktop,
    AviajSeoPage page,
  ) {
    final lp = _langPack;
    final isPlans = page == AviajSeoPage.affDeparturePlans;
    final seoSegmentUpper = isPlans ? 'PLANS' : 'COMMUNITY LEADERS';
    final seoSegmentName = isPlans ? 'Plans' : 'Community Leaders';
    final heroTitle = lp.featureOnAviajTitle(seoSegmentUpper);
    final heroSubtitle = lp.featureOnAviajSubtitle(seoSegmentName);
    final heroPhotoUrl = isPlans
        ? 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=1400&q=85'
        : 'https://images.unsplash.com/photo-1511632765486-a01980e01a18?auto=format&fit=crop&w=1400&q=85';

    final steps = isPlans
        ? [
            (
              num: '01',
              title: 'Create a Departure Plan or Local Hangout',
              body:
                  'Pick your destination, date range, and activity vibe—from Himalayan trekking to café hopping.'
            ),
            (
              num: '02',
              title: 'Invite verified AFF members nearby',
              body:
                  'Travellers and locals matching your dates can request to join your Villa Crew or Route Chat.'
            ),
            (
              num: '03',
              title: 'Meet up safely in real life',
              body:
                  'Chat in a shared group thread, verify everyone with Photo & ID badges, and enjoy the journey together.'
            ),
          ]
        : [
            (
              num: '01',
              title: 'Browse verified Community Leaders in your city',
              body:
                  'Discover local ambassadors hosting weekly runs, language exchanges, and weekend treks.'
            ),
            (
              num: '02',
              title: 'RSVP to an upcoming AFF community event',
              body:
                  'See who else is attending, join the event group chat, and break the ice before arriving.'
            ),
            (
              num: '03',
              title: 'Apply to become an AFF Community Leader',
              body:
                  'Love bringing people together? Apply in-app to host official Aviaj Friends Forever events in your city.'
            ),
          ];

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFFFFF8D6),
          padding: EdgeInsets.fromLTRB(
            isDesktop ? 64 : 20,
            isDesktop ? 42 : 24,
            isDesktop ? 64 : 20,
            isDesktop ? 64 : 40,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    heroTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF242424),
                      fontSize: isDesktop ? 74 : 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2.3,
                      height: 0.98,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Text(
                      heroSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF242424),
                        fontSize: isDesktop ? 19 : 15.5,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: isDesktop ? 42 : 26),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: SizedBox(
                      width: double.infinity,
                      height: isDesktop ? 480 : 280,
                      child: AviajNetworkImage(
                        imageUrl: heroPhotoUrl,
                        width: double.infinity,
                        height: isDesktop ? 480 : 280,
                        fallbackLabel: heroTitle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildLocalizedFeatureShowcaseSplitSection(
          context: context,
          isDesktop: isDesktop,
          seoSegmentUpper: seoSegmentUpper,
          seoSegmentName: seoSegmentName,
        ),
        Container(
          width: double.infinity,
          color: const Color(0xFFFFF8D6),
          padding: EdgeInsets.fromLTRB(
            isDesktop ? 64 : 20,
            isDesktop ? 56 : 36,
            isDesktop ? 64 : 20,
            isDesktop ? 68 : 40,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isDesktop)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (int i = 0; i < steps.length; i++) ...[
                            if (i > 0) const SizedBox(width: 24),
                            Expanded(
                              child: _buildSeoStepCard(
                                numLabel: steps[i].num,
                                title: steps[i].title,
                                body: steps[i].body,
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        for (int i = 0; i < steps.length; i++) ...[
                          if (i > 0) const SizedBox(height: 16),
                          _buildSeoStepCard(
                            numLabel: steps[i].num,
                            title: steps[i].title,
                            body: steps[i].body,
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 980;

    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        final showPrivacy = _showPrivacyBanner &&
            !widget.state.hasAcceptedPrivacyConsent &&
            !SeoService.hasPrivacyConsent();
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: _buildActiveSeoPageSections(context, isDesktop),
                  ),
                ),
              ),
              if (showPrivacy)
                _buildPrivacyAcknowledgmentBanner(context, isDesktop),
            ],
          ),
        );
      },
    );
  }

  /// SECTION 1: Full-Bleed Solid Red Love Animated Hero Banner
  /// Phase 1: Giant edge-to-edge "Aviaj" wordmark animates in (staggered letters).
  /// Phase 2: 3D angled perspective profile cards fan out over the center ("Av" [cards] "aj").
  /// Phase 3: Continuous & interactive 3D profiles slider morphs cards right-to-left.
  Widget _buildSpaciousHeroSection(BuildContext context, bool isDesktop) {
    final screenWidth = MediaQuery.of(context).size.width;
    final profiles = widget.state.allProfiles;
    final stageHeight = isDesktop ? 610.0 : 460.0;
    final cardScale = isDesktop ? 1.0 : 0.64;
    final isAnyMegaMenuOpen =
        _showDateMegaMenu || _showAffMegaMenu || _showStoriesMegaMenu;

    return Container(
      width: double.infinity,
      color: AviajTheme.loveRed,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Integrated Navigation Bar (Wordmark Left • Floating White Pill Center • Globe Pill Right)
            Padding(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 48 : 20,
                isDesktop ? 22 : 14,
                isDesktop ? 48 : 20,
                8,
              ),
              child: Row(
                children: [
                  // Brand Wordmark on Left
                  InkWell(
                    onTap: _replayBannerAnimation,
                    borderRadius: BorderRadius.circular(12),
                    child: const Text(
                      'Aviaj',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 36,
                        letterSpacing: -1.4,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Center Floating White Stadium Pill Navigation Bar
                  if (isDesktop)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _NavbarLink(
                            label: 'Date',
                            isHighlighted: _showDateMegaMenu,
                            onTap: () {
                              setState(() {
                                _showDateMegaMenu = !_showDateMegaMenu;
                                _showAffMegaMenu = false;
                                _showStoriesMegaMenu = false;
                              });
                            },
                          ),
                          _NavbarLink(
                            label: 'AFF',
                            isHighlighted: _showAffMegaMenu,
                            onTap: () {
                              setState(() {
                                _showAffMegaMenu = !_showAffMegaMenu;
                                _showDateMegaMenu = false;
                                _showStoriesMegaMenu = false;
                              });
                            },
                          ),
                          _NavbarLink(
                            label: _langPack.navStories,
                            isHighlighted: _showStoriesMegaMenu,
                            onTap: () {
                              setState(() {
                                _showStoriesMegaMenu = !_showStoriesMegaMenu;
                                _showDateMegaMenu = false;
                                _showAffMegaMenu = false;
                              });
                            },
                          ),
                          _NavbarLink(
                            label: _langPack.navSafety,
                            onTap: () {
                              setState(() {
                                _showDateMegaMenu = false;
                                _showAffMegaMenu = false;
                                _showStoriesMegaMenu = false;
                              });
                              _navigateToSeoPage(AviajSeoPage.safety);
                            },
                          ),
                          _NavbarLink(
                            label: _langPack.navSupport,
                            onTap: () {
                              setState(() {
                                _showDateMegaMenu = false;
                                _showAffMegaMenu = false;
                                _showStoriesMegaMenu = false;
                              });
                              _navigateToSeoPage(AviajSeoPage.support);
                            },
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  // Right Floating White Globe Pill
                  _buildRegionSelectorPill(
                    isDarkPill: false,
                    showFullLanguageLabel: false,
                  ),
                ],
              ),
            ),

            // Main Animated Stage + Overlaid Mega-Menu Dropdown + Floating Bottom-Right QR Card
            ClipRect(
              child: SizedBox(
                width: double.infinity,
                height: stageHeight,
                child: Stack(
                  children: [
                    // Blurred when Date / AFF / Stories Mega-Menu is open
                    Positioned.fill(
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                        enabled: isAnyMegaMenuOpen,
                        child: AnimatedBuilder(
                          animation: Listenable.merge([
                            _bannerIntroController,
                            _profileSliderController,
                          ]),
                          builder: (context, _) {
                            final giantFontSize = isDesktop
                                ? (screenWidth * 0.25).clamp(210.0, 355.0)
                                : (screenWidth * 0.26).clamp(92.0, 145.0);
                            const brandSegments = ['Av', 'i', 'aj'];

                            return Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.hardEdge,
                              children: [
                                // STEP 1: GIANT EDGE-TO-EDGE "Aviaj" WORDMARK ANIMATION
                                Positioned(
                                  left: isDesktop ? 36 : 12,
                                  right: isDesktop ? 36 : 12,
                                  bottom: isDesktop ? 62 : 70,
                                  child: IgnorePointer(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: List.generate(
                                        brandSegments.length,
                                        (index) {
                                          final start =
                                              (index * 0.11).clamp(0.0, 0.4);
                                          final end = (0.48 + index * 0.11)
                                              .clamp(0.0, 1.0);
                                          final rawT =
                                              ((_bannerIntroController.value -
                                                          start) /
                                                      (end - start))
                                                  .clamp(0.0, 1.0);
                                          final curvedT = Curves.easeOutBack
                                              .transform(rawT);
                                          final opacityT =
                                              Curves.easeOut.transform(rawT);

                                          return Transform.translate(
                                            offset: Offset(
                                                0, (1.0 - curvedT) * 145.0),
                                            child: Transform.scale(
                                              scale: 0.78 + (0.22 * curvedT),
                                              child: Opacity(
                                                opacity: opacityT,
                                                child: Text(
                                                  brandSegments[index],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: giantFontSize,
                                                    fontWeight: FontWeight.w900,
                                                    height: 0.88,
                                                    letterSpacing: -10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                // STEP 2 & 3: 3D ANGLED PERSPECTIVE PROFILES SLIDER
                                for (final slotIndex in [3, 2, 1, 0])
                                  _buildAnimatedPerspectiveProfileCard(
                                    context: context,
                                    profiles: profiles,
                                    slotIndex: slotIndex,
                                    cardScale: cardScale,
                                    stageWidth: screenWidth,
                                    stageHeight: stageHeight,
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    // Interactive "Explore Date ›" Mega-Menu Dropdown Card Overlaid on Blurred Stage
                    if (_showDateMegaMenu)
                      Positioned(
                        top: 8,
                        left: isDesktop ? 48 : 16,
                        right: isDesktop ? 48 : 16,
                        child: _buildExploreDateMegaMenuCard(
                          context,
                          isDesktop,
                        ),
                      ),

                    // Interactive "Explore AFF ›" Mega-Menu Dropdown Card Overlaid on Blurred Stage
                    if (_showAffMegaMenu)
                      Positioned(
                        top: 8,
                        left: isDesktop ? 48 : 16,
                        right: isDesktop ? 48 : 16,
                        child: _buildExploreAffMegaMenuCard(
                          context,
                          isDesktop,
                        ),
                      ),

                    // Interactive "Explore Stories ›" Mega-Menu Dropdown Card Overlaid on Blurred Stage
                    if (_showStoriesMegaMenu)
                      Positioned(
                        top: 8,
                        left: isDesktop ? 48 : 16,
                        right: isDesktop ? 48 : 16,
                        child: _buildExploreStoriesMegaMenuCard(
                          context,
                          isDesktop,
                        ),
                      ),

                    // Floating Bottom-Right "Get the Aviaj app" QR Badge (shown only when a dropdown is open)
                    if (isAnyMegaMenuOpen)
                      Positioned(
                        right: 0,
                        bottom: 22,
                      child: InkWell(
                        onTap: () => showMobileAppDownloadModal(context),
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(18),
                        ),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(14, 14, 24, 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD91837),
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(18),
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.28),
                              width: 1.1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.16),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: isDesktop ? 92 : 68,
                                height: isDesktop ? 92 : 68,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.qr_code_2_rounded,
                                      size: isDesktop ? 78 : 54,
                                      color: const Color(0xFF1E1E1E),
                                    ),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Icon(
                                        Icons.favorite_rounded,
                                        color: AviajTheme.loveRed,
                                        size: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                _langPack.getTheAviajApp,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isDesktop ? 24 : 17,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.6,
                                  height: 1.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single 3D perspective angled profile slab at [slotIndex] (0=Front, 1=Middle, 2=Back, 3=Incoming)
  /// and interpolates smoothly toward `slotIndex - 1` as `_profileSliderController` runs from 0 -> 1.
  Widget _buildAnimatedPerspectiveProfileCard({
    required BuildContext context,
    required List<TravellerProfile> profiles,
    required int slotIndex,
    required double cardScale,
    required double stageWidth,
    required double stageHeight,
  }) {
    final profile =
        profiles[(_selectedHeroIndex + slotIndex) % profiles.length];
    final firstName = profile.name.split(' ').first;

    // Entrance animation for Phase 2 ("THEN ANIMATE PROFILES SLIDER" after "Aviaj" name)
    final introStart = (0.42 + slotIndex * 0.08).clamp(0.0, 0.85);
    final introEnd = (0.86 + slotIndex * 0.045).clamp(0.0, 1.0);
    final rawIntro =
        ((_bannerIntroController.value - introStart) / (introEnd - introStart))
            .clamp(0.0, 1.0);
    final introCurve = Curves.easeOutCubic.transform(rawIntro);

    // Continuous slider transition t (0.0 -> 1.0 moves slotIndex -> slotIndex - 1)
    final slideT =
        Curves.easeInOutCubic.transform(_profileSliderController.value);

    // Define the 5 perspective slots: [-1: Outgoing, 0: Front, 1: Middle, 2: Back, 3: Incoming]
    ({
      double dx,
      double top,
      double width,
      double height,
      double slant,
      double opacity,
      double fontSize,
    }) metricsForSlot(int s) {
      switch (s) {
        case -1:
          return (
            dx: -360.0 * cardScale,
            top: 0.0 * cardScale,
            width: 315.0 * cardScale,
            height: 605.0 * cardScale,
            slant: 44.0 * cardScale,
            opacity: 0.0,
            fontSize: 22.0 * cardScale,
          );
        case 0:
          return (
            dx: -118.0 * cardScale,
            top: 12.0 * cardScale,
            width: 300.0 * cardScale,
            height: 598.0 * cardScale,
            slant: 42.0 * cardScale,
            opacity: 1.0,
            fontSize: 21.0 * cardScale,
          );
        case 1:
          return (
            dx: 76.0 * cardScale,
            top: 84.0 * cardScale,
            width: 192.0 * cardScale,
            height: 440.0 * cardScale,
            slant: 30.0 * cardScale,
            opacity: 1.0,
            fontSize: 15.5 * cardScale,
          );
        case 2:
          return (
            dx: 222.0 * cardScale,
            top: 150.0 * cardScale,
            width: 146.0 * cardScale,
            height: 320.0 * cardScale,
            slant: 22.0 * cardScale,
            opacity: 1.0,
            fontSize: 13.0 * cardScale,
          );
        default: // case 3 (Incoming from right)
          return (
            dx: 335.0 * cardScale,
            top: 205.0 * cardScale,
            width: 108.0 * cardScale,
            height: 225.0 * cardScale,
            slant: 16.0 * cardScale,
            opacity: 0.0,
            fontSize: 11.0 * cardScale,
          );
      }
    }

    final from = metricsForSlot(slotIndex);
    final to = metricsForSlot(slotIndex - 1);

    final targetDx = lerpDouble(from.dx, to.dx, slideT)!;
    final targetTop = lerpDouble(from.top, to.top, slideT)!;
    final width = lerpDouble(from.width, to.width, slideT)!;
    final height = lerpDouble(from.height, to.height, slideT)!;
    final slant = lerpDouble(from.slant, to.slant, slideT)!;
    final baseOpacity = lerpDouble(from.opacity, to.opacity, slideT)!;
    final fontSize = lerpDouble(from.fontSize, to.fontSize, slideT)!;

    // Fan-out from center during Phase 2 intro
    final currentDx = lerpDouble(0.0, targetDx, introCurve)!;
    final currentTop = targetTop + (1.0 - introCurve) * 110.0;
    final effectiveOpacity = (baseOpacity * introCurve).clamp(0.0, 1.0);

    if (effectiveOpacity <= 0.01) {
      return const SizedBox.shrink();
    }

    final centerLeft = (stageWidth / 2) + currentDx - (width / 2);

    return Positioned(
      left: centerLeft,
      top: currentTop,
      width: width,
      height: height,
      child: Opacity(
        opacity: effectiveOpacity,
        child: GestureDetector(
          onTap: _triggerNextProfileSlide,
          onHorizontalDragEnd: (_) => _triggerNextProfileSlide(),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ClipPath(
              clipper: _PerspectiveSlabClipper(
                slant: slant,
                radius: 22.0 * cardScale,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AviajNetworkImage(
                    imageUrl: profile.imageUrl,
                    width: width,
                    height: height,
                    fallbackLabel: profile.name,
                  ),
                  // Angled "Name, Age" + Regional Trek/Beach destination badge aligned to the 3D bottom perspective edge
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: slant * 0.56 + 12,
                    child: Transform.rotate(
                      angle: 0.19,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$firstName, ${profile.age}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: fontSize.clamp(11.0, 22.0),
                              letterSpacing: -0.3,
                              shadows: const [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 12,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.58),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.35),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              '📍 ${profile.nextDestination}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: (fontSize * 0.54).clamp(8.5, 11.5),
                                letterSpacing: -0.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// SECTION 2 (Screenshot 2): Mission Headline on Left + 3 Stepped Portrait Cards with Vertical Rotated Pill Badges on Right
  Widget _buildBelowBannerIntroStrip(BuildContext context, bool isDesktop) {
    final copyColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _langPack.heroMainHeadline,
          style: const TextStyle(
            color: AviajTheme.midnightNavy,
            fontSize: 54,
            fontWeight: FontWeight.w900,
            height: 1.04,
            letterSpacing: -1.6,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          _langPack.heroSubheadline,
          style: const TextStyle(
            color: Color(0xFF3E3035),
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilledButton(
              onPressed: () => showMobileAppDownloadModal(context),
              style: FilledButton.styleFrom(
                backgroundColor: AviajTheme.midnightNavy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: Text(
                _langPack.downloadAviajBtn,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),

          ],
        ),
        const SizedBox(height: 20),
        const AppStoreDownloadBadges(lightOnDark: false),
      ],
    );

    final pack = widget.state.regionalPack;
    final steppedCardsPane = SizedBox(
      width: isDesktop ? 550 : 350,
      height: isDesktop ? 450 : 340,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Back Card (Rightmost, smallest)
          Positioned(
            right: 0,
            top: isDesktop ? 76 : 54,
            width: isDesktop ? 195 : 130,
            height: isDesktop ? 295 : 210,
            child: _buildVerticalPillSteppedCard(
              imageUrl: pack.steppedCards[2].imageUrl,
              verticalTag: pack.steppedCards[2].tag,
              tagFontSize: isDesktop ? 14 : 11,
            ),
          ),
          // Middle Card (Center-right, medium)
          Positioned(
            left: isDesktop ? 196 : 118,
            top: isDesktop ? 40 : 28,
            width: isDesktop ? 235 : 155,
            height: isDesktop ? 365 : 260,
            child: _buildVerticalPillSteppedCard(
              imageUrl: pack.steppedCards[1].imageUrl,
              verticalTag: pack.steppedCards[1].tag,
              tagFontSize: isDesktop ? 17 : 13,
            ),
          ),
          // Front Card (Leftmost, largest)
          Positioned(
            left: 0,
            top: 0,
            width: isDesktop ? 305 : 205,
            height: isDesktop ? 440 : 320,
            child: _buildVerticalPillSteppedCard(
              imageUrl: pack.steppedCards[0].imageUrl,
              verticalTag: pack.steppedCards[0].tag,
              tagFontSize: isDesktop ? 22 : 16,
            ),
          ),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 24,
        vertical: isDesktop ? 88 : 52,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: copyColumn),
                    const SizedBox(width: 48),
                    Expanded(
                      flex: 6,
                      child: Center(child: steppedCardsPane),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    copyColumn,
                    const SizedBox(height: 36),
                    Center(child: steppedCardsPane),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildVerticalPillSteppedCard({
    required String imageUrl,
    required String verticalTag,
    required double tagFontSize,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AviajNetworkImage(
            imageUrl: imageUrl,
            width: double.infinity,
            height: double.infinity,
            fallbackLabel: verticalTag,
          ),
          Positioned(
            top: 16,
            right: 14,
            child: RotatedBox(
              quarterTurns: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AviajTheme.loveRed,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  verticalTag,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: tagFontSize,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SECTION 2B: Regional Famous Hiking, Trekking & Beach Destinations Grid
  /// Showcases iconic treks (e.g. Manali & Hampta Pass, Uttarakhand Kedarkantha & Valley of Flowers)
  /// and beaches (e.g. Goa Palolem & Vagator, Andaman Havelock & Radhanagar Beach) for the active region.
  Widget _buildRegionalTreksAndBeachesSection(
    BuildContext context,
    bool isDesktop,
  ) {
    final pack = widget.state.regionalPack;
    final region = pack.region;
    final destinations = pack.featuredDestinations;

    const westernGhatsTreks = [
      (
        title: 'Kudremukh Trek (Karnataka)',
        subtitle:
            'Karnataka • Rolling Shola Grasslands, Chikmagalur Misty Peaks & Waterfall Trails',
        categoryBadge: '🌿 WESTERN GHATS TREK',
        imageUrl:
            'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=900&q=80',
      ),
      (
        title:
            'Sahyadri Fort Treks (Maharashtra — e.g., Kalsubai, Harishchandragad, Ratangad)',
        subtitle:
            'Maharashtra • Kalsubai Highest Peak, Harishchandragad Konkan Kada & Ratangad Fort Cloud Trails',
        categoryBadge: '🏰 SAHYADRI FORT TREKS',
        imageUrl:
            'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=900&q=80',
      ),
    ];

    const soloGroupIndiaDestinations = [
      (
        title: 'Rishikesh (Uttarakhand)',
        subtitle:
            'Uttarakhand • White-Water River Rafting, Bungee Jumping, Tapovan Hostels & Ganga Aarti',
        categoryBadge: '🌊 SOLO GROUP HUB',
        imageUrl:
            'https://images.unsplash.com/photo-1589802829985-817e51171b92?auto=format&fit=crop&w=900&q=80',
      ),
      (
        title: 'Kasol & Parvati Valley (Himachal Pradesh)',
        subtitle:
            'Himachal Pradesh • Chalal River Walk, Tosh Village, Mountain Cafés & Bonfire Acoustic Nights',
        categoryBadge: '🎸 PARVATI VALLEY',
        imageUrl:
            'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?auto=format&fit=crop&w=900&q=80',
      ),
      (
        title: 'Bir Billing (Himachal Pradesh)',
        subtitle:
            'Himachal Pradesh • World-Famous Tandem Paragliding, Tibetan Monasteries & Sunset Landing Zone',
        categoryBadge: '🪂 PARAGLIDING CAPITAL',
        imageUrl:
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=900&q=80',
      ),
      (
        title: 'Jaipur (Rajasthan)',
        subtitle:
            'Rajasthan • Amber Fort, Nahargarh Sunset Point, Heritage Havelis & Rooftop Folk Nights',
        categoryBadge: '👑 HERITAGE & CULTURE',
        imageUrl:
            'https://images.unsplash.com/photo-1477587458883-47145ed94245?auto=format&fit=crop&w=900&q=80',
      ),
      (
        title: 'Goa',
        subtitle:
            'North & South Goa • Anjuna, Vagator, Assagao Villa Crews, Surf Mornings & Beach Sundowners',
        categoryBadge: '🌴 COASTAL VILLA CREWS',
        imageUrl:
            'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=900&q=80',
      ),
      (
        title: 'Leh-Ladakh',
        subtitle:
            'Ladakh • Pangong Tso, Nubra Valley Sand Dunes, Khardung La Pass & Hanle Stargazing Roadtrips',
        categoryBadge: '🏍️ HIGH-PASS EXPEDITION',
        imageUrl:
            'https://images.unsplash.com/photo-1544735716-392fe2489ffa?auto=format&fit=crop&w=900&q=80',
      ),
      (
        title: 'Kerala (Munnar, Varkala, Kochi)',
        subtitle:
            'Kerala • Munnar Misty Tea Estates, Varkala Cliff Surf Cafés, Fort Kochi & Alleppey Backwaters',
        categoryBadge: '🛶 BACKWATERS & CLIFFS',
        imageUrl:
            'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=900&q=80',
      ),
    ];

    Widget buildGridOfCards(
      List<
              ({
                String title,
                String subtitle,
                String categoryBadge,
                String imageUrl,
              })>
          items, {
      int desktopCols = 4,
    }) {
      if (!isDesktop) {
        return Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(height: 18),
              _buildRegionalDestinationCard(context, items[i]),
            ],
          ],
        );
      }

      final rows = <Widget>[];
      for (int start = 0; start < items.length; start += desktopCols) {
        final end = (start + desktopCols < items.length)
            ? start + desktopCols
            : items.length;
        final chunk = items.sublist(start, end);
        if (rows.isNotEmpty) {
          rows.add(const SizedBox(height: 22));
        }
        rows.add(
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < chunk.length; i++) ...[
                  if (i > 0) const SizedBox(width: 20),
                  Expanded(
                    child: _buildRegionalDestinationCard(context, chunk[i]),
                  ),
                ],
                for (int pad = chunk.length; pad < desktopCols; pad++) ...[
                  const SizedBox(width: 20),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ],
            ),
          ),
        );
      }
      return Column(children: rows);
    }

    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF5F6),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 20,
        vertical: isDesktop ? 72 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AviajTheme.loveRed,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      '${region.flag} ${region.label.toUpperCase()} HIKING, TREKS & BEACHES',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AviajTheme.loveRed.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      '📍 ${region.sampleDestinations}',
                      style: const TextStyle(
                        color: AviajTheme.midnightNavy,
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                region == AviajRegion.india
                    ? 'Famous Indian Treks, Circuit Trips & Solo Group Destinations'
                    : 'Famous ${region.label} Hiking Treks & Iconic Beach Escapes',
                style: TextStyle(
                  color: AviajTheme.midnightNavy,
                  fontSize: isDesktop ? 42 : 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.3,
                  height: 1.08,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                region == AviajRegion.india
                    ? 'Match with verified hikers, trekkers, and solo group travellers heading to Chopta–Tungnath–Chandrashila–Deoriatal, Kasol–Kheerganga, Triund, Kedarkantha, Spiti Valley, Western Ghats & Sahyadri Forts, Rishikesh, Bir Billing, Jaipur, Goa, Leh-Ladakh & Kerala.'
                    : 'Match with verified hikers, trekkers, and island hoppers heading to ${region.sampleDestinations} on your exact travel dates.',
                style: const TextStyle(
                  color: Color(0xFF4A353B),
                  fontSize: 16.5,
                  fontWeight: FontWeight.w500,
                  height: 1.48,
                ),
              ),
              const SizedBox(height: 32),
              buildGridOfCards(destinations, desktopCols: 4),
              if (region == AviajRegion.india) ...[
                const SizedBox(height: 48),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AviajTheme.loveRed.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    '🌿 WESTERN GHATS & SOUTHERN TREKS',
                    style: TextStyle(
                      color: AviajTheme.loveRed,
                      fontWeight: FontWeight.w900,
                      fontSize: 11.5,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Western Ghats & Southern Treks',
                  style: TextStyle(
                    color: AviajTheme.midnightNavy,
                    fontSize: isDesktop ? 32 : 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.9,
                  ),
                ),
                const SizedBox(height: 20),
                buildGridOfCards(westernGhatsTreks, desktopCols: 2),
                const SizedBox(height: 48),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AviajTheme.loveRed.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    '🎒 SOLO & GROUP SQUAD HUBS',
                    style: TextStyle(
                      color: AviajTheme.loveRed,
                      fontWeight: FontWeight.w900,
                      fontSize: 11.5,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Top Solo Group Travel Destinations in India',
                  style: TextStyle(
                    color: AviajTheme.midnightNavy,
                    fontSize: isDesktop ? 32 : 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.9,
                  ),
                ),
                const SizedBox(height: 20),
                buildGridOfCards(soloGroupIndiaDestinations, desktopCols: 4),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegionalDestinationCard(
    BuildContext context,
    ({
      String title,
      String subtitle,
      String categoryBadge,
      String imageUrl,
    }) dest,
  ) {
    return InkWell(
      onTap: () => showMobileAppDownloadModal(context),
      borderRadius: BorderRadius.circular(26),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: AviajTheme.loveRed.withValues(alpha: 0.16),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AviajTheme.loveRed.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
              child: SizedBox(
                height: 220,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AviajNetworkImage(
                      imageUrl: dest.imageUrl,
                      width: double.infinity,
                      height: 220,
                      fallbackLabel: dest.title,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.15),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.65),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AviajTheme.loveRed,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          dest.categoryBadge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 14,
                      right: 14,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.people_alt_rounded,
                                  size: 13,
                                  color: AviajTheme.loveRed,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Date • Co-Pilot • AFF Crews',
                                  style: TextStyle(
                                    color: AviajTheme.midnightNavy,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dest.title,
                    style: const TextStyle(
                      color: AviajTheme.midnightNavy,
                      fontWeight: FontWeight.w900,
                      fontSize: 19,
                      letterSpacing: -0.4,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dest.subtitle,
                    style: const TextStyle(
                      color: Color(0xFF5A4348),
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Text(
                        'Join Departure Circle',
                        style: TextStyle(
                          color: AviajTheme.loveRed,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 15,
                        color: AviajTheme.loveRed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SECTION 3 (Screenshot 3): Large Rounded Photo + Circular Stamp Badge at Bottom-Left + "Share your next itinerary"
  Widget _buildDepartureCircleSection(BuildContext context, bool isDesktop) {
    final pack = widget.state.regionalPack;
    final photoWithStamp = ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: isDesktop ? 485 : 340,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AviajNetworkImage(
              imageUrl: pack.departureCirclePhotoUrl,
              width: double.infinity,
              height: double.infinity,
              fallbackLabel: 'Departure Lounge Circle',
            ),
            // Circular Member/Departure Lounge Stamp Emblem at Bottom-Left
            Positioned(
              left: 24,
              bottom: 24,
              child: Container(
                width: isDesktop ? 152 : 120,
                height: isDesktop ? 152 : 120,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AviajTheme.loveRed,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AviajTheme.midnightNavy,
                    width: 3,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'DEPARTURE CIRCLE',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 8.5,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: isDesktop ? 56 : 42,
                              height: isDesktop ? 56 : 42,
                              decoration: const BoxDecoration(
                                color: AviajTheme.midnightNavy,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.flight_takeoff_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              '• AVIAJ CLUB •',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 8.5,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final rightCopy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share your next itinerary',
          style: TextStyle(
            color: AviajTheme.midnightNavy,
            fontSize: 52,
            fontWeight: FontWeight.w900,
            height: 1.06,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Help shape your next adventure by joining the Aviaj Departure Circle. This verified community of solo travellers shares live flight routes, destination pins, and first-night plans directly before boarding.',
          style: TextStyle(
            color: Color(0xFF3E3035),
            fontSize: 17.5,
            fontWeight: FontWeight.w500,
            height: 1.48,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Members get early access to Destination Radar™ matches, sneak peeks at curated 6-person villa crews in ${pack.region.sampleDestinations}, and Boarding Date Invites.',
          style: const TextStyle(
            color: Color(0xFF3E3035),
            fontSize: 17.5,
            fontWeight: FontWeight.w500,
            height: 1.48,
          ),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: () => showMobileAppDownloadModal(context),
          style: FilledButton.styleFrom(
            backgroundColor: AviajTheme.midnightNavy,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 34,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: const Text(
            'Sign up',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 24,
        vertical: isDesktop ? 72 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 6, child: photoWithStamp),
                    const SizedBox(width: 64),
                    Expanded(flex: 5, child: rightCopy),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    photoWithStamp,
                    const SizedBox(height: 32),
                    rightCopy,
                  ],
                ),
        ),
      ),
    );
  }

  /// SECTION 4 (Screenshot 4): Two Side-by-Side Solid Red Love Showcase Cards (`Aviaj Romance` & `Aviaj Co-Pilot`)
  /// with White Inner Stage & Phone Mockups
  Widget _buildThreeModesPillarSection(BuildContext context, bool isDesktop) {
    final pack = widget.state.regionalPack;
    final romanceCard = Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AviajTheme.loveRed,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // White Inner Stage with Row of Verified Portraits + Center iPhone Mockup
          Container(
            height: 295,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background row of 4 verified traveller portraits
                Positioned(
                  left: -10,
                  right: -10,
                  top: 48,
                  height: 195,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMiniVerifiedPortrait(
                        pack.romanceVerifiedPortraitUrls[0],
                      ),
                      _buildMiniVerifiedPortrait(
                        pack.romanceVerifiedPortraitUrls[1],
                      ),
                      const SizedBox(width: 140),
                      _buildMiniVerifiedPortrait(
                        pack.romanceVerifiedPortraitUrls[2],
                      ),
                      _buildMiniVerifiedPortrait(
                        pack.romanceVerifiedPortraitUrls[3],
                      ),
                    ],
                  ),
                ),
                // Center iPhone Mockup rising from bottom
                Positioned(
                  top: 22,
                  bottom: -16,
                  width: 175,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: AviajTheme.midnightNavy,
                        width: 2.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Aviaj',
                              style: TextStyle(
                                color: AviajTheme.midnightNavy,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                            Icon(
                              Icons.tune_rounded,
                              size: 14,
                              color: Colors.grey.shade700,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                AviajNetworkImage(
                                  imageUrl: pack.romancePhoneImageUrl,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fallbackLabel: pack.romancePhoneLabel,
                                ),
                                Positioned(
                                  left: 10,
                                  bottom: 20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pack.romancePhoneLabel,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AviajTheme.loveRed,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          '✓ ID verified',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Aviaj Date',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.9,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _langPack.exploreDateDesc,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.5,
              fontWeight: FontWeight.w500,
              height: 1.44,
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => _navigateToSeoPage(AviajSeoPage.date),
            child: Text(
              _langPack.exploreDateTitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15.5,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    final coPilotCard = Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AviajTheme.loveRed,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // White Inner Stage with Tilted Crew Card + Floating Pills on Left & Phone Mockup on Right
          Container(
            height: 295,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                // Tilted Crew Photo + Floating Pills on Left
                Positioned(
                  left: 34,
                  top: 32,
                  width: 175,
                  height: 225,
                  child: Transform.rotate(
                    angle: -0.05,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: AviajNetworkImage(
                        imageUrl: pack.coPilotCrewImageUrl,
                        width: 175,
                        height: 225,
                        fallbackLabel: 'Island Crew',
                      ),
                    ),
                  ),
                ),
                // Floating Pill Tags ("Villa crew", "Route chat", "Departures")
                Positioned(
                  left: 16,
                  top: 118,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AviajTheme.warmSand,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Villa crew',
                          style: TextStyle(
                            color: AviajTheme.loveRed,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          '● Route chat',
                          style: TextStyle(
                            color: AviajTheme.midnightNavy,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          '🗓️ Departures',
                          style: TextStyle(
                            color: AviajTheme.midnightNavy,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Emblem Badge at Bottom-Center of Crew Card
                Positioned(
                  left: 158,
                  bottom: 34,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AviajTheme.loveRed,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.groups_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                // Right iPhone Mockup
                Positioned(
                  right: 26,
                  top: 22,
                  bottom: -16,
                  width: 170,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: AviajTheme.midnightNavy,
                        width: 2.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          pack.region.coPilotLocationHeader,
                          style: const TextStyle(
                            color: AviajTheme.midnightNavy,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                AviajNetworkImage(
                                  imageUrl: pack.coPilotPhoneImageUrl,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fallbackLabel: pack.coPilotPhoneLabel,
                                ),
                                Positioned(
                                  left: 10,
                                  top: 12,
                                  child: Text(
                                    pack.coPilotPhoneLabel,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 22,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: AviajTheme.loveRed,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.waving_hand_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 6,
            children: [
              const Text(
                'AFF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.9,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'AVIAJ FRIENDS FOREVER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _langPack.exploreAffDesc,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.5,
              fontWeight: FontWeight.w500,
              height: 1.44,
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => _navigateToSeoPage(AviajSeoPage.aff),
            child: Text(
              _langPack.exploreAffTitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15.5,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 24,
        vertical: isDesktop ? 64 : 44,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: romanceCard),
                    const SizedBox(width: 28),
                    Expanded(child: coPilotCard),
                  ],
                )
              : Column(
                  children: [
                    romanceCard,
                    const SizedBox(height: 24),
                    coPilotCard,
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildMiniVerifiedPortrait(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 84,
        height: 185,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AviajNetworkImage(
              imageUrl: imageUrl,
              width: 84,
              height: 185,
              fallbackLabel: 'Verified',
            ),
            Positioned(
              left: 6,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AviajTheme.loveRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '✓ ID verified',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Interactive "Explore Date ›" Mega-Menu Card (`Compliments ›`, `Incognito Mode ›`, `Video Calls ›`, `Travel mode ›`, `Snooze mode ›`, `SuperSwipe ›`)
  Widget _buildExploreDateMegaMenuCard(BuildContext context, bool isDesktop) {
    Widget buildFeatureItem(
      String title,
      String subtitle,
      AviajSeoPage targetPage,
    ) {
      return InkWell(
        onTap: () => _navigateToSeoPage(targetPage),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title ›',
                style: const TextStyle(
                  color: AviajTheme.midnightNavy,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF4A3B40),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 16,
            top: 14,
            child: IconButton(
              onPressed: () => setState(() => _showDateMegaMenu = false),
              icon: const Icon(
                Icons.close_rounded,
                color: AviajTheme.midnightNavy,
                size: 24,
              ),
              tooltip: 'Close Date menu',
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              isDesktop ? 56 : 24,
              isDesktop ? 52 : 28,
              isDesktop ? 76 : 36,
              isDesktop ? 52 : 28,
            ),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: InkWell(
                          onTap: () => _navigateToSeoPage(AviajSeoPage.date),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _langPack.exploreDateTitle,
                                style: const TextStyle(
                                  color: AviajTheme.midnightNavy,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.9,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: 370,
                                child: Text(
                                  _langPack.exploreDateDesc,
                                  style: const TextStyle(
                                    color: Color(0xFF3E3034),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildFeatureItem(
                                'Compliments',
                                _langPack.complimentsDesc,
                                AviajSeoPage.dateCompliments,
                              ),
                              const SizedBox(height: 18),
                              buildFeatureItem(
                                'Video Calls',
                                _langPack.videoCallsDesc,
                                AviajSeoPage.dateVideoCalls,
                              ),
                              const SizedBox(height: 18),
                              buildFeatureItem(
                                'Snooze mode',
                                _langPack.snoozeModeDesc,
                                AviajSeoPage.dateSnoozeMode,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 36),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildFeatureItem(
                                'Incognito Mode',
                                _langPack.incognitoDesc,
                                AviajSeoPage.dateIncognito,
                              ),
                              const SizedBox(height: 18),
                              buildFeatureItem(
                                'Travel mode',
                                _langPack.travelModeDesc,
                                AviajSeoPage.dateTravelMode,
                              ),
                              const SizedBox(height: 18),
                              buildFeatureItem(
                                'SuperSwipe',
                                _langPack.superSwipeDesc,
                                AviajSeoPage.dateSuperSwipe,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => _navigateToSeoPage(AviajSeoPage.date),
                        child: Text(
                          _langPack.exploreDateTitle,
                          style: const TextStyle(
                            color: AviajTheme.midnightNavy,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _langPack.exploreDateDesc,
                        style: const TextStyle(
                          color: Color(0xFF3E3034),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// SECTION 4A: Complete "Explore Date" Showcase:
  /// 1. Full-Bleed Couple Hero ("FEATURES DESIGNED TO MAKE ONLINE DATING ACTUALLY, YOU KNOW, ENJOYABLE")
  /// 2. "DATE THE WAY YOU WANT TO" 6-Card Illustrated Grid (Go undercover, Make them blush, Sound it out, Take a break, Get their attention, Take us away)
  /// 3. "ALL THE DATING NEWS THAT’S FIT TO PRINT" 3-Card Editorial News Grid
  Widget _buildExploreDateFullSection(BuildContext context, bool isDesktop) {
    final pack = widget.state.regionalPack;
    return Column(
      children: [
        // 1. Full-Bleed Atmospheric Couple Hero Banner
        SizedBox(
          width: double.infinity,
          height: isDesktop ? 560 : 440,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AviajNetworkImage(
                imageUrl: pack.storyCoupleImageUrl,
                width: double.infinity,
                height: double.infinity,
                fallbackLabel: 'Aviaj Date Hero',
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.55),
                      Colors.black.withValues(alpha: 0.68),
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1080),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'FEATURES DESIGNED TO MAKE ONLINE\nDATING ACTUALLY, YOU KNOW, ENJOYABLE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFFF4B5C),
                            fontSize: isDesktop ? 62 : 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.8,
                            height: 1.04,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'It’s better on the app.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 22),
                        ElevatedButton(
                          onPressed: () => showMobileAppDownloadModal(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AviajTheme.midnightNavy,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: const Text(
                            'Download now',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 2. "DATE THE WAY YOU WANT TO" 6-Card Illustrated Grid + "ALL THE DATING NEWS THAT’S FIT TO PRINT"
        Container(
          width: double.infinity,
          color: AviajTheme.loveRed,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 56 : 20,
            vertical: isDesktop ? 76 : 48,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DATE THE WAY YOU WANT TO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 54 : 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.6,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 36),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cols = constraints.maxWidth >= 960
                          ? 3
                          : (constraints.maxWidth >= 620 ? 2 : 1);
                      final spacing = 24.0;
                      final cardWidth =
                          (constraints.maxWidth - spacing * (cols - 1)) / cols;

                      final features = <({
                        String title,
                        bool underlined,
                        String preText,
                        String boldFeature,
                        String postText,
                        String illustrationType,
                        AviajSeoPage seoPage,
                      })>[
                        (
                          title: 'Go undercover',
                          underlined: false,
                          preText: 'Use ',
                          boldFeature: 'Incognito Mode',
                          postText:
                              ' to hide your profile from your boss, relatives, or exes.',
                          illustrationType: 'incognito',
                          seoPage: AviajSeoPage.dateIncognito,
                        ),
                        (
                          title: 'Make them blush',
                          underlined: false,
                          preText: 'Throw some ',
                          boldFeature: 'Compliments',
                          postText:
                              ' their way so you stand out from the crowd.',
                          illustrationType: 'compliments',
                          seoPage: AviajSeoPage.dateCompliments,
                        ),
                        (
                          title: 'Sound it out',
                          underlined: true,
                          preText: 'Use ',
                          boldFeature: 'video calls and audio chats',
                          postText:
                              ' to get as close to IRL without leaving your house.',
                          illustrationType: 'videocall',
                          seoPage: AviajSeoPage.dateVideoCalls,
                        ),
                        (
                          title: 'Take a break',
                          underlined: false,
                          preText: 'Put dating on hold with ',
                          boldFeature: 'Snooze Mode',
                          postText:
                              '. When you’re ready to date again, you know where we are.',
                          illustrationType: 'snooze',
                          seoPage: AviajSeoPage.dateSnoozeMode,
                        ),
                        (
                          title: 'Get their attention',
                          underlined: false,
                          preText:
                              'Profile passed the vibe check? Let them know with a ',
                          boldFeature: 'SuperSwipe',
                          postText: '.',
                          illustrationType: 'superswipe',
                          seoPage: AviajSeoPage.dateSuperSwipe,
                        ),
                        (
                          title: 'Take us away',
                          underlined: true,
                          preText:
                              'Find your duty-free snack and match anywhere in the world with ',
                          boldFeature: 'Travel Mode',
                          postText: '.',
                          illustrationType: 'travelmode',
                          seoPage: AviajSeoPage.dateTravelMode,
                        ),
                      ];

                      return Wrap(
                        spacing: spacing,
                        runSpacing: 38,
                        children: features.map((f) {
                          return SizedBox(
                            width: cardWidth,
                            child: InkWell(
                              onTap: () => _navigateToSeoPage(f.seoPage),
                              borderRadius: BorderRadius.circular(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 224,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Center(
                                      child: _buildDateFeatureIllustration(
                                        f.illustrationType,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    f.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.6,
                                      decoration: f.underlined
                                          ? TextDecoration.underline
                                          : TextDecoration.none,
                                      decorationColor: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.92),
                                        fontSize: 15,
                                        height: 1.45,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      children: [
                                        TextSpan(text: f.preText),
                                        TextSpan(
                                          text: f.boldFeature,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(text: f.postText),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 86),

                  // 3. "ALL THE DATING NEWS THAT’S FIT TO PRINT" 3-Card Editorial News Grid
                  Text(
                    'ALL THE DATING NEWS\nTHAT’S FIT TO PRINT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 54 : 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.6,
                      height: 1.04,
                    ),
                  ),
                  const SizedBox(height: 36),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cols = constraints.maxWidth >= 960
                          ? 3
                          : (constraints.maxWidth >= 620 ? 2 : 1);
                      final spacing = 24.0;
                      final cardWidth =
                          (constraints.maxWidth - spacing * (cols - 1)) / cols;

                      return Wrap(
                        spacing: spacing,
                        runSpacing: 24,
                        children: [
                          // Editorial News Card 1
                          SizedBox(
                            width: cardWidth,
                            child: _buildEditorialNewsCard(
                              context: context,
                              topWidget: AviajNetworkImage(
                                imageUrl: pack.storyCoupleImageUrl,
                                width: double.infinity,
                                height: 240,
                                fallbackLabel: 'Emotional Intimacy',
                              ),
                              title:
                                  'How to increase your emotional intimacy in your relationship',
                              subtitle: 'Aviaj Editorial • Relationship Guide',
                              underlined: false,
                            ),
                          ),
                          // Editorial News Card 2: Deception Detector™
                          SizedBox(
                            width: cardWidth,
                            child: _buildEditorialNewsCard(
                              context: context,
                              topWidget: Container(
                                height: 240,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFFD54F),
                                      Color(0xFFFFB300),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 18,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFF8E1),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                            color: const Color(0xFF1E1E1E),
                                            width: 1.8,
                                          ),
                                        ),
                                        child: const Text(
                                          'Deception\nDetector™',
                                          style: TextStyle(
                                            color: Color(0xFF1E1E1E),
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                            height: 1.1,
                                            letterSpacing: -0.6,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -16,
                                        left: -18,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFE082),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: const Color(0xFF1E1E1E),
                                              width: 1.4,
                                            ),
                                          ),
                                          child: const Text(
                                            'Introducing...',
                                            style: TextStyle(
                                              color: Color(0xFF1E1E1E),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: -14,
                                        right: -12,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF8E1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: const Color(0xFF1E1E1E),
                                              width: 1.4,
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '👀',
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(
                                                Icons.search_rounded,
                                                size: 16,
                                                color: Color(0xFF1E1E1E),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              title: 'Deception Detector™',
                              subtitle: 'February 5, 2024',
                              underlined: false,
                            ),
                          ),
                          // Editorial News Card 3
                          SizedBox(
                            width: cardWidth,
                            child: _buildEditorialNewsCard(
                              context: context,
                              topWidget: AviajNetworkImage(
                                imageUrl: pack.romancePhoneImageUrl,
                                width: double.infinity,
                                height: 240,
                                fallbackLabel: 'First-Time Aviaj Guide',
                              ),
                              title:
                                  'How to use Aviaj when you have never used a dating app before',
                              subtitle: 'Aviaj Editorial • First-Timer Guide',
                              underlined: true,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateFeatureIllustration(String type) {
    switch (type) {
      case 'incognito':
        // Stylized dark incognito mask with eye cutouts
        return Container(
          width: 170,
          height: 112,
          decoration: BoxDecoration(
            color: const Color(0xFF2B2B2B),
            borderRadius: BorderRadius.circular(64),
            border: Border.all(color: const Color(0xFF1E1E1E), width: 3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 36,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2B2B2B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Container(
                width: 36,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2B2B2B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );
      case 'compliments':
        // Stylized golden-amber envelope with heart seal + note card
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Transform.rotate(
              angle: 0.08,
              child: Container(
                width: 110,
                height: 120,
                margin: const EdgeInsets.only(left: 54),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF2B2B2B),
                    width: 2.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 3,
                      width: 60,
                      color: const Color(0xFF2B2B2B),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 3,
                      width: 72,
                      color: const Color(0xFF2B2B2B),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 3,
                      width: 48,
                      color: const Color(0xFF2B2B2B),
                    ),
                  ],
                ),
              ),
            ),
            Transform.rotate(
              angle: -0.1,
              child: Container(
                width: 132,
                height: 92,
                margin: const EdgeInsets.only(right: 32, top: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC13B),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF2B2B2B),
                    width: 2.2,
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFF2B2B2B),
                  size: 28,
                ),
              ),
            ),
          ],
        );
      case 'videocall':
        // Smartphone frame with golden video screen
        return Container(
          width: 86,
          height: 152,
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 22),
          decoration: BoxDecoration(
            color: const Color(0xFF2B2B2B),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFC13B),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.videocam_rounded,
              color: Color(0xFF2B2B2B),
              size: 34,
            ),
          ),
        );
      case 'snooze':
        // Wall toggle switch in warm amber square
        return Container(
          width: 138,
          height: 138,
          decoration: BoxDecoration(
            color: const Color(0xFFFFCC5C),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 58,
            height: 92,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF2B2B2B), width: 2.5),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 22,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                border: Border.all(color: const Color(0xFF2B2B2B), width: 2.2),
              ),
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 16,
                width: double.infinity,
                color: const Color(0xFF2B2B2B),
              ),
            ),
          ),
        );
      case 'superswipe':
        // Golden SuperSwipe star + slingshot frame
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star_rounded,
              size: 72,
              color: Color(0xFFFFB81C),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2B2B2B), width: 2.4),
              ),
              child: const Text(
                'SUPER\nSWIPE ★',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF2B2B2B),
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  height: 1.15,
                ),
              ),
            ),
          ],
        );
      case 'travelmode':
      default:
        // Vintage travel suitcase with golden luggage tag
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: 138,
              height: 102,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2B2B2B), width: 3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(width: 3, height: 102, color: const Color(0xFF2B2B2B)),
                  const Icon(
                    Icons.flight_takeoff_rounded,
                    color: Color(0xFF2B2B2B),
                    size: 34,
                  ),
                  Container(width: 3, height: 102, color: const Color(0xFF2B2B2B)),
                ],
              ),
            ),
            Positioned(
              top: -14,
              child: Container(
                width: 44,
                height: 16,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2B2B2B), width: 3),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
              ),
            ),
            Positioned(
              left: -18,
              top: 14,
              child: Transform.rotate(
                angle: -0.25,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB81C),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFF2B2B2B),
                      width: 2,
                    ),
                  ),
                  child: const Text(
                    'AVIAJ ✈',
                    style: TextStyle(
                      color: Color(0xFF2B2B2B),
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildEditorialNewsCard({
    required BuildContext context,
    required Widget topWidget,
    required String title,
    required String subtitle,
    required bool underlined,
  }) {
    return InkWell(
      onTap: () => showMobileAppDownloadModal(context),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        constraints: const BoxConstraints(minHeight: 455),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 240,
              width: double.infinity,
              child: topWidget,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 26, 26, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF1E1E1E),
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.6,
                      height: 1.22,
                      decoration: underlined
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF5C4B51),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Interactive "Explore AFF (Aviaj Friends Forever) ›" Mega-Menu Card
  Widget _buildExploreAffMegaMenuCard(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 56 : 24,
        isDesktop ? 48 : 24,
        isDesktop ? 56 : 24,
        isDesktop ? 48 : 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () => setState(() => _showAffMegaMenu = false),
              icon: const Icon(
                Icons.close_rounded,
                color: AviajTheme.midnightNavy,
                size: 24,
              ),
              tooltip: 'Close AFF menu',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 36),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: InkWell(
                          onTap: () => _navigateToSeoPage(AviajSeoPage.aff),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _langPack.exploreAffTitle,
                                style: const TextStyle(
                                  color: AviajTheme.midnightNavy,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.8,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _langPack.exploreAffDesc,
                                style: const TextStyle(
                                  color: Color(0xFF3E3034),
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () =>
                              _navigateToSeoPage(AviajSeoPage.affDeparturePlans),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: AviajTheme.midnightNavy,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Plans ›',
                                    style: TextStyle(
                                      color: AviajTheme.midnightNavy,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _langPack.affPlansDesc,
                                style: const TextStyle(
                                  color: Color(0xFF4A3B40),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () => _navigateToSeoPage(
                            AviajSeoPage.affCommunityLeaders,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.favorite_border_rounded,
                                    size: 17,
                                    color: AviajTheme.loveRed,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Community Leaders ›',
                                    style: TextStyle(
                                      color: AviajTheme.midnightNavy,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _langPack.affLeadersDesc,
                                style: const TextStyle(
                                  color: Color(0xFF4A3B40),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => _navigateToSeoPage(AviajSeoPage.aff),
                        child: Text(
                          _langPack.exploreAffTitle,
                          style: const TextStyle(
                            color: AviajTheme.midnightNavy,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _langPack.exploreAffDesc,
                        style: const TextStyle(
                          color: Color(0xFF3E3034),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// Interactive "Explore Stories ›" Mega-Menu Card
  Widget _buildExploreStoriesMegaMenuCard(
    BuildContext context,
    bool isDesktop,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 56 : 24,
        isDesktop ? 48 : 24,
        isDesktop ? 56 : 24,
        isDesktop ? 48 : 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () => setState(() => _showStoriesMegaMenu = false),
              icon: const Icon(
                Icons.close_rounded,
                color: AviajTheme.midnightNavy,
                size: 24,
              ),
              tooltip: 'Close Stories menu',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 36),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: InkWell(
                          onTap: () => _navigateToSeoPage(AviajSeoPage.stories),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _langPack.exploreStoriesTitle,
                                style: const TextStyle(
                                  color: AviajTheme.midnightNavy,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.8,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _langPack.exploreStoriesDesc,
                                style: const TextStyle(
                                  color: Color(0xFF3E3034),
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () =>
                                  _navigateToSeoPage(AviajSeoPage.stories),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Love Stories ›',
                                    style: TextStyle(
                                      color: AviajTheme.midnightNavy,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _langPack.loveStoriesDesc,
                                    style: const TextStyle(
                                      color: Color(0xFF4A3B40),
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 22),
                            InkWell(
                              onTap: () => _navigateToSeoPage(
                                AviajSeoPage.friendshipHub,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'The Friendship Hub ›',
                                    style: TextStyle(
                                      color: AviajTheme.midnightNavy,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _langPack.friendshipHubDesc,
                                    style: const TextStyle(
                                      color: Color(0xFF4A3B40),
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () =>
                              _navigateToSeoPage(AviajSeoPage.seasonalGuides),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              const Text(
                                'Seasonal Dating Guides ›',
                                style: TextStyle(
                                  color: AviajTheme.midnightNavy,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _langPack.seasonalGuidesDesc,
                                style: const TextStyle(
                                  color: Color(0xFF4A3B40),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() => _showStoriesMegaMenu = false);
                          _scrollToSection(_storiesKey);
                        },
                        child: const Text(
                          'Explore Stories ›',
                          style: TextStyle(
                            color: AviajTheme.midnightNavy,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'All the guidance and inspiration you need to help you find love and friendship.',
                        style: TextStyle(
                          color: Color(0xFF3E3034),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// SECTION 4B: Full-Bleed "AFF — Aviaj Friends Forever" Dedicated Lifestyle Hero Section
  Widget _buildAffFriendsForeverSection(BuildContext context, bool isDesktop) {
    final pack = widget.state.regionalPack;
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : 16,
        vertical: isDesktop ? 24 : 16,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1340),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: SizedBox(
              height: isDesktop ? 610 : 520,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AviajNetworkImage(
                    imageUrl: pack.coPilotCrewImageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fallbackLabel: 'AFF — Aviaj Friends Forever',
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.28),
                          Colors.black.withValues(alpha: 0.56),
                          Colors.black.withValues(alpha: 0.72),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Flower/Heart Emblem + Giant "AFF" Wordmark
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: isDesktop ? 68 : 54,
                                  height: isDesktop ? 68 : 54,
                                  decoration: const BoxDecoration(
                                    color: AviajTheme.loveRed,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.diversity_1_rounded,
                                    color: Colors.white,
                                    size: isDesktop ? 36 : 28,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  'AFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isDesktop ? 86 : 62,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -2.4,
                                    height: 0.95,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AviajTheme.loveRed,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Text(
                                'AVIAJ FRIENDS FOREVER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.5,
                                  letterSpacing: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              'We’ve reimagined AFF (Aviaj Friends Forever) to make finding your people easier, safer, and more fun. Whether you’re settling into a new city, starting a solo adventure, or just looking for friends who get you, our latest features are built to help.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 19 : 15.5,
                                fontWeight: FontWeight.w600,
                                height: 1.48,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 14,
                              runSpacing: 12,
                              children: [
                                _buildStoreDownloadPill(
                                  icon: Icons.apple_rounded,
                                  topLabel: 'Download on the',
                                  storeName: 'App Store',
                                  onTap: () => showMobileAppDownloadModal(
                                    context,
                                    initialStore: 'Apple App Store (iOS)',
                                  ),
                                ),
                                _buildStoreDownloadPill(
                                  icon: Icons.play_arrow_rounded,
                                  topLabel: 'GET IT ON',
                                  storeName: 'Google Play',
                                  onTap: () => showMobileAppDownloadModal(
                                    context,
                                    initialStore: 'Google Play Store (Android)',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Apple and the Apple Logo are trademarks of Apple Inc.\nGoogle Play is a trademark of Google LLC.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.78),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreDownloadPill({
    required IconData icon,
    required String topLabel,
    required String storeName,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topLabel,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  storeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// SECTION 5: Editorial Quotation Testimonial + Full Love Stories Hub ("For the Love of Love")
  Widget _buildStoriesSection(BuildContext context, bool isDesktop) {
    final pack = widget.state.regionalPack;
    final quoteColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '""',
          style: TextStyle(
            color: AviajTheme.midnightNavy,
            fontSize: 48,
            fontWeight: FontWeight.w900,
            height: 0.9,
            letterSpacing: -2,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          pack.storyQuote,
          style: const TextStyle(
            color: AviajTheme.midnightNavy,
            fontSize: 42,
            fontWeight: FontWeight.w900,
            height: 1.12,
            letterSpacing: -1.3,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          pack.storyAttribution,
          style: const TextStyle(
            color: Color(0xFF4A3B40),
            fontSize: 16.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: () => _openFullLoveStoryModal(
            context,
            coupleName: pack.storyAttribution.split(',').first.trim(),
            metLabel: 'Met on Aviaj in 2023',
            heroImageUrl: pack.storyCoupleImageUrl,
            secondaryImageUrl: pack.departureCirclePhotoUrl,
            locationTag: '${widget.state.activeRegion.label} | First Spark',
            headlineQuote: pack.storyQuote,
          ),
          style: FilledButton.styleFrom(
            backgroundColor: AviajTheme.midnightNavy,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: const Text(
            'Read more stories',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );

    final monochromePortrait = ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0, //
          0.2126, 0.7152, 0.0722, 0, 0, //
          0.2126, 0.7152, 0.0722, 0, 0, //
          0, 0, 0, 1, 0, //
        ]),
        child: AviajNetworkImage(
          imageUrl: pack.storyCoupleImageUrl,
          height: isDesktop ? 490 : 350,
          width: double.infinity,
          fallbackLabel: pack.storyAttribution,
        ),
      ),
    );

    final region = widget.state.activeRegion;
    final String regionalSubtitle = switch (region) {
      AviajRegion.india =>
        'From Manali & Udaipur to Goa, Rishikesh, Sahyadri & Kerala—explore real love stories across India.',
      AviajRegion.middleEast =>
        'From Dubai & AlUla to Muscat, Doha & Wadi Rum—explore real love stories across the Middle East.',
      AviajRegion.americas =>
        'From New York & Austin to Yosemite, Maui & Banff—explore real love stories across the Americas.',
      AviajRegion.europe =>
        'From London & Paris to the Dolomites, Amalfi & Santorini—explore real love stories across Europe.',
      AviajRegion.asiaPacific =>
        'From Tokyo & Singapore to Bali, Phuket & Queenstown—explore real love stories across Asia-Pacific.',
    };

    final featuredStories = switch (region) {
      AviajRegion.india => [
          (
            couple: 'Ananya & Rohan',
            metYear: 'Met on Aviaj in 2023',
            summary:
                'From a Chopta–Tungnath sunrise trek to a Lake Pichola wedding in Udaipur.',
            standfirst:
                'Matched via Aviaj Destination Radar™ before a winter trek in Uttarakhand, Ananya and Rohan turned a shared love of Himalayan trails into a forever partnership.',
            cityTag: 'Mumbai & Bengaluru | Chopta–Tungnath & Udaipur',
            imageUrl: pack.storyCoupleImageUrl,
            secondImageUrl: pack.coPilotCrewImageUrl,
          ),
          (
            couple: 'Kavya & Kabir',
            metYear: 'Met on Aviaj in 2024',
            summary:
                'Filter coffee in Fontainhas and a sunset scooter ride to Cabo de Rama.',
            standfirst:
                'What began as a spontaneous Goa Travel Mode match between New Delhi and Mumbai ended with a beachside engagement in South Goa.',
            cityTag: 'New Delhi & Mumbai | Goa & Varkala',
            imageUrl: pack.coPilotCrewImageUrl,
            secondImageUrl: pack.profiles[1].imageUrl,
          ),
          (
            couple: 'Meera & Vikram',
            metYear: 'Met on Aviaj in 2022',
            summary:
                'Shared kulhad chai in Kasol led to a Kheerganga starlight proposal.',
            standfirst:
                'After joining the same AFF Parvati Valley Departure Circle from Bengaluru and Jaipur, Meera and Vikram discovered their travel rhythms matched effortlessly.',
            cityTag: 'Bengaluru & Jaipur | Kasol–Kheerganga Trek',
            imageUrl: pack.profiles[1].imageUrl,
            secondImageUrl: pack.storyCoupleImageUrl,
          ),
          (
            couple: 'Diya & Aarav',
            metYear: 'Met on Aviaj in 2024',
            summary:
                'Paragliding over Bir Billing and acoustic bonfire nights in Triund.',
            standfirst:
                'Two solo travellers who booked the same weekend group trip to Bir Billing and Triund ended up sitting next to each other on the overnight bus from Delhi.',
            cityTag: 'Kolkata & Pune | Bir Billing & Triund, Himachal',
            imageUrl: pack.profiles[2].imageUrl,
            secondImageUrl: pack.profiles[3].imageUrl,
          ),
          (
            couple: 'Riya & Dev',
            metYear: 'Met on Aviaj in 2021',
            summary:
                'Conquering Khardung La and stargazing together at Pangong Tso & Spiti.',
            standfirst:
                'A Leh-Ladakh and Spiti Valley circuit crew brought Riya and Dev together at 17,000 feet—and they have been co-pilots on every roadtrip since.',
            cityTag: 'Chandigarh & Gurugram | Leh-Ladakh & Spiti Valley',
            imageUrl: pack.profiles[3].imageUrl,
            secondImageUrl: pack.storyCoupleImageUrl,
          ),
          (
            couple: 'Nisha & Siddharth',
            metYear: 'Met on Aviaj in 2023',
            summary:
                'Monsoon treks in Kudremukh and Sahyadri forts turned friends into soulmates.',
            standfirst:
                'They first met on an AFF weekend trek up Kalsubai and Harishchandragad before celebrating their anniversary in Munnar and Varkala, Kerala.',
            cityTag: 'Hyderabad & Mumbai | Kudremukh, Sahyadri & Kerala',
            imageUrl: pack.profiles[4].imageUrl,
            secondImageUrl: pack.storyCoupleImageUrl,
          ),
        ],
      AviajRegion.middleEast => [
          (
            couple: 'Layla & Tariq',
            metYear: 'Met on Aviaj in 2023',
            summary:
                'Desert stargazing in AlUla and a sunset dhow cruise in Muscat.',
            standfirst:
                'Matched on Aviaj Destination Radar™ between Dubai and Riyadh before a weekend expedition to Hegra and Maraya.',
            cityTag: 'Dubai & Riyadh | AlUla & Muscat',
            imageUrl: pack.storyCoupleImageUrl,
            secondImageUrl: pack.coPilotCrewImageUrl,
          ),
          (
            couple: 'Noor & Omar',
            metYear: 'Met on Aviaj in 2022',
            summary:
                'Specialty Arabic coffee in Alserkal Avenue turned into a Jebel Jais roadtrip.',
            standfirst:
                'One spontaneous right swipe in Dubai led to sunrise mountain drives and a lifelong partnership.',
            cityTag: 'Dubai & Abu Dhabi | Jebel Jais',
            imageUrl: pack.coPilotCrewImageUrl,
            secondImageUrl: pack.profiles[1].imageUrl,
          ),
          (
            couple: 'Yasmin & Rami',
            metYear: 'Met on Aviaj in 2024',
            summary:
                'Hot air balloons over Wadi Rum and coral diving in Aqaba.',
            standfirst:
                'After matching on Travel Mode ahead of a Jordan itinerary, Yasmin and Rami discovered they lived in the same neighborhood.',
            cityTag: 'Amman & Doha | Wadi Rum & Red Sea',
            imageUrl: pack.profiles[1].imageUrl,
            secondImageUrl: pack.storyCoupleImageUrl,
          ),
          (
            couple: 'Farah & Zayd',
            metYear: 'Met on Aviaj in 2023',
            summary:
                'An AFF sailing crew in the Musandam fjords sparked something unforgettable.',
            standfirst:
                'What started as a 6-person coastal dhow group trip quickly blossomed into an inseparable bond.',
            cityTag: 'Muscat & Kuwait City | Musandam Fjords',
            imageUrl: pack.profiles[2].imageUrl,
            secondImageUrl: pack.profiles[3].imageUrl,
          ),
          (
            couple: 'Amira & Kareem',
            metYear: 'Met on Aviaj in 2021',
            summary:
                'From Souq Waqif lantern walks to a sunset proposal on Saadiyat Beach.',
            standfirst:
                'Delayed flights and shared airport lounge laughs led to the adventure of a lifetime across the Gulf.',
            cityTag: 'Doha & Abu Dhabi | Saadiyat Island',
            imageUrl: pack.profiles[3].imageUrl,
            secondImageUrl: pack.storyCoupleImageUrl,
          ),
          (
            couple: 'Salma & Youssef',
            metYear: 'Met on Aviaj in 2024',
            summary:
                'Nile felucca sunsets in Aswan and coastal escapes in El Gouna.',
            standfirst:
                'Matched via Aviaj Destination Radar™ while planning overlapping Red Sea diving and heritage itineraries.',
            cityTag: 'Cairo & Dubai | El Gouna & Aswan',
            imageUrl: pack.profiles[4].imageUrl,
            secondImageUrl: pack.storyCoupleImageUrl,
          ),
        ],
      AviajRegion.americas => [
          (
            couple: 'Chloe & Marcus',
            metYear: 'Met on Aviaj in 2023',
            summary:
                'Sunrise at Yosemite’s Half Dome and a Big Sur coastal roadtrip.',
            standfirst:
                'Matched on Aviaj Destination Radar™ between Austin and Denver before an autumn national parks expedition.',
            cityTag: 'Austin, TX & Denver, CO | Yosemite & Big Sur',
            imageUrl: pack.storyCoupleImageUrl,
            secondImageUrl: pack.coPilotCrewImageUrl,
          ),
          (
            couple: 'Truett & Bimal',
            metYear: 'Met on Aviaj in 2021',
            summary:
                'His friends played virtual Cupid in Dallas, and it worked like a charm.',
            standfirst:
                'One spontaneous right swipe during a Texas weekend getaway turned into years of adventures across the Americas.',
            cityTag: 'Dallas, TX | LGBTQIA+',
            imageUrl: pack.coPilotCrewImageUrl,
            secondImageUrl: pack.profiles[1].imageUrl,
          ),
          (
            couple: 'Jayde & Joel',
            metYear: 'Met on Aviaj in 2024',
            summary:
                'A mutual love of SoHo galleries and Hudson Valley hikes fit just right.',
            standfirst:
                'What started as an AFF Departure Circle coffee meetup in New York City quickly blossomed into an inseparable partnership.',
            cityTag: 'New York City, NY | Friends First',
            imageUrl: pack.profiles[1].imageUrl,
            secondImageUrl: pack.storyCoupleImageUrl,
          ),
          (
            couple: 'Sienna & Mateo',
            metYear: 'Met on Aviaj in 2022',
            summary:
                'Canyon trails in Zion and sunset surf sessions along Maui’s Road to Hana.',
            standfirst:
                'Two solo travellers from Los Angeles and Seattle matched on Travel Mode three days before landing in Maui.',
            cityTag: 'Los Angeles, CA & Seattle, WA | Zion & Maui',
            imageUrl: pack.profiles[2].imageUrl,
            secondImageUrl: pack.profiles[3].imageUrl,
          ),
          (
            couple: 'Leslie & Thomas',
            metYear: 'Met on Aviaj in 2021',
            summary:
                'From airport boarding gate laughs in Chicago to a Banff mountain wedding.',
            standfirst:
                'Delayed flights and shared travel stories led to the adventure of a lifetime across North America.',
            cityTag: 'Chicago, IL & Toronto | Banff Rockies',
            imageUrl: pack.profiles[3].imageUrl,
            secondImageUrl: pack.storyCoupleImageUrl,
          ),
          (
            couple: 'Camila & Lucas',
            metYear: 'Met on Aviaj in 2023',
            summary:
                'Sailing Key West and trekking Patagonia’s Fitz Roy with an AFF squad.',
            standfirst:
                'Matched via Aviaj Destination Radar™ while planning overlapping coastal and mountain itineraries.',
            cityTag: 'Miami, FL | Key West & Patagonia',
            imageUrl: pack.profiles[4].imageUrl,
            secondImageUrl: pack.storyCoupleImageUrl,
          ),
        ],
      AviajRegion.europe => [
          (
            couple: 'Tosin & Kieron',
            metYear: 'Met on Aviaj in 2020',
            summary: '36 questions in Dublin later, it was love.',
            standfirst:
                'A three-hour walk with hot chocolate in Dublin turned into a Venice proposal and coastal wedding in Portugal.',
            cityTag: 'Dublin & London | Venice & Portugal',
            imageUrl: pack.storyCoupleImageUrl,
            secondImageUrl: pack.coPilotCrewImageUrl,
          ),
          (
            couple: 'Nina & Thomas',
            metYear: 'Met on Aviaj in 2022',
            summary:
                'As it turned out in Paris, love really was just around the corner.',
            standfirst:
                'After matching on Aviaj Travel Mode before a train to Chamonix, Nina and Thomas realized they lived three blocks apart in Paris.',
            cityTag: 'Paris, France | Chamonix Alps',
            imageUrl: pack.coPilotCrewImageUrl,
            secondImageUrl: pack.profiles[1].imageUrl,
          ),
          (
            couple: 'Elena & Luca',
            metYear: 'Met on Aviaj in 2023',
            summary:
                'Hiking Tre Cime in the Dolomites and sailing the Amalfi Coast.',
            standfirst:
                'Matched on Aviaj Destination Radar™ between Barcelona and Milan ahead of an Italian summer itinerary.',
            cityTag: 'Barcelona & Milan | Dolomites & Amalfi',
            imageUrl: pack.profiles[1].imageUrl,
            secondImageUrl: pack.storyCoupleImageUrl,
          ),
          (
            couple: 'Freya & Lukas',
            metYear: 'Met on Aviaj in 2024',
            summary:
                'An AFF island-hopping crew in Santorini and Milos sparked romance.',
            standfirst:
                'What started as a 6-person Greek Cyclades sailing crew turned into a lifelong co-pilot match.',
            cityTag: 'Berlin & Amsterdam | Santorini & Milos',
            imageUrl: pack.profiles[2].imageUrl,
            secondImageUrl: pack.profiles[3].imageUrl,
          ),
          (
            couple: 'Clara & Henri',
            metYear: 'Met on Aviaj in 2021',
            summary:
                'Glacier Express trains across Zermatt and fondue nights in Zurich.',
            standfirst:
                'Two avid alpine hikers matched on Aviaj before a weekend ridge trail in the Swiss Alps.',
            cityTag: 'Zurich & Geneva | Swiss Alps',
            imageUrl: pack.profiles[3].imageUrl,
            secondImageUrl: pack.storyCoupleImageUrl,
          ),
          (
            couple: 'Sofia & Mateus',
            metYear: 'Met on Aviaj in 2023',
            summary:
                'Sunrise cloud hikes in Madeira and acoustic fado nights in Lisbon.',
            standfirst:
                'Matched via Aviaj Destination Radar™ while working remotely from Ponta do Sol.',
            cityTag: 'Lisbon & Madrid | Madeira Island',
            imageUrl: pack.profiles[4].imageUrl,
            secondImageUrl: pack.storyCoupleImageUrl,
          ),
        ],
      AviajRegion.asiaPacific => [
          (
            couple: 'Hana & Kenji',
            metYear: 'Met on Aviaj in 2023',
            summary:
                'Autumn maple trails in Kyoto and a sunrise climb up Mt. Fuji.',
            standfirst:
                'Matched on Aviaj Destination Radar™ between Tokyo and Osaka ahead of a Shinkansen weekend getaway.',
            cityTag: 'Tokyo & Kyoto | Mt. Fuji & Hakone',
            imageUrl: pack.storyCoupleImageUrl,
            secondImageUrl: pack.coPilotCrewImageUrl,
          ),
          (
            couple: 'Maya & Ethan',
            metYear: 'Met on Aviaj in 2024',
            summary:
                'Cliffside surf mornings in Uluwatu and Mt. Batur volcano sunrises.',
            standfirst:
                'What began as an AFF Bali villa crew from Singapore and Sydney turned into an unforgettable romance.',
            cityTag: 'Singapore & Sydney | Bali & Lombok',
            imageUrl: pack.coPilotCrewImageUrl,
            secondImageUrl: pack.profiles[1].imageUrl,
          ),
          (
            couple: 'Ji-Yoon & Min-Ho',
            metYear: 'Met on Aviaj in 2022',
            summary:
                'Coastal drives around Jeju Island and specialty coffee in Seoul.',
            standfirst:
                'After matching on Aviaj Travel Mode before a flight to Jeju, Ji-Yoon and Min-Ho discovered they shared the exact same bucket list.',
            cityTag: 'Seoul & Busan | Jeju Island',
            imageUrl: pack.profiles[1].imageUrl,
            secondImageUrl: pack.storyCoupleImageUrl,
          ),
          (
            couple: 'Chloe & Liam',
            metYear: 'Met on Aviaj in 2023',
            summary:
                'Milford Sound fiord cruises and Roy’s Peak starlight hikes in Wanaka.',
            standfirst:
                'Two solo roadtrippers matched on Aviaj in Queenstown and spent two weeks exploring New Zealand’s South Island.',
            cityTag: 'Melbourne & Auckland | Queenstown, NZ',
            imageUrl: pack.profiles[2].imageUrl,
            secondImageUrl: pack.profiles[3].imageUrl,
          ),
          (
            couple: 'Nari & Krit',
            metYear: 'Met on Aviaj in 2021',
            summary:
                'Longtail boat sunsets in Krabi and lantern festivals in Chiang Mai.',
            standfirst:
                'Matched via Aviaj Destination Radar™ while planning island-hopping routes across Thailand.',
            cityTag: 'Bangkok & Phuket | Krabi & Phi Phi',
            imageUrl: pack.profiles[3].imageUrl,
            secondImageUrl: pack.storyCoupleImageUrl,
          ),
          (
            couple: 'Mei & Lucas',
            metYear: 'Met on Aviaj in 2024',
            summary:
                'Night market street food in Taipei and Taroko Gorge mountain trails.',
            standfirst:
                'An AFF weekend hiking group in Taiwan brought Mei and Lucas together on the trail.',
            cityTag: 'Taipei & Hong Kong | Taroko & Sun Moon Lake',
            imageUrl: pack.profiles[4].imageUrl,
            secondImageUrl: pack.storyCoupleImageUrl,
          ),
        ],
    };

    final activeStory =
        featuredStories[_selectedStoryIndex % featuredStories.length];

    return Column(
      children: [
        // 5A: Regional Editorial Quote + Monochrome Couple Portrait
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 72 : 24,
            vertical: isDesktop ? 76 : 48,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 6, child: quoteColumn),
                        const SizedBox(width: 64),
                        Expanded(flex: 5, child: monochromePortrait),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        quoteColumn,
                        const SizedBox(height: 32),
                        monochromePortrait,
                      ],
                    ),
            ),
          ),
        ),

        // 5B: Full-Bleed 3-Panel B&W Couple Collage — "For the Love of Love"
        SizedBox(
          width: double.infinity,
          height: isDesktop ? 520 : 360,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildMonochromePanel(
                      pack.storyCoupleImageUrl,
                      height: double.infinity,
                    ),
                  ),
                  Expanded(
                    child: _buildMonochromePanel(
                      pack.coPilotCrewImageUrl,
                      height: double.infinity,
                    ),
                  ),
                  if (isDesktop)
                    Expanded(
                      child: _buildMonochromePanel(
                        pack.profiles[1].imageUrl,
                        height: double.infinity,
                      ),
                    ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.10),
                      Colors.black.withValues(alpha: 0.62),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: isDesktop ? 42 : 26,
                  ),
                  child: Text(
                    'For the Love of Love',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AviajTheme.loveRed,
                      fontSize: isDesktop ? 86 : 44,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2.4,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 5C: Centered Editorial Intro + 2-Panel Monochrome Couple Strip + "Featured Love Stories" 3-Column Grid
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.only(
            top: isDesktop ? 76 : 48,
            bottom: isDesktop ? 48 : 32,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 72 : 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 980),
                    child: Column(
                      children: [
                        Text(
                          'Discover real Aviaj love stories from across the world—full of sparks, surprises, second chances, and everything in between.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AviajTheme.midnightNavy,
                            fontSize: isDesktop ? 48 : 30,
                            fontWeight: FontWeight.w900,
                            height: 1.12,
                            letterSpacing: -1.4,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 14,
                          runSpacing: 12,
                          children: [
                            FilledButton(
                              onPressed: () {
                                final first = featuredStories.first;
                                _openFullLoveStoryModal(
                                  context,
                                  coupleName: first.couple,
                                  metLabel: first.metYear,
                                  heroImageUrl: first.imageUrl,
                                  secondaryImageUrl: first.secondImageUrl,
                                  locationTag: first.cityTag,
                                  headlineQuote: first.summary,
                                );
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: AviajTheme.midnightNavy,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 26,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              child: const Text(
                                'Read the stories',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.5,
                                ),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () => showMobileAppDownloadModal(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AviajTheme.midnightNavy,
                                side: const BorderSide(
                                  color: AviajTheme.midnightNavy,
                                  width: 1.4,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 26,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              child: const Text(
                                'Start your love story',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: isDesktop ? 52 : 32),
              // Full-Width 2-Panel Monochrome Couple Strip
              SizedBox(
                width: double.infinity,
                height: isDesktop ? 420 : 260,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMonochromePanel(
                        pack.profiles[2].imageUrl,
                        height: double.infinity,
                      ),
                    ),
                    Expanded(
                      child: _buildMonochromePanel(
                        pack.profiles[3].imageUrl,
                        height: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isDesktop ? 68 : 42),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 72 : 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1220),
                    child: Column(
                      children: [
                        Text(
                          'Featured Love Stories',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AviajTheme.midnightNavy,
                            fontSize: isDesktop ? 52 : 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          regionalSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF4A3B40),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 36),
                        Wrap(
                          spacing: 24,
                          runSpacing: 24,
                          children:
                              featuredStories.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final story = entry.value;
                            final cardWidth =
                                isDesktop ? 380.0 : double.infinity;
                            return SizedBox(
                              width: cardWidth,
                              child: _buildLoveStoryCollectionCard(
                                context,
                                coupleName: story.couple,
                                metYear: story.metYear,
                                summary: story.summary,
                                cityTag: story.cityTag,
                                imageUrl: story.imageUrl,
                                secondImageUrl: story.secondImageUrl,
                                onSelectStory: () {
                                  setState(() {
                                    _selectedStoryIndex = idx;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 5C-DETAIL: Full-Width Couple Story Spotlight Hero ("Love Stories > All Stories > Tosin & Kieron >")
        Container(
          width: double.infinity,
          height: isDesktop ? 580 : 460,
          color: const Color(0xFFE5E4E2),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildMonochromePanel(
                activeStory.imageUrl,
                height: double.infinity,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.55),
                      Colors.black.withValues(alpha: 0.25),
                      Colors.black.withValues(alpha: 0.76),
                    ],
                  ),
                ),
              ),
              // Top-Left Breadcrumb: "Love Stories > All Stories > Tosin & Kieron >"
              Positioned(
                top: isDesktop ? 34 : 20,
                left: isDesktop ? 48 : 20,
                right: 20,
                child: Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Love Stories  ›  All Stories  ›  ',
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${activeStory.couple}  ›',
                      style: const TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom-Centered Couple Story Title ("Met on Aviaj in 2020" + Giant "Tosin & Kieron" + Standfirst)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    24,
                    24,
                    isDesktop ? 46 : 28,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 820),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          activeStory.metYear,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFFF4B5C),
                            fontSize: isDesktop ? 24 : 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          activeStory.couple,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFFF4B5C),
                            fontSize: isDesktop ? 88 : 48,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -2.6,
                            height: 0.98,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          activeStory.standfirst,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 17.5 : 14.5,
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: () => _openFullLoveStoryModal(
                            context,
                            coupleName: activeStory.couple,
                            metLabel: activeStory.metYear,
                            heroImageUrl: activeStory.imageUrl,
                            secondaryImageUrl: activeStory.secondImageUrl,
                            locationTag: activeStory.cityTag,
                            headlineQuote: activeStory.summary,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            'Read ${activeStory.couple}’s full story ›',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 5C-ARTICLE: Full Multi-Chapter Editorial Love Story Article ("The 10-Hour Second Date" -> 2-Photo B&W Gallery -> Pull Quote -> "Two Weddings, Two Cultures, One Love" -> "Love, Laughter, and the Long Haul" -> Closing Portrait)
        _buildInlineFullStoryArticle(
          context: context,
          isDesktop: isDesktop,
          coupleName: activeStory.couple,
          primaryImageUrl: activeStory.imageUrl,
          secondaryImageUrl: activeStory.secondImageUrl,
        ),

        // 5D: Full-Bleed Red Love "Share Your Love Story" Banner with 3-Card Stacked B&W Fan
        Container(
          width: double.infinity,
          color: AviajTheme.loveRed,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 72 : 24,
            vertical: isDesktop ? 72 : 48,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: _buildShareYourLoveStoryLeftPane(context),
                        ),
                        const SizedBox(width: 56),
                        Expanded(
                          flex: 6,
                          child: _buildShareYourLoveStoryStackedFan(pack),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShareYourLoveStoryLeftPane(context),
                        const SizedBox(height: 36),
                        _buildShareYourLoveStoryStackedFan(pack),
                      ],
                    ),
            ),
          ),
        ),

        // 5E: "Explore More Love Stories" 3-Column Row ("Truett & Bimal", "Jayde & Joel", "Nina & Thomas")
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 72 : 24,
            vertical: isDesktop ? 76 : 48,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: Column(
                children: [
                  Text(
                    'Explore More Love Stories',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF1E1E1E),
                      fontSize: isDesktop ? 52 : 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    regionalSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF3A3A3A),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [1, 3, 2].map((storyIdx) {
                      final story = featuredStories[storyIdx];
                      final cardWidth = isDesktop ? 380.0 : double.infinity;
                      return SizedBox(
                        width: cardWidth,
                        child: _buildLoveStoryCollectionCard(
                          context,
                          coupleName: story.couple,
                          metYear: story.metYear,
                          summary: story.summary,
                          cityTag: story.cityTag,
                          imageUrl: story.imageUrl,
                          secondImageUrl: story.secondImageUrl,
                          imageHeight: 350,
                          onSelectStory: () {
                            setState(() {
                              _selectedStoryIndex = storyIdx;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 5F: "Browse the Love Stories Collection" ("Love Stories > All Stories >" + Staggered 3-Column Masonry Grid)
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Color(0xFFEFEFEF), width: 1),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            isDesktop ? 72 : 24,
            isDesktop ? 36 : 24,
            isDesktop ? 72 : 24,
            isDesktop ? 84 : 48,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Love Stories  ›  All Stories  ›',
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: isDesktop ? 32 : 20),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Browse the Love Stories Collection',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF1E1E1E),
                            fontSize: isDesktop ? 62 : 36,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.9,
                            height: 1.06,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: const Text(
                            'From Italian proposals to three-day-long first dates and cross-country meetups, explore the heartfelt stories of couples who found exactly what they were looking for, on Aviaj.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF3A3A3A),
                              fontSize: 16.5,
                              fontWeight: FontWeight.w500,
                              height: 1.48,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 44),
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Column 1: Tosin & Kieron (Tall 360) + Jayde & Joel (Compact 220)
                        Expanded(
                          child: Column(
                            children: [
                              _buildLoveStoryCollectionCard(
                                context,
                                coupleName: featuredStories[0].couple,
                                metYear: featuredStories[0].metYear,
                                summary: featuredStories[0].summary,
                                cityTag: featuredStories[0].cityTag,
                                imageUrl: featuredStories[0].imageUrl,
                                secondImageUrl:
                                    featuredStories[0].secondImageUrl,
                                imageHeight: 360,
                                onSelectStory: () =>
                                    setState(() => _selectedStoryIndex = 0),
                              ),
                              const SizedBox(height: 24),
                              _buildLoveStoryCollectionCard(
                                context,
                                coupleName: featuredStories[3].couple,
                                metYear: featuredStories[3].metYear,
                                summary: featuredStories[3].summary,
                                cityTag: featuredStories[3].cityTag,
                                imageUrl: featuredStories[3].imageUrl,
                                secondImageUrl:
                                    featuredStories[3].secondImageUrl,
                                imageHeight: 220,
                                onSelectStory: () =>
                                    setState(() => _selectedStoryIndex = 3),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Column 2: Nina & Thomas (Tall 360) + Truett & Bimal (Tall 360)
                        Expanded(
                          child: Column(
                            children: [
                              _buildLoveStoryCollectionCard(
                                context,
                                coupleName: featuredStories[2].couple,
                                metYear: featuredStories[2].metYear,
                                summary: featuredStories[2].summary,
                                cityTag: featuredStories[2].cityTag,
                                imageUrl: featuredStories[2].imageUrl,
                                secondImageUrl:
                                    featuredStories[2].secondImageUrl,
                                imageHeight: 360,
                                onSelectStory: () =>
                                    setState(() => _selectedStoryIndex = 2),
                              ),
                              const SizedBox(height: 24),
                              _buildLoveStoryCollectionCard(
                                context,
                                coupleName: featuredStories[1].couple,
                                metYear: featuredStories[1].metYear,
                                summary: featuredStories[1].summary,
                                cityTag: featuredStories[1].cityTag,
                                imageUrl: featuredStories[1].imageUrl,
                                secondImageUrl:
                                    featuredStories[1].secondImageUrl,
                                imageHeight: 360,
                                onSelectStory: () =>
                                    setState(() => _selectedStoryIndex = 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Column 3: Leslie & Thomas (Compact 220) + Regional Couple (Tall 360)
                        Expanded(
                          child: Column(
                            children: [
                              _buildLoveStoryCollectionCard(
                                context,
                                coupleName: featuredStories[4].couple,
                                metYear: featuredStories[4].metYear,
                                summary: featuredStories[4].summary,
                                cityTag: featuredStories[4].cityTag,
                                imageUrl: featuredStories[4].imageUrl,
                                secondImageUrl:
                                    featuredStories[4].secondImageUrl,
                                imageHeight: 220,
                                onSelectStory: () =>
                                    setState(() => _selectedStoryIndex = 4),
                              ),
                              const SizedBox(height: 24),
                              _buildLoveStoryCollectionCard(
                                context,
                                coupleName: featuredStories[5].couple,
                                metYear: featuredStories[5].metYear,
                                summary: featuredStories[5].summary,
                                cityTag: featuredStories[5].cityTag,
                                imageUrl: featuredStories[5].imageUrl,
                                secondImageUrl:
                                    featuredStories[5].secondImageUrl,
                                imageHeight: 360,
                                onSelectStory: () =>
                                    setState(() => _selectedStoryIndex = 5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: featuredStories.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final story = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _buildLoveStoryCollectionCard(
                            context,
                            coupleName: story.couple,
                            metYear: story.metYear,
                            summary: story.summary,
                            cityTag: story.cityTag,
                            imageUrl: story.imageUrl,
                            secondImageUrl: story.secondImageUrl,
                            imageHeight: 300,
                            onSelectStory: () =>
                                setState(() => _selectedStoryIndex = idx),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInlineFullStoryArticle({
    required BuildContext context,
    required bool isDesktop,
    required String coupleName,
    required String primaryImageUrl,
    required String secondaryImageUrl,
  }) {
    final parts = coupleName.split('&');
    final firstPartner = parts.isNotEmpty ? parts.first.trim() : 'Ananya';
    final secondPartner = parts.length > 1 ? parts.last.trim() : 'Rohan';
    final region = widget.state.activeRegion;
    final cafeAndWalkLine = switch (region) {
      AviajRegion.india =>
        'What was meant to be a quick meetup turned into filter coffee in Bandra and a three-hour sunset walk along Marine Drive—followed by planning a weekend trek to Chopta–Tungnath and Kasol.',
      AviajRegion.middleEast =>
        'What was meant to be a quick meetup turned into specialty Arabic coffee at Alserkal Avenue and a three-hour sunset walk by Dubai Creek—followed by a weekend drive to Jebel Jais and AlUla.',
      AviajRegion.americas =>
        'What was meant to be a quick meetup turned into pour-over coffee in SoHo and a three-hour sunset walk—followed by planning a roadtrip to Yosemite and Big Sur.',
      AviajRegion.europe =>
        'What was meant to be a quick meetup turned into hot chocolate at Butler’s Café and a three-hour walk—followed by planning an alpine getaway to the Dolomites and Amalfi Coast.',
      AviajRegion.asiaPacific =>
        'What was meant to be a quick meetup turned into matcha lattes in Shibuya and a three-hour sunset walk—followed by planning a weekend trip to Kyoto and Mt. Fuji.',
    };
    final proposalAndWeddingParagraph1 = switch (region) {
      AviajRegion.india =>
        'One year after moving in together, $secondPartner proposed at sunrise overlooking Lake Pichola in Udaipur, and $firstPartner said yes. That “yes” turned into two unforgettable celebrations — first with a vibrant sangeet and traditional wedding in Jaipur, and then with an intimate coastal sundowner ceremony in South Goa.',
      AviajRegion.middleEast =>
        'One year after moving in together, $secondPartner proposed under the stars in AlUla, and $firstPartner said yes. That “yes” turned into two unforgettable celebrations — first with a traditional family celebration in Dubai, and then with an intimate cliffside ceremony overlooking Muscat.',
      AviajRegion.americas =>
        'One year after moving in together, $secondPartner proposed at sunset in Big Sur, and $firstPartner said yes. That “yes” turned into two unforgettable celebrations — first with a warm family celebration in Austin, and then with an intimate coastal ceremony in Maui.',
      AviajRegion.europe =>
        'One year after moving in together, $secondPartner proposed in Venice, and $firstPartner said yes. That “yes” turned into two unforgettable celebrations — first with a traditional family gathering, and then with an intimate coastal ceremony in Portugal.',
      AviajRegion.asiaPacific =>
        'One year after moving in together, $secondPartner proposed beneath the autumn maples in Kyoto, and $firstPartner said yes. That “yes” turned into two unforgettable celebrations — first in Tokyo, and then with an intimate cliffside ceremony in Uluwatu, Bali.',
    };
    final proposalAndWeddingParagraph2 = switch (region) {
      AviajRegion.india =>
        'From Himalayan treks in Kedarkantha and Spiti Valley to backwater houseboats in Kerala, forty-five of their closest friends from their Aviaj Departure Circles gathered to celebrate the journey that brought them together.',
      _ =>
        'Forty-five of their closest friends and fellow travellers gathered overlooking the coast to celebrate the shared itineraries and spontaneous detours that brought them together.',
    };

    const bodyStyle = TextStyle(
      color: Color(0xFF2B2B2B),
      fontSize: 16.5,
      fontWeight: FontWeight.w400,
      height: 1.62,
    );

    const headingStyle = TextStyle(
      color: Color(0xFF1E1E1E),
      fontSize: 32,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.8,
      height: 1.2,
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 72 : 24,
        isDesktop ? 68 : 44,
        isDesktop ? 72 : 24,
        0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chapter 1: Opening & "The 10-Hour Second Date"
              Text(
                'They say timing is everything — and when $firstPartner and $secondPartner matched on Aviaj, their overlapping travel routes made the first spark effortless.',
                style: bodyStyle,
              ),
              const SizedBox(height: 22),
              Text(
                'When they first matched on Aviaj, $firstPartner thought, “Let’s see what happens. It might be a great travel connection.” But as they started chatting, she quickly realized just how warm and funny $secondPartner was.',
                style: bodyStyle,
              ),
              const SizedBox(height: 22),
              Text(
                'Then life got busy, and their conversation paused for a few days. When $firstPartner opened Aviaj again, she broke the ice with a simple question: “Do you want to grab coffee and go for a walk later?” $secondPartner immediately said yes.',
                style: bodyStyle,
              ),
              const SizedBox(height: 22),
              Text(
                '$cafeAndWalkLine “I was surprised by how well we got on together,” $secondPartner recalls. “It was really easy to just settle into meeting each other for the first time.” Once the date was over, $secondPartner immediately messaged $firstPartner asking for a second one.',
                style: bodyStyle,
              ),
              const SizedBox(height: 40),
              const Text(
                'The 10-Hour Second Date',
                style: headingStyle,
              ),
              const SizedBox(height: 18),
              Text(
                'For their second date, $firstPartner brought along “36 Questions That Lead to Love,” a game designed to accelerate closeness through shared vulnerability and travel stories.',
                style: bodyStyle,
              ),
              const SizedBox(height: 22),
              Text(
                '“These were deep questions,” $secondPartner says. “Like, peel back the layers, let’s really do this.”',
                style: bodyStyle,
              ),
              const SizedBox(height: 22),
              const Text(
                'What started as curiosity turned into 10 hours of sharing bucket-list routes and opening up in ways most people don’t in the first few weeks of dating. Thirty-six questions later, there was no denying their connection had shifted into something lasting.',
                style: bodyStyle,
              ),
              const SizedBox(height: 22),
              Text(
                '“After that, we started planning every long weekend trip together,” $firstPartner says. A year later, they made it official and moved in together.',
                style: bodyStyle,
              ),
              const SizedBox(height: 52),

              // Chapter 2: Side-by-Side 2-Photo Monochrome Portrait Gallery
              isDesktop
                  ? Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: _buildMonochromePanel(
                              primaryImageUrl,
                              height: 500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: _buildMonochromePanel(
                              secondaryImageUrl,
                              height: 500,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: _buildMonochromePanel(
                            primaryImageUrl,
                            height: 340,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: _buildMonochromePanel(
                            secondaryImageUrl,
                            height: 340,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 56),

              // Chapter 3: Giant Editorial Pull Quote + "Two Celebrations, One Shared Horizon"
              const Text(
                '""',
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  height: 0.85,
                  letterSpacing: -2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'I didn’t like the idea of waiting for somebody to message me. I’m in charge of my love life here, so I just really always felt empowered by Aviaj.',
                style: TextStyle(
                  color: const Color(0xFF1E1E1E),
                  fontSize: isDesktop ? 40 : 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.1,
                  height: 1.18,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                firstPartner,
                style: const TextStyle(
                  color: Color(0xFF4A3B40),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                'Two Celebrations, One Shared Horizon',
                style: headingStyle,
              ),
              const SizedBox(height: 18),
              Text(
                proposalAndWeddingParagraph1,
                style: bodyStyle,
              ),
              const SizedBox(height: 22),
              Text(
                proposalAndWeddingParagraph2,
                style: bodyStyle,
              ),
              const SizedBox(height: 44),

              // Chapter 4: "Love, Laughter, and the Long Haul" + Closing Monochrome Portrait
              const Text(
                'Love, Laughter, and the Long Haul',
                style: headingStyle,
              ),
              const SizedBox(height: 18),
              Text(
                'What defines their relationship is a sense of partnership — the certainty that no matter what life brings, they can face it together. “When one of us is having a bad day, the other one’s probably picking up some of the slack. We’re looking after each other because it’s us against everything, as opposed to us against each other,” $firstPartner says.',
                style: bodyStyle,
              ),
              const SizedBox(height: 22),
              Text(
                'By the time $secondPartner came along, she finally felt ready for that kind of partnership. “A lot of personal growth coming into 2020 helped me be energetically where I needed to be to meet someone like him,” she says. “I didn’t like the idea of waiting for somebody to message me. I’m in charge of my love life here, so I just really always felt empowered by Aviaj.”',
                style: bodyStyle,
              ),
              const SizedBox(height: 22),
              Text(
                'When asked what they admire about the other, $firstPartner speaks to $secondPartner’s patience and kindness, qualities that steady her energy. She also says, “He’s the kindest person you’ll ever meet. He looks after everybody.”',
                style: bodyStyle,
              ),
              const SizedBox(height: 22),
              Text(
                '$secondPartner calls $firstPartner the “perfect person,” adding, “If I had to be a better person, I would model myself after my wife. The amount of empathy that she has for people, her ability to read situations, and give advice is unmatched. She’s amazing.”',
                style: bodyStyle,
              ),
              const SizedBox(height: 22),
              const Text(
                'Who would have thought that during a year of distancing, meeting on Aviaj would be the thing that brought them closer than they ever imagined?',
                style: bodyStyle,
              ),
              const SizedBox(height: 48),
              Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                  child: SizedBox(
                    width: isDesktop ? 720 : double.infinity,
                    child: _buildMonochromePanel(
                      primaryImageUrl,
                      height: isDesktop ? 420 : 300,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonochromePanel(String imageUrl, {required double height}) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.2126, 0.7152, 0.0722, 0, 0, //
        0.2126, 0.7152, 0.0722, 0, 0, //
        0.2126, 0.7152, 0.0722, 0, 0, //
        0, 0, 0, 1, 0, //
      ]),
      child: AviajNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: height,
        fallbackLabel: 'Aviaj Love Story',
      ),
    );
  }

  Widget _buildLoveStoryCollectionCard(
    BuildContext context, {
    required String coupleName,
    required String metYear,
    required String summary,
    required String cityTag,
    required String imageUrl,
    required String secondImageUrl,
    double imageHeight = 340,
    VoidCallback? onSelectStory,
  }) {
    return InkWell(
      onTap: () {
        onSelectStory?.call();
        _openFullLoveStoryModal(
          context,
          coupleName: coupleName,
          metLabel: metYear,
          heroImageUrl: imageUrl,
          secondaryImageUrl: secondImageUrl,
          locationTag: cityTag,
          headlineQuote: summary,
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F5F2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildMonochromePanel(imageUrl, height: imageHeight),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.72),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 18,
                      child: Column(
                        children: [
                          Text(
                            coupleName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFFF4B5C),
                              fontSize: 27,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.6,
                              height: 1.08,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            metYear,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFFF4B5C),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AviajTheme.midnightNavy,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cityTag,
                    style: const TextStyle(
                      color: Color(0xFF6E5D62),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Read more',
                    style: TextStyle(
                      color: AviajTheme.midnightNavy,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareYourLoveStoryLeftPane(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share Your\nLove Story',
          style: TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.w900,
            height: 1.02,
            letterSpacing: -1.8,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Whether you found your person on Aviaj or finally found your people on AFF, we’d love to share your story and inspire people to find love too.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.5,
            fontWeight: FontWeight.w500,
            height: 1.48,
          ),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: () => _openSubmitYourStoryModal(context),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF242424),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: const Text(
            'Submit your story',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF242424),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mail_outline_rounded,
                color: Colors.white,
                size: 19,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.48,
                  ),
                  children: [
                    TextSpan(text: 'Prefer pen and paper? Send your story to:\n'),
                    TextSpan(
                      text: 'Aviaj P.O. Box 300940 Austin, Texas, 78703\n',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    TextSpan(
                      text:
                          'We read every letter — and may occasionally even write back.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShareYourLoveStoryStackedFan(AviajRegionalContentPack pack) {
    final frontPortrait = pack.storyCoupleImageUrl;
    final middlePortrait = pack.profiles.length > 1
        ? pack.profiles[1].imageUrl
        : pack.steppedCards[0].imageUrl;
    final backPortrait = pack.profiles.length > 2
        ? pack.profiles[2].imageUrl
        : pack.steppedCards[2].imageUrl;

    return SizedBox(
      height: 430,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Back-Right 3rd Stepped Card
          Positioned(
            left: 265,
            top: 56,
            width: 225,
            height: 318,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: _buildMonochromePanel(
                  backPortrait,
                  height: 318,
                ),
              ),
            ),
          ),
          // Middle 2nd Stepped Card
          Positioned(
            left: 190,
            top: 28,
            width: 260,
            height: 374,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: _buildMonochromePanel(
                  middlePortrait,
                  height: 374,
                ),
              ),
            ),
          ),
          // Front-Left Primary Card (Largest)
          Positioned(
            left: 0,
            top: 0,
            width: 335,
            height: 430,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: _buildMonochromePanel(
                  frontPortrait,
                  height: 430,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openSubmitYourStoryModal(BuildContext context) {
    final namesController = TextEditingController();
    final locationController = TextEditingController();
    final storyController = TextEditingController();
    String selectedMode = 'Aviaj Date';

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Dialog(
              insetPadding: const EdgeInsets.all(20),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Share Your Love Story',
                                style: TextStyle(
                                  color: Color(0xFF1E1E1E),
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.8,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              icon: const Icon(Icons.close_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Whether you found your person on Aviaj or finally found your people on AFF, tell us how your journey began.',
                          style: TextStyle(
                            color: Color(0xFF4A4A4A),
                            fontSize: 14.5,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          children: ['Aviaj Date', 'AFF — Aviaj Friends Forever']
                              .map((mode) {
                            final active = selectedMode == mode;
                            return ChoiceChip(
                              label: Text(mode),
                              selected: active,
                              selectedColor: AviajTheme.loveRed,
                              labelStyle: TextStyle(
                                color: active
                                    ? Colors.white
                                    : const Color(0xFF1E1E1E),
                                fontWeight: FontWeight.w700,
                              ),
                              onSelected: (_) {
                                setModalState(() => selectedMode = mode);
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: namesController,
                          decoration: InputDecoration(
                            labelText: 'Your Names (e.g., Tosin & Kieron)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: locationController,
                          decoration: InputDecoration(
                            labelText:
                                'Year & City / Destination (e.g., Met on Aviaj in 2024 • Manali / Austin)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: storyController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText:
                                'How did you meet, and what was your favorite date or trip together?',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Thank you for sharing your Aviaj story! Our Love Stories Desk will be in touch.',
                                  ),
                                  backgroundColor: Color(0xFF242424),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF242424),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            child: const Text(
                              'Submit your story',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Full-Screen Editorial Love Story Reader Modal (matches Tosin & Kieron multi-chapter view)
  void _openFullLoveStoryModal(
    BuildContext context, {
    required String coupleName,
    required String metLabel,
    required String heroImageUrl,
    required String secondaryImageUrl,
    required String locationTag,
    required String headlineQuote,
  }) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1060, maxHeight: 860),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Breadcrumb + Close Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 18, 20, 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Love Stories  ›  All Stories  ›  $coupleName  ›',
                              style: const TextStyle(
                                color: AviajTheme.midnightNavy,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                    ),
                    // Giant B&W Hero Banner with Met Year + Couple Name
                    SizedBox(
                      height: 420,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildMonochromePanel(heroImageUrl, height: 420),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.15),
                                  Colors.black.withValues(alpha: 0.78),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AviajTheme.loveRed,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      metLabel,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    coupleName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 64,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -2.0,
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 580,
                                    ),
                                    child: Text(
                                      headlineQuote,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        height: 1.45,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Multi-Chapter Editorial Story Body
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'They say timing is everything — and when $coupleName matched on Aviaj ($locationTag), neither of them expected a single route check-in to turn into a lifelong adventure together.',
                            style: const TextStyle(
                              color: AviajTheme.midnightNavy,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w500,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'The 10-Hour Second Date',
                            style: TextStyle(
                              color: AviajTheme.midnightNavy,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'What started as curiosity turned into 10 hours of sharing travel stories, favorite cafés, and opening up in ways most people don’t in the first few weeks of dating. Thirty-six questions later, there was no denying their connection had shifted into something extraordinary.',
                            style: TextStyle(
                              color: Color(0xFF3E3034),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 28),
                          // Side-by-side B&W duo portraits
                          Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: _buildMonochromePanel(
                                    heroImageUrl,
                                    height: 300,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: _buildMonochromePanel(
                                    secondaryImageUrl,
                                    height: 300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Text(
                            '“I didn’t like the idea of waiting for somebody to message me. I’m in charge of my love life here, so I just really always felt empowered by Aviaj.”',
                            style: const TextStyle(
                              color: AviajTheme.midnightNavy,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              height: 1.22,
                              letterSpacing: -0.9,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            coupleName,
                            style: const TextStyle(
                              color: Color(0xFF5A4A4F),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 28),
                          const Text(
                            'Two Weddings, Two Cultures, One Love',
                            style: TextStyle(
                              color: AviajTheme.midnightNavy,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'One year after moving in together, a proposal overlooking the coast turned into two unforgettable celebrations with friends and family from around the world. What defines their relationship is a sense of partnership — the certainty that no matter what life brings, they can face it together.',
                            style: TextStyle(
                              color: Color(0xFF3E3034),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// SECTION 6 (Screenshot 6): Rounded "Get the app" Banner with QR Code Card on Left & 3 Fanned iPhones on Right
  Widget _buildGetTheAppQrPhonesBanner(BuildContext context, bool isDesktop) {
    final leftQrPane = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Get the app',
          style: TextStyle(
            color: Colors.white,
            fontSize: 54,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Just scan the QR code to get started.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 28),
        InkWell(
          onTap: () => showMobileAppDownloadModal(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 182,
            height: 182,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.qr_code_2_rounded,
                  size: 154,
                  color: AviajTheme.midnightNavy,
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: AviajTheme.loveRed,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const AppStoreDownloadBadges(lightOnDark: false),
      ],
    );

    final pack = widget.state.regionalPack;
    final rightFannedPhones = SizedBox(
      width: isDesktop ? 560 : 340,
      height: isDesktop ? 420 : 320,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Left Tilted Phone
          Positioned(
            left: isDesktop ? 36 : 8,
            bottom: -36,
            width: isDesktop ? 210 : 145,
            height: isDesktop ? 340 : 240,
            child: Transform.rotate(
              angle: -0.09,
              child: _buildMockupPhoneFrame(
                imageUrl: pack.fannedPhoneImageUrls[0],
                headerTitle: '9:41',
                showBrandHeader: false,
              ),
            ),
          ),
          // Right Tilted Phone
          Positioned(
            right: isDesktop ? 36 : 8,
            bottom: -36,
            width: isDesktop ? 210 : 145,
            height: isDesktop ? 340 : 240,
            child: Transform.rotate(
              angle: 0.09,
              child: _buildMockupPhoneFrame(
                imageUrl: pack.fannedPhoneImageUrls[2],
                headerTitle: '9:41',
                showBrandHeader: false,
              ),
            ),
          ),
          // Center Upright Phone
          Positioned(
            bottom: -24,
            width: isDesktop ? 255 : 185,
            height: isDesktop ? 405 : 295,
            child: _buildMockupPhoneFrame(
              imageUrl: pack.fannedPhoneImageUrls[1],
              headerTitle: 'Aviaj',
              showBrandHeader: true,
            ),
          ),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 24,
        vertical: isDesktop ? 36 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Container(
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.fromLTRB(
              isDesktop ? 56 : 24,
              isDesktop ? 48 : 36,
              isDesktop ? 40 : 24,
              0,
            ),
            decoration: BoxDecoration(
              color: AviajTheme.loveRed,
              borderRadius: BorderRadius.circular(32),
            ),
            child: isDesktop
                ? SizedBox(
                    height: 420,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 48),
                            child: leftQrPane,
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: rightFannedPhones,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      leftQrPane,
                      const SizedBox(height: 28),
                      Center(child: rightFannedPhones),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildMockupPhoneFrame({
    required String imageUrl,
    required String headerTitle,
    required bool showBrandHeader,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: AviajTheme.midnightNavy,
          width: 5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '9:41',
                style: TextStyle(
                  color: AviajTheme.midnightNavy,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.signal_cellular_alt_rounded,
                    size: 12,
                    color: AviajTheme.midnightNavy,
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.wifi_rounded,
                    size: 12,
                    color: AviajTheme.midnightNavy,
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.battery_full_rounded,
                    size: 12,
                    color: AviajTheme.midnightNavy,
                  ),
                ],
              ),
            ],
          ),
          if (showBrandHeader) ...[
            const SizedBox(height: 6),
            Text(
              headerTitle,
              style: const TextStyle(
                color: AviajTheme.midnightNavy,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: -0.6,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: AviajNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: double.infinity,
                fallbackLabel: headerTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SECTION 7: Minimal Cabin Class Upgrades (`acct_1TNTVyJD1U0jWVOT`)
  Widget _buildMinimalCabinUpgradesSection(
    BuildContext context,
    bool isDesktop,
  ) {
    return Container(
      width: double.infinity,
      color: AviajTheme.warmSand,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 24,
        vertical: 92,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AviajTheme.loveRed,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'STRIPE CHECKOUT • acct_1TNTVyJD1U0jWVOT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => showAdMobUnityConsoleModal(context),
                    icon: const Icon(
                      Icons.monetization_on_rounded,
                      size: 16,
                      color: AviajTheme.horizonTeal,
                    ),
                    label: const Text(
                      'Or earn free passes via AdMob & Unity Ads',
                      style: TextStyle(
                        color: AviajTheme.horizonTeal,
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Upgrade your cabin class.',
                style: TextStyle(
                  color: AviajTheme.midnightNavy,
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                ),
              ),
              const SizedBox(height: 36),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: AviajStripeService.plans.map((plan) {
                  return SizedBox(
                    width: isDesktop ? 384 : double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: plan.badgeColor, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: plan.badgeColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              plan.subtitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            plan.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AviajTheme.midnightNavy,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            plan.interval == 'month'
                                ? '\$${plan.amountUsd.toStringAsFixed(2)} / mo'
                                : '\$${plan.amountUsd.toStringAsFixed(2)} pack',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: AviajTheme.sunsetTerracotta,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...plan.perks.take(3).map(
                                (p) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: AviajTheme.solidEmerald,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          p,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AviajTheme.midnightNavy,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () => showStripeStorefrontModal(
                                context,
                                customTripPlan: plan,
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: AviajTheme.loveRed,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text(
                                'Upgrade with Stripe',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// SECTION 8: Single Consistent Red Editorial Footer:
  /// Deep Dark Crimson (`#3B040C`) Footer with Red Headings, Multi-column SEO links,
  /// Language/Region Selector Pill, QR App Download Badge, and Colossal Full-Bleed Bright Red `AVIAJ` wordmark spanning 100% width.
  Widget _buildConversionBannerAndFooter(
    BuildContext context,
    bool isDesktop,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      color: const Color(0xFF3B040C),
      padding: EdgeInsets.only(
        top: isDesktop ? 64 : 44,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 72 : 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1220),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 48,
                      runSpacing: 36,
                      children: [
                        // Left Editorial Description + Dark Region Selector Pill + Red QR Card
                        SizedBox(
                          width: isDesktop ? 310 : double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _langPack.footerBrandParagraph,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildRegionSelectorPill(
                                isDarkPill: true,
                                showFullLanguageLabel: true,
                              ),
                              const SizedBox(height: 20),
                              InkWell(
                                onTap: () => showMobileAppDownloadModal(context),
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AviajTheme.loveRed,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 68,
                                        height: 68,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            const Icon(
                                              Icons.qr_code_2_rounded,
                                              size: 56,
                                              color: AviajTheme.midnightNavy,
                                            ),
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: const Icon(
                                                Icons.favorite_rounded,
                                                color: AviajTheme.loveRed,
                                                size: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Flexible(
                                        child: Text(
                                          _langPack.scanQrToGetApp,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                            height: 1.25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _FooterColumn(
                          title: _langPack.footerLegalHeading,
                          items: const [
                            'Do not sell or share my personal information',
                            'Manage cookies',
                            'Consumer Health Data Privacy Policy',
                            'Terms',
                            'Cookie Policy',
                            'Intellectual Property',
                            'Community Guidelines',
                            'Safety Policy Information',
                            'Accessibility Statement',
                          ],
                          onTap: () => _showPrivacyChoicesModal(context),
                        ),
                        _FooterColumn(
                          title: _langPack.footerDestinationsHeading,
                          items: const [
                            'Destinations',
                            'Departure Stories',
                            'The Friendship Hub',
                            'Seasonal Dating Guides',
                            'Safety Center',
                            'Support',
                            'Gift Cards',
                          ],
                          onTap: () => _navigateToSeoPage(AviajSeoPage.stories),
                        ),
                        _FooterColumn(
                          title: _langPack.footerCareersHeading,
                          items: const [
                            'Careers Portal',
                            'Tech Blog',
                            'Stripe (${AviajStripeService.defaultStripeAccountId})',
                            'AdMob & Unity Ads',
                          ],
                          onTap: () => _scrollToSection(_pricingKey),
                        ),
                        _FooterColumn(
                          title: _langPack.footerGetAppHeading,
                          items: const [
                            'App Store (iOS)',
                            'Google Play Store',
                            'Instagram',
                            'TikTok',
                            'YouTube',
                            'X',
                          ],
                          onTap: () => showMobileAppDownloadModal(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
          // COLOSSAL FULL-BLEED BRIGHT LOVE RED "AVIAJ" WORDMARK FULLY READABLE AT BOTTOM
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availWidth = constraints.maxWidth.isFinite
                    ? constraints.maxWidth
                    : screenWidth - 48;
                const double refFontSize = 300.0;
                final tp = TextPainter(
                  text: const TextSpan(
                    text: 'AVIAJ',
                    style: TextStyle(
                      color: AviajTheme.loveRed,
                      fontSize: refFontSize,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      letterSpacing: -8,
                    ),
                  ),
                  textDirection: TextDirection.ltr,
                )..layout();
                final metrics = tp.computeLineMetrics();
                final baseline = metrics.isNotEmpty
                    ? metrics.first.baseline
                    : tp.height * 0.80;
                final glyphTop = baseline - (refFontSize * 0.76);
                final glyphBottom = baseline + (refFontSize * 0.06);
                final glyphHeight = glyphBottom - glyphTop;
                final boxHeight = availWidth * (glyphHeight / tp.width);
                return SizedBox(
                  width: availWidth,
                  height: boxHeight,
                  child: const CustomPaint(
                    painter: _FooterAviajWordmarkPainter(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom-docked Privacy Acknowledgment Banner ("Your privacy choices")
  /// matching the editorial privacy consent design (`=Aviaj | Your privacy choices ... [Continue]`).
  Widget _buildPrivacyAcknowledgmentBanner(
    BuildContext context,
    bool isDesktop,
  ) {
    return Material(
      color: Colors.white,
      elevation: 18,
      shadowColor: Colors.black.withValues(alpha: 0.22),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE6E2E4), width: 1),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 48 : 20,
          vertical: isDesktop ? 28 : 20,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1020),
            child: isDesktop
                ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column: Compact "=Aviaj" Mark
                        Padding(
                          padding: const EdgeInsets.only(top: 4, right: 24),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 11,
                                    height: 2.2,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2B2B2B),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(height: 2.2),
                                  Container(
                                    width: 14,
                                    height: 2.2,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2B2B2B),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(height: 2.2),
                                  Container(
                                    width: 11,
                                    height: 2.2,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2B2B2B),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Aviaj',
                                style: TextStyle(
                                  color: Color(0xFF2B2B2B),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15.5,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Vertical Divider Line
                        Container(
                          width: 1,
                          color: const Color(0xFFE2DEE0),
                          margin: const EdgeInsets.only(right: 28),
                        ),
                        // Right Column: Privacy Copy & "Continue" Pill Button
                        Expanded(
                          child: _buildPrivacyBannerTextAndAction(context),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            size: 18,
                            color: Color(0xFF2B2B2B),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Aviaj',
                            style: TextStyle(
                              color: Color(0xFF2B2B2B),
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => _setPrivacyConsentAccepted(true),
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: Color(0xFF2B2B2B),
                            ),
                            visualDensity: VisualDensity.compact,
                            tooltip: 'Dismiss privacy notice',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildPrivacyBannerTextAndAction(context),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyBannerTextAndAction(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Your privacy choices',
          style: TextStyle(
            color: Color(0xFF2B2B2B),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'We use services that help improve marketing campaigns. (Learn more in our ',
              style: TextStyle(
                color: Color(0xFF3B3B3B),
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                height: 1.45,
              ),
            ),
            InkWell(
              onTap: () => _showPrivacyChoicesModal(context),
              child: const Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  height: 1.45,
                ),
              ),
            ),
            const Text(
              ').',
              style: TextStyle(
                color: Color(0xFF3B3B3B),
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                height: 1.45,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Under certain privacy laws, this may be considered selling or sharing your personal information with our marketing partners.',
          style: TextStyle(
            color: Color(0xFF3B3B3B),
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _showPrivacyChoicesModal(context),
          child: const Text(
            'You can view these partners and opt out by clicking “Do not sell or share my personal information” at the bottom of the homepage.',
            style: TextStyle(
              color: Color(0xFF3B3B3B),
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _setPrivacyConsentAccepted(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2B2B2B),
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(188, 46),
            padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          child: const Text(
            'Continue',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14.5,
            ),
          ),
        ),
      ],
    );
  }

  void _showPrivacyChoicesModal(BuildContext context) {
    bool localOptOut = _optOutMarketingPartners;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Your Privacy Choices & Policy',
                            style: TextStyle(
                              color: AviajTheme.midnightNavy,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Aviaj uses essential cookies to keep your account secure and optional analytics & marketing services (including Google AdMob, Unity LevelPlay, and Stripe Checkout) to personalize travel campaigns.',
                        style: TextStyle(
                          color: Color(0xFF4A3B40),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF8F7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFEAE2E4)),
                        ),
                        child: SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          activeThumbColor: AviajTheme.loveRed,
                          title: const Text(
                            'Do not sell or share my personal information',
                            style: TextStyle(
                              color: AviajTheme.midnightNavy,
                              fontWeight: FontWeight.w800,
                              fontSize: 14.5,
                            ),
                          ),
                          subtitle: const Text(
                            'Opt out of sharing personal identifiers with third-party marketing and attribution partners under CPRA/GDPR.',
                            style: TextStyle(
                              color: Color(0xFF5C4B51),
                              fontSize: 12.5,
                            ),
                          ),
                          value: localOptOut,
                          onChanged: (val) {
                            setModalState(() => localOptOut = val);
                          },
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              _setPrivacyConsentAccepted(false);
                              Navigator.of(dialogContext).pop();
                            },
                            child: const Text(
                              'Show Banner Again',
                              style: TextStyle(
                                color: Color(0xFF5C4B51),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _optOutMarketingPartners = localOptOut;
                              });
                              _setPrivacyConsentAccepted(true);
                              Navigator.of(dialogContext).pop();
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    localOptOut
                                        ? 'Your opt-out preference ("Do not sell or share my personal information") has been saved.'
                                        : 'Your privacy choices have been saved.',
                                  ),
                                  backgroundColor: const Color(0xFF2B2B2B),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B2B2B),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 14,
                              ),
                            ),
                            child: const Text(
                              'Save & Continue',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// SECTION 5G: "The Friendship Hub" (Sub-Navbar + Wavy Cloud Frame Hero + 4 Friendship Guides + Dark Slate Footer)
  Widget _buildFriendshipHubSection(BuildContext context, bool isDesktop) {
    final friendshipArticles = [
      (
        title: 'How to Make New Friends',
        excerpt:
            'As humans, we naturally seek companionship, but knowing how to make friends isn’t easy. As connected as we are, it can be difficult to form genuine, long lasting relationships. Add on the day-to-day stresses of work, family, and everything in between, and suddenly it seems impossible to find the time to find friends. So, how ...',
        imageUrl:
            'https://images.unsplash.com/photo-1543807535-eceef0bc6599?auto=format&fit=crop&w=800&q=80',
        fullBody:
            'Making new friends as an adult starts with showing up where like-minded people gather—whether that’s an AFF (Aviaj Friends Forever) Departure Circle, a weekend hiking trek in Manali or Yosemite, or a neighborhood coffee club. Start with specific shared activities rather than open-ended plans, follow up within 48 hours after a great conversation, and treat consistency as the secret ingredient to turning a new connection into a lifelong friend.',
      ),
      (
        title: 'Apps to Make Friends',
        excerpt:
            'Thought apps were just for making romantic connections? Think again. Our users begged us to create a friendship-finding app—and we listened. Whether you’re new to a city or looking to expand your social circle, Aviaj For Friends (AFF) is a fast-track way to create platonic connections and find new friends with similar hobbies and interests. Read ...',
        imageUrl:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80',
        fullBody:
            'AFF (Aviaj Friends Forever) was built from the ground up for platonic connections. Create a dedicated friendship profile highlighting your weekend plans, favorite travel destinations, and community interests. Use Departure Plans to organize group meetups or join local Community Leaders hosting events across your city.',
      ),
      (
        title: 'How to Deal with Having No Friends',
        excerpt:
            'There are billions of people on the planet, and yet so many of us feel lonely. If you have no friends and are wondering what to do, we have some insight for you. Whether you’ve moved to a new city or are looking to expand your friendship group, we created Aviaj For Friends (AFF) to help you ...',
        imageUrl:
            'https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&w=800&q=80',
        fullBody:
            'Feeling isolated after relocating, graduating, or changing routines is one of the most universal human experiences. Instead of pressuring yourself to build an entire social circle overnight, focus on one low-stakes micro-connection at a time—like joining a local creative workshop, a group trek, or an AFF interest circle where everyone in the room is also looking to meet new people.',
      ),
      (
        title: 'What is the Safest Way to Make Friends Online',
        excerpt:
            'Many of us spend a lot of time online, so it makes sense that we might try to meet new friends there too. While the internet and apps have opened up a world of possibilities, unfortunately, there is a darker side to logging on. Your safety is a priority, which is why we’ve drawn up ...',
        imageUrl:
            'https://images.unsplash.com/photo-1588196749597-9ff075ee6b5b?auto=format&fit=crop&w=800&q=80',
        fullBody:
            'When meeting new friends online, always look for Photo & ID Verification badges on Aviaj, keep initial conversations inside the app, and use Aviaj Video Calls to say hello before meeting in person. For your first meetup, pick a lively public café or daytime group activity and share your live itinerary with a trusted contact.',
      ),
    ];

    return Column(
      children: [
        // 1. Full-Bleed Brand Banner with Wavy / Scalloped Cloud Frame ("The Friendship Hub")
        Container(
          width: double.infinity,
          color: AviajTheme.loveRed,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 72 : 20,
            vertical: isDesktop ? 52 : 32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: SizedBox(
                height: isDesktop ? 470 : 320,
                width: double.infinity,
                child: ClipPath(
                  clipper: const _WavyFriendshipFrameClipper(),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AviajNetworkImage(
                        imageUrl:
                            'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=1400&q=85',
                        width: double.infinity,
                        height: double.infinity,
                        fallbackLabel: 'The Friendship Hub',
                      ),
                      Container(
                        color: Colors.black.withValues(alpha: 0.24),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'The Friendship Hub',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 64 : 36,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.6,
                              height: 1.05,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // 3. 4-Column Friendship Editorial Article Cards Grid
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 48 : 20,
            vertical: isDesktop ? 68 : 44,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: friendshipArticles.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final article = entry.value;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right:
                                  idx < friendshipArticles.length - 1 ? 22 : 0,
                            ),
                            child: _buildFriendshipHubGuideCard(
                              context,
                              title: article.title,
                              excerpt: article.excerpt,
                              imageUrl: article.imageUrl,
                              fullBody: article.fullBody,
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : Column(
                      children: friendshipArticles.map((article) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _buildFriendshipHubGuideCard(
                            context,
                            title: article.title,
                            excerpt: article.excerpt,
                            imageUrl: article.imageUrl,
                            fullBody: article.fullBody,
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFriendshipHubGuideCard(
    BuildContext context, {
    required String title,
    required String excerpt,
    required String imageUrl,
    required String fullBody,
  }) {
    return InkWell(
      onTap: () => _openFriendshipHubGuideModal(
        context,
        title: title,
        imageUrl: imageUrl,
        excerpt: excerpt,
        fullBody: fullBody,
      ),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFDFCF5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: AviajNetworkImage(
                imageUrl: imageUrl,
                height: 245,
                width: double.infinity,
                fallbackLabel: title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      height: 1.32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    excerpt,
                    style: const TextStyle(
                      color: Color(0xFF2B2B2B),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      height: 1.54,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.only(bottom: 2),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFF8C8C8C),
                          width: 1,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Read more',
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFriendshipHubGuideModal(
    BuildContext context, {
    required String title,
    required String imageUrl,
    required String excerpt,
    required String fullBody,
  }) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        AviajNetworkImage(
                          imageUrl: imageUrl,
                          height: 300,
                          width: double.infinity,
                          fallbackLabel: title,
                        ),
                        Positioned(
                          top: 14,
                          right: 14,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AviajTheme.loveRed,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'THE FRIENDSHIP HUB • AFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            title,
                            style: const TextStyle(
                              color: Color(0xFF1E1E1E),
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            excerpt.replaceAll(' ...', '.'),
                            style: const TextStyle(
                              color: Color(0xFF2B2B2B),
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            fullBody,
                            style: const TextStyle(
                              color: Color(0xFF2B2B2B),
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// SECTION 5H: "Seasonal Dating Guides" (Sub-Navbar + Forest Hiking Hero + Intro + Winter / Spring / Summer 4-Card Grids)
  Widget _buildSeasonalDatingGuidesSection(
    BuildContext context,
    bool isDesktop,
  ) {
    final winterGuides = [
      (
        title: '12 Fun Things to Do as a Couple',
        excerpt:
            'Spending quality time with each other is what keeps relationships strong. Whether you’re in the early days of dating or years into a marriage, finding new and exciting things to do as a couple can keep the spark alive. To inspire you, here’s a list of date ideas for you and your partner. 1. Cooking ...',
        imageUrl:
            'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?auto=format&fit=crop&w=800&q=80',
        fullBody:
            '1. Take a regional cooking class together. 2. Plan a spontaneous weekend winter trek in Manali or Aspen. 3. Shoot a roll of vintage film on a frosty morning walk. 4. Host a two-person board game tournament with mulled cider.',
      ),
      (
        title: '9 Cozy Date Ideas',
        excerpt:
            'Winter is the perfect excuse to cancel your plans and stay indoors. Sure, frosty strolls have their charm, but let’s be real—snuggling up on the couch with a mug of cocoa takes cozy to a whole new level. To give you some inspo, we’ve created a list of intimate, cozy date ideas that keep the ...',
        imageUrl:
            'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=800&q=80',
        fullBody:
            'From building an indoor reading nook with artisanal hot chocolate to curating a vinyl listening night or planning your next Aviaj spring getaway together from the couch, cozy dates create space for unhurried conversation.',
      ),
      (
        title: 'Snow date ideas',
        excerpt:
            'Everyone knows the best rom-coms are the winter ones. From cozying up with hot cocoa to helping each other learn how to ice-skate, snow makes the perfect backdrop for romance. Winter dates feel extra special, especially when you’re first getting to know the person. Here are ten snow date ideas that give you the perfect ...',
        imageUrl:
            'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?auto=format&fit=crop&w=800&q=80',
        fullBody:
            'Whether you’re gliding across an outdoor ice rink, riding an illuminated winter carousel, or trekking snow-dusted trails in Solang Valley or Kedarkantha, snow dates turn simple moments into cinematic memories.',
      ),
      (
        title: 'Birthday Date Ideas',
        excerpt:
            'Summer birthdays bring the heat, but winter birthdays are where the real magic happens. There are plenty of cozy ways you can make someone’s special day unforgettable—even in the chilliest months. Here are seven winter-themed birthday date ideas straight out of your favorite rom-com. 1. Visit a festive market Wrap up warm and take your ...',
        imageUrl:
            'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?auto=format&fit=crop&w=800&q=80',
        fullBody:
            '1. Visit a festive twilight market. 2. Book a scenic lakeside or mountain overlook picnic with thermoses of spiced tea. 3. Surprise them with tickets to a candlelit acoustic concert or weekend cabin escape.',
      ),
    ];

    final springGuides = [
      (
        title: 'Why VR Gaming Makes for an Incredible Date Night',
        excerpt:
            'Looking for new ideas for date nights? Virtual reality (VR) gaming could be just the twist you need. It really is as fun as it sounds: You and your partner explore new worlds, solve puzzles, and compete in exciting challenges, all from your living room or a local VR arcade. VR dates bring something different ...',
        imageUrl:
            'https://images.unsplash.com/photo-1592478411213-6153e4ebc07d?auto=format&fit=crop&w=800&q=80',
        fullBody:
            'VR gaming breaks the ice immediately by putting both of you into a collaborative adventure—whether you’re solving escape-room puzzles in zero gravity or exploring virtual destinations before booking your next real-world trip on Aviaj.',
      ),
      (
        title: 'How to Pick the Perfect Dessert Wine Pairing for Date Night',
        excerpt:
            'Interested in the art of dessert wine pairing and want to make your next date night one to remember? Whether you’re planning a laid-back evening of learning together or aiming to dazzle a date with your wine-pairing knowledge, we’ve got your back. We’re here to demystify dessert wines and how to match them with different ...',
        imageUrl:
            'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?auto=format&fit=crop&w=800&q=80',
        fullBody:
            'Rule number one of dessert wine pairing: the wine should always be slightly sweeter than the dessert itself. Pair late-harvest Riesling with fruit tarts, Tawny Port with dark chocolate truffles, or Moscato d’Asti with fresh berries.',
      ),
      (
        title: 'The Ultimate Guide to Skydiving Dates',
        excerpt:
            'You’re plummeting from the sky, the wind’s a wild rush in your ears, and your heart is beating harder than ever. If that’s your idea of a great way to get to know someone and test romantic connections, a skydiving date may be made for you. Whether you’re up for the real thrill of jumping ...',
        imageUrl:
            'https://images.unsplash.com/photo-1521673252667-e05da380b252?auto=format&fit=crop&w=800&q=80',
        fullBody:
            'Nothing bonds two people faster than shared adrenaline. Whether you choose outdoor tandem skydiving over the coast or an indoor vertical wind tunnel session followed by brunch, high-thrill dates create unforgettable stories.',
      ),
      (
        title:
            'Date Night at the Museum: Why Scavenger Hunts Beat Dinner and a Movie',
        excerpt:
            'A museum scavenger hunt turns a regular museum visit into a fun adventure. Whether you follow a museum’s pre-set hunt or design your own, it’s a fun, competitive quest that adds excellent conversation starters and fun competition to your date. What’s a museum scavenger hunt? You and your date use a list of clues or ...',
        imageUrl:
            'https://images.unsplash.com/photo-1518998053901-5348d3961a04?auto=format&fit=crop&w=800&q=80',
        fullBody:
            'Create a list of playful prompts—like “Find a portrait that looks like your reaction on Monday morning” or “Spot the most dramatic sculpture in the wing”—and compare your discoveries over espresso in the museum courtyard.',
      ),
    ];

    final summerGuides = [
      (
        title: 'Your Guide to Summer Road Trip Quest Dates',
        excerpt:
            'Are you thinking about taking a date on a summer road trip? Here’s how to turn the hours spent in the car into something memorable. Summer road trip quests ...',
        imageUrl:
            'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=800&q=80',
        fullBody:
            'Trade GPS highways for scenic coastal backroads—from Goa’s Cabo de Rama cliffs to California’s Highway 1. Alternate DJ duties every 30 minutes, stop at roadside fruit stands, and let spontaneous detours lead the day.',
      ),
      (
        title: 'Why Calligraphy Workshops Are the Next Big Date Night Trend',
        excerpt:
            'In a digital world, calligraphy workshops are a beautiful way to help you connect with a date in a unique, creative way. As you and your partner try out the craft, you’ll bond over the shared experience ...',
        imageUrl:
            'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=800&q=80',
        fullBody:
            'Tactile creative dates slow down the pace of modern dating. Learning brush lettering or fountain-pen calligraphy side by side gives you something fun to focus on while conversation flows naturally.',
      ),
      (
        title: 'Summer Date Styles: What to Wear to Keep Cool and Look Hot',
        excerpt:
            'Summer’s the time to make new connections and enjoy the outdoors, but nailing comfort and style can be tricky. Whether you’re prepping for a coffee catch-up or an adventure in the sun, ...',
        imageUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
        fullBody:
            'Breathable linen layers, relaxed cotton silhouettes, and polarized sunglasses keep you comfortable from golden-hour rooftop drinks to sunset beach walks in Andaman, Ibiza, or Maui.',
      ),
      (
        title: 'Take Your Date on a Hot Air Balloon Ride',
        excerpt:
            'Whether you’re looking for a fancy date night or a new way to connect, a hot air balloon ride is a great way to create lasting memories together. A hot air balloon date is one of those experiences you won’t forget—think romance, ...',
        imageUrl:
            'https://images.unsplash.com/photo-1507608616759-54f48f0af0ee?auto=format&fit=crop&w=800&q=80',
        fullBody:
            'Drifting above valleys and coastlines at sunrise in a hot air balloon offers 360-degree views and serene quiet that make milestone anniversaries and third dates alike feel extraordinary.',
      ),
    ];

    Widget buildSeasonBlock(
      String seasonTitle,
      List<({String title, String excerpt, String imageUrl, String fullBody})>
          guides,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            seasonTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: isDesktop ? 40 : 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 24),
          isDesktop
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: guides.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final guide = entry.value;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: idx < guides.length - 1 ? 22 : 0,
                          ),
                          child: _buildFriendshipHubGuideCard(
                            context,
                            title: guide.title,
                            excerpt: guide.excerpt,
                            imageUrl: guide.imageUrl,
                            fullBody: guide.fullBody,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : Column(
                  children: guides.map((guide) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 22),
                      child: _buildFriendshipHubGuideCard(
                        context,
                        title: guide.title,
                        excerpt: guide.excerpt,
                        imageUrl: guide.imageUrl,
                        fullBody: guide.fullBody,
                      ),
                    );
                  }).toList(),
                ),
        ],
      );
    }

    return Column(
      children: [
        // 1. Full-Bleed Forest Hiking Couple Hero Banner ("Seasonal\nDating Guides")
        SizedBox(
          width: double.infinity,
          height: isDesktop ? 560 : 400,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AviajNetworkImage(
                imageUrl:
                    'https://images.unsplash.com/photo-1501555088652-021faa106b9b?auto=format&fit=crop&w=1600&q=85',
                width: double.infinity,
                height: double.infinity,
                fallbackLabel: 'Seasonal Dating Guides',
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.12),
                      Colors.black.withValues(alpha: 0.52),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    24,
                    24,
                    isDesktop ? 54 : 32,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 920),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seasonal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 40 : 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          'Dating Guides',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 98 : 48,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -2.8,
                            height: 0.96,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 3. White Editorial Intro Block
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 72 : 24,
            vertical: isDesktop ? 68 : 44,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 660),
              child: const Text(
                'At Aviaj, we want to support you through every milestone in your dating life—from your first meet-up to nights sitting on the couch together, eating chips in your sweats. So our dating experts have created these seasonal guides to help you plan the perfect date, no matter when, where, or who you’re dating. Check the seasons below and find your next date idea!',
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 16.5,
                  fontWeight: FontWeight.w500,
                  height: 1.54,
                ),
              ),
            ),
          ),
        ),

        // 4. Rounded-Top Full-Width Seasonal Canvas with Winter, Spring, and Summer 4-Column Grids
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AviajTheme.loveRed,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(36),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 56 : 20,
              vertical: isDesktop ? 64 : 44,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSeasonBlock('Winter', winterGuides),
                    SizedBox(height: isDesktop ? 64 : 44),
                    buildSeasonBlock('Spring', springGuides),
                    SizedBox(height: isDesktop ? 64 : 44),
                    buildSeasonBlock('Summer', summerGuides),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// SECTION 5I: "Aviaj Safety Center" ("Your safety comes first, always" Hero + 8 Illustrated Safety Feature Cards)
  Widget _buildSafetyCenterSection(BuildContext context, bool isDesktop) {
    final pack = widget.state.regionalPack;
    final safetyCards = [
      (
        title: 'Photo Verification',
        subtitle:
            'A quick photo to verify the person you’re chatting with is real.',
        graphic: _buildPhotoVerificationGraphic(pack),
        detailBody:
            'Aviaj Photo Verification combines real-time liveness selfie prompts with automated AI and human moderation so you can be confident your match looks like their profile photos before you ever say hello.',
      ),
      (
        title: 'ID Verification and Verified badge',
        subtitle:
            'Add an extra layer of trust by confirming your identity with a verified badge.',
        graphic: _buildIdVerificationGraphic(pack),
        detailBody:
            'Verify your government-issued ID in seconds to display the official blue “ID verified” badge on your profile—giving matches and AFF travel companions peace of mind when planning trips together.',
      ),
      (
        title: '‘Review Before You Send’ prompt',
        subtitle:
            'A gentle nudge to rethink messages that may come across the wrong way.',
        graphic: _buildReviewBeforeYouSendGraphic(pack),
        detailBody:
            'Our on-device language model detects potentially harmful or disrespectful phrasing before a message is sent, prompting the sender to edit their message and keeping conversations respectful.',
      ),
      (
        title: 'Private Detector',
        subtitle:
            'Explicit photos are blurred automatically, so you choose what you see.',
        graphic: _buildPrivateDetectorGraphic(pack),
        detailBody:
            'Private Detector™ automatically blurs unsolicited explicit images in chat and alerts you first, letting you decide whether to view, delete, or block and report the sender in one tap.',
      ),
      (
        title: 'Deception Detector™',
        subtitle:
            'AI works in the background to spot fake or scam accounts before you do.',
        graphic: _buildDeceptionDetectorGraphic(pack),
        detailBody:
            'Deception Detector™ uses machine-learning behavioral signals to block 95% of spam, scam, and automated fake profiles before they ever appear in your swipe deck or Departure Circles.',
      ),
      (
        title: 'In-app voice and video calls',
        subtitle:
            'Chat face-to-face or by voice without needing to give out your number.',
        graphic: _buildInAppCallsGraphic(pack),
        detailBody:
            'Catch a vibe check from the comfort of home using built-in HD voice and video calls inside Aviaj—no phone number, social handle, or personal contact details required.',
      ),
      (
        title: 'Share Date',
        subtitle:
            'Easily share your date details with a trusted friend or family member, right from the app.',
        graphic: _buildSafeDateChatGraphic(pack),
        detailBody:
            'Going on a date? Share Date lets you send who you’re meeting, where you’re going, and when you’re meeting directly to a trusted friend or family member in seconds.',
      ),
      (
        title: 'Block, Report and Unmatch',
        subtitle:
            'Simple tools to remove or report anyone who makes you uncomfortable.',
        graphic: _buildBlockAndReportGraphic(),
        detailBody:
            'If someone ever makes you feel uncomfortable, you can unmatch, block, or confidentially report them in one tap—they won’t be notified and won’t see your profile.',
      ),
    ];

    return Column(
      children: [
        // 1. Full-Bleed Warm Restaurant / Café Couple Hero Banner ("Your safety comes first, always")
        SizedBox(
          width: double.infinity,
          height: isDesktop ? 560 : 400,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AviajNetworkImage(
                imageUrl:
                    'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?auto=format&fit=crop&w=1600&q=85',
                width: double.infinity,
                height: double.infinity,
                fallbackLabel: 'Aviaj Safety Center',
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.36),
                      Colors.black.withValues(alpha: 0.56),
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _langPack.safetyHeroTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 64 : 36,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.8,
                            height: 1.06,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _langPack.safetyHeroSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 17.5 : 14.5,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 2. "Safety features" Heading + 8 Illustrated Safety Cards + "Learn more" Safety Handbook + "Safety alert" / "Support and resources" + "Safety partnerships"
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 64 : 20,
            vertical: isDesktop ? 76 : 48,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Safety features',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF1E1E1E),
                      fontSize: isDesktop ? 58 : 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.8,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Safety features designed to protect and empower you throughout your dating journey.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3A3A3A),
                      fontSize: 16.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 44),
                  Wrap(
                    spacing: 26,
                    runSpacing: 26,
                    children: safetyCards.map((card) {
                      final cardWidth = isDesktop ? 575.0 : double.infinity;
                      return SizedBox(
                        width: cardWidth,
                        child: _buildSafetyFeatureIllustratedCard(
                          context,
                          title: card.title,
                          subtitle: card.subtitle,
                          graphic: card.graphic,
                          detailBody: card.detailBody,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 36),
                  // 3. "Learn more" Safety Handbook Split Card ("View our Safety Handbook" + Outdoor Couple Photo)
                  _buildSafetyHandbookBanner(context, isDesktop),

                  const SizedBox(height: 26),
                  // 4. 2-Column Grey Callout Cards ("Safety alert" & "Support and resources")
                  _buildSafetyAlertAndResourcesRow(context, isDesktop),

                  const SizedBox(height: 76),
                  // 5. "Safety partnerships" Header + "Scroll to explore →" + 4-Card Carousel
                  _buildSafetyPartnershipsSection(context, isDesktop),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyFeatureIllustratedCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget graphic,
    required String detailBody,
  }) {
    return InkWell(
      onTap: () => _openSafetyFeatureModal(
        context,
        title: title,
        subtitle: subtitle,
        detailBody: detailBody,
      ),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AviajTheme.loveRed,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 290,
                width: double.infinity,
                child: graphic,
              ),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.7,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w500,
                      height: 1.44,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Learn More',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Card 1 Mockup: Photo Verification (Viewfinder frame + "✓ Photo verified" sparkle badge)
  Widget _buildPhotoVerificationGraphic(AviajRegionalContentPack pack) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AviajNetworkImage(
          imageUrl:
              'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?auto=format&fit=crop&w=900&q=85',
          width: double.infinity,
          height: 290,
          fallbackLabel: 'Photo Verification',
        ),
        // Soft side vignettes outside the face viewfinder
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ),
            const SizedBox(width: 210),
            Expanded(
              child: Container(
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ),
          ],
        ),
        // Centered White Viewfinder Outline Frame
        Center(
          child: Container(
            width: 210,
            height: 245,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 2.2),
            ),
          ),
        ),
        // Bottom-left "✓ Photo verified" pill with 4-point sparkle
        Positioned(
          left: 64,
          bottom: 24,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF242424).withValues(alpha: 0.90),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.6),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Photo verified',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Positioned(
                left: 14,
                top: -12,
                child: CustomPaint(
                  size: Size(22, 22),
                  painter: _SafetySparkleStarPainter(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Card 2 Mockup: ID Verification and Verified badge (5 fanned cards + center phone mockup + blue "✓ ID verified" pills)
  Widget _buildIdVerificationGraphic(AviajRegionalContentPack pack) {
    Widget buildSideCard(String imageUrl, double height) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 76,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AviajNetworkImage(
                imageUrl: imageUrl,
                width: 76,
                height: height,
                fallbackLabel: 'ID Verified',
              ),
              Positioned(
                left: 5,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4267E8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        color: Colors.white,
                        size: 9,
                      ),
                      SizedBox(width: 3),
                      Text(
                        'ID verified',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 7.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: const Color(0xFFFAF9F5),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildSideCard(pack.profiles[1].imageUrl, 165),
                const SizedBox(width: 6),
                buildSideCard(pack.profiles[2].imageUrl, 195),
                const SizedBox(width: 175),
                buildSideCard(pack.profiles[3].imageUrl, 195),
                const SizedBox(width: 6),
                buildSideCard(pack.profiles[4].imageUrl, 165),
              ],
            ),
          ),
          // Center Smartphone Mockup ("Aviaj" + "Tiana, 30")
          Container(
            width: 172,
            height: 274,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border.all(color: const Color(0xFF1E1E1E), width: 2.2),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                  child: Row(
                    children: [
                      const Text(
                        'Aviaj',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.tune_rounded,
                        size: 14,
                        color: Colors.grey.shade800,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AviajNetworkImage(
                            imageUrl: pack.profiles[0].imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fallbackLabel: 'Tiana, 30',
                          ),
                          Positioned(
                            left: 10,
                            bottom: 10,
                            child: Text(
                              '${pack.profiles[0].name.split(' ').first}, ${pack.profiles[0].age}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card 3 Mockup: 'Review Before You Send' prompt
  Widget _buildReviewBeforeYouSendGraphic(AviajRegionalContentPack pack) {
    return Container(
      color: const Color(0xFFE9E9E9),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Phone frame
          Container(
            width: 215,
            height: 255,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(26),
              ),
              border: Border.all(color: const Color(0xFF1E1E1E), width: 2),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.chevron_left_rounded, size: 18),
                      ClipOval(
                        child: AviajNetworkImage(
                          imageUrl: pack.profiles[1].imageUrl,
                          width: 20,
                          height: 20,
                          fallbackLabel: 'M',
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Matt',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.videocam_outlined, size: 15),
                      const SizedBox(width: 6),
                      const Icon(Icons.more_vert_rounded, size: 15),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: 180,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF242424),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text(
                    'Edit message',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Send anyway',
                  style: TextStyle(
                    color: Color(0xFF3A3A3A),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
          // Overlapping "Your message" nudge card
          Positioned(
            top: 82,
            child: Container(
              width: 256,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AviajTheme.loveRed,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your message',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'This is an inappropriate message\nthat I am sending',
                      style: TextStyle(
                        color: Color(0xFF2B2B2B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Card 4 Mockup: Private Detector ("This might be explicit" blurred photo preview)
  Widget _buildPrivateDetectorGraphic(AviajRegionalContentPack pack) {
    return Container(
      color: const Color(0xFFE9E9E9),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 225,
          height: 255,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(26),
            ),
            border: Border.all(color: const Color(0xFF1E1E1E), width: 2),
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.chevron_left_rounded, size: 18),
                  ClipOval(
                    child: AviajNetworkImage(
                      imageUrl: pack.profiles[2].imageUrl,
                      width: 20,
                      height: 20,
                      fallbackLabel: 'M',
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Marco',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.videocam_outlined, size: 15),
                  const SizedBox(width: 6),
                  const Icon(Icons.more_vert_rounded, size: 15),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Hello!',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AviajTheme.loveRed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'How are you?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Blurred Explicit Warning Box
              Container(
                width: 108,
                height: 126,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF5D6B57),
                      Color(0xFF8C7B70),
                      Color(0xFF475245),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const CustomPaint(
                        size: Size(24, 24),
                        painter: _SafetyProhibitedPainter(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This might be\nexplicit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Card 5 Mockup: Deception Detector™ (4x2 Grid of real portraits + blocked spam silhouette tiles)
  Widget _buildDeceptionDetectorGraphic(AviajRegionalContentPack pack) {
    Widget buildRealTile(String url) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AviajNetworkImage(
          imageUrl: url,
          width: double.infinity,
          height: double.infinity,
          fallbackLabel: 'Verified User',
        ),
      );
    }

    Widget buildBlockedSpamTile() {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFEA79),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const CustomPaint(
              size: Size(92, 92),
              painter: _SafetySpamSilhouettePainter(),
            ),
            Positioned(
              right: 16,
              bottom: 12,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD43B),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 11,
                  height: 2.6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF242424),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(6),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: buildRealTile(pack.profiles[0].imageUrl)),
                const SizedBox(width: 6),
                Expanded(child: buildRealTile(pack.profiles[1].imageUrl)),
                const SizedBox(width: 6),
                Expanded(child: buildBlockedSpamTile()),
                const SizedBox(width: 6),
                Expanded(child: buildRealTile(pack.profiles[2].imageUrl)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Row(
              children: [
                Expanded(child: buildBlockedSpamTile()),
                const SizedBox(width: 6),
                Expanded(child: buildRealTile(pack.profiles[3].imageUrl)),
                const SizedBox(width: 6),
                Expanded(child: buildRealTile(pack.profiles[4].imageUrl)),
                const SizedBox(width: 6),
                Expanded(child: buildBlockedSpamTile()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card 6 Mockup: In-app voice and video calls
  Widget _buildInAppCallsGraphic(AviajRegionalContentPack pack) {
    return Container(
      color: const Color(0xFFE9E9E9),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Phone frame with video call portrait
          Container(
            width: 265,
            height: 290,
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: const BorderSide(color: Color(0xFF1E1E1E), width: 3),
              ),
            ),
            child: AviajNetworkImage(
              imageUrl: pack.profiles[1].imageUrl,
              width: 265,
              height: 290,
              fallbackLabel: 'In-app Video Call',
            ),
          ),
          // Floating white chat/call input pill bar
          Positioned(
            bottom: 62,
            child: Container(
              width: 380,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.camera_alt_outlined,
                    size: 20,
                    color: Color(0xFF1E1E1E),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Send a message...',
                      style: TextStyle(
                        color: Color(0xFF5A5A5A),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF1E1E1E),
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'GIF',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '99',
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const CustomPaint(
                    size: Size(48, 20),
                    painter: _SafetyCallBarIconsPainter(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Card 7 Mockup: Share Date ("Shall we go on a coffee date?" / "Yes, that sounds lovely" + "Going on a date with Matt?" card)
  Widget _buildSafeDateChatGraphic(AviajRegionalContentPack pack) {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 26,
            bottom: 28,
            child: Transform.rotate(
              angle: -0.04,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AviajNetworkImage(
                  imageUrl: pack.profiles[2].imageUrl,
                  width: 148,
                  height: 195,
                  fallbackLabel: 'Coffee Date',
                ),
              ),
            ),
          ),
          Positioned(
            left: 148,
            bottom: 14,
            child: Transform.rotate(
              angle: 0.025,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AviajNetworkImage(
                  imageUrl: pack.profiles[3].imageUrl,
                  width: 148,
                  height: 185,
                  fallbackLabel: 'Coffee Date',
                ),
              ),
            ),
          ),
          Positioned(
            left: 98,
            top: 32,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AviajTheme.loveRed,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Shall we go on a coffee date?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Positioned(
            left: 122,
            top: 68,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'Yes, that sounds lovely',
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          // Overlapping "Going on a date with Matt?" Share Date card on the right
          Positioned(
            right: 22,
            bottom: 24,
            child: Container(
              width: 232,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AviajTheme.loveRed,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Going on a date with Matt?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'You can share the date details to let a friend know who you’re meeting, where and when.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.2,
                      fontWeight: FontWeight.w500,
                      height: 1.32,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF242424),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Try Share Date',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 1.1),
                    ),
                    child: const Text(
                      'Not now',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Card 8 Mockup: Block, Report and Unmatch (Phone `9:41` status bar + 3 action circles ✕ / ★ / ✓ + "Block and Report" + "Recommend to a friend")
  Widget _buildBlockAndReportGraphic() {
    return Container(
      color: const Color(0xFFE9E9E9),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 245,
          height: 255,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(26),
            ),
            border: Border.all(color: const Color(0xFF1E1E1E), width: 2),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    '9:41',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.signal_cellular_alt_rounded, size: 13),
                  SizedBox(width: 4),
                  Icon(Icons.wifi_rounded, size: 13),
                  SizedBox(width: 4),
                  Icon(Icons.battery_full_rounded, size: 13),
                ],
              ),
              const SizedBox(height: 10),
              // 3 circular action icons arranged in an arc (✕, ★, ✓)
              SizedBox(
                height: 92,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 0,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: AviajTheme.loveRed,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const CustomPaint(
                          size: Size(24, 24),
                          painter: _SafetyStarBadgePainter(),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 4,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AviajTheme.loveRed,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 4,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AviajTheme.loveRed,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Block and Report',
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFFBDBDBD),
                    width: 1.1,
                  ),
                ),
                child: const Text(
                  'Recommend to a friend',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// "Learn more" — Safety Handbook Split Banner ("View our Safety Handbook" + Outdoor Couple Photo)
  Widget _buildSafetyHandbookBanner(BuildContext context, bool isDesktop) {
    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Learn more',
          style: TextStyle(
            color: const Color(0xFF1E1E1E),
            fontSize: isDesktop ? 56 : 36,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.6,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Our safety handbook provides clear guidance, tools, and resources—all in one place to support your safety.',
          style: TextStyle(
            color: Color(0xFF2B2B2B),
            fontSize: 16.5,
            fontWeight: FontWeight.w500,
            height: 1.48,
          ),
        ),
        const SizedBox(height: 28),
        InkWell(
          onTap: () => _openSafetyFeatureModal(
            context,
            title: 'Aviaj Safety Handbook',
            subtitle:
                'Clear guidance, tools, and resources—all in one place to support your safety before, during, and after every connection.',
            detailBody:
                '1. Keep conversations on Aviaj while getting to know someone.\n2. Use Photo Verification, ID Verification, and In-app Video Calls before meeting IRL.\n3. Always meet in a public place and use Share Date to send your live itinerary to a trusted friend or family member.\n4. Trust your instincts—you can Unmatch, Block, and Report anyone at any time.',
          ),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF242424),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'View our Safety Handbook',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );

    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AviajNetworkImage(
        imageUrl:
            'https://images.unsplash.com/photo-1516589091380-5d8e87df6999?auto=format&fit=crop&w=1000&q=85',
        width: double.infinity,
        height: isDesktop ? 480 : 300,
        fallbackLabel: 'Aviaj Safety Handbook',
      ),
    );

    return Container(
      padding: EdgeInsets.all(isDesktop ? 40 : 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(28),
      ),
      child: isDesktop
          ? SizedBox(
              height: 480,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 11,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 40,
                        bottom: 24,
                      ),
                      child: textColumn,
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: imageWidget,
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageWidget,
                const SizedBox(height: 24),
                textColumn,
              ],
            ),
    );
  }

  /// 2-Column Grey Callout Cards ("Safety alert" & "Support and resources")
  Widget _buildSafetyAlertAndResourcesRow(
    BuildContext context,
    bool isDesktop,
  ) {
    final safetyAlertCard = Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Safety alert',
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.7,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Aviaj does not offer emergency response services. If you or someone you know is in immediate danger, please call your local emergency number.',
            style: TextStyle(
              color: Color(0xFF2B2B2B),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );

    final supportResourcesCard = InkWell(
      onTap: () => _openSafetyFeatureModal(
        context,
        title: 'Aviaj Help Center & Safety Support',
        subtitle:
            '24/7 guidance on using Aviaj, staying safe online, and troubleshooting your account.',
        detailBody:
            'Need assistance with Photo Verification, ID Verification, reporting a profile, or managing your privacy preferences? Our global Safety & Support specialists review reports 24/7 and provide dedicated resources for every region.',
      ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Support and resources',
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.7,
              ),
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                style: const TextStyle(
                  color: Color(0xFF2B2B2B),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text:
                        'For more information on using Aviaj, staying safe online, or troubleshooting, please visit our ',
                  ),
                  TextSpan(
                    text: 'Help Center',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (isDesktop) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: safetyAlertCard),
            const SizedBox(width: 26),
            Expanded(child: supportResourcesCard),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        safetyAlertCard,
        const SizedBox(height: 18),
        supportResourcesCard,
      ],
    );
  }

  /// "Safety partnerships" Section Header + "Scroll to explore →" + 4-Card Horizontal Carousel
  Widget _buildSafetyPartnershipsSection(BuildContext context, bool isDesktop) {
    final partners = [
      (
        title: 'Bloom powered by Chayn',
        description:
            'In 2024 we announced Bloom, an industry-first partnership with Chayn to provide free online trauma support to members of our global community who experience sexual assault or relationship abuse.',
        logoWidget: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              'bloom',
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
      (
        title: 'National Domestic Violence Hotline',
        description:
            'Since 2020, Aviaj has partnered with the National Domestic Violence Hotline, an Austin, Texas-based organization dedicated to preventing relationship abuse and supporting those affected by it.',
        logoWidget: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF1E1E1E), width: 1.2),
          ),
          alignment: Alignment.centerLeft,
          child: const Text(
            'NATIONAL\nDOMESTIC\nVIOLENCE\nHOTLINE',
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 7.2,
              fontWeight: FontWeight.w900,
              height: 1.12,
            ),
          ),
        ),
      ),
      (
        title: 'Refuge UK',
        description:
            'United by our shared vision to tackle technology-facilitated abuse and gender-based violence, Aviaj has partnered with the UK’s largest domestic abuse organization, Refuge, since 2023.',
        logoWidget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Refuge',
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                width: 44,
                height: 1.5,
                color: const Color(0xFF1E1E1E),
              ),
              const SizedBox(height: 3),
              const Text(
                'For women and children\nagainst domestic violence',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 5.5,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
      (
        title: 'Survivor Hub',
        description:
            'The Survivor Hub is an Australian survivor-led initiative which harnesses collective knowledge and lived experience to support, inform and empower people impacted by sexual assault.',
        logoWidget: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF1E1E1E), width: 1.2),
          ),
          alignment: Alignment.center,
          child: const Text(
            'THE\nSURVIVOR\nHUB',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 6.8,
              fontWeight: FontWeight.w800,
              height: 1.12,
            ),
          ),
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Safety partnerships',
                style: TextStyle(
                  color: const Color(0xFF1E1E1E),
                  fontSize: isDesktop ? 56 : 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.6,
                  height: 1.05,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (!_safetyPartnersScrollController.hasClients) return;
                final maxScroll =
                    _safetyPartnersScrollController.position.maxScrollExtent;
                final current = _safetyPartnersScrollController.offset;
                final target = (current + 340) > maxScroll ? 0.0 : current + 340;
                _safetyPartnersScrollController.animateTo(
                  target,
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutCubic,
                );
              },
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Scroll to explore',
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFF242424),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 19,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),
        SingleChildScrollView(
          controller: _safetyPartnersScrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < partners.length; i++) ...[
                if (i > 0) const SizedBox(width: 24),
                InkWell(
                  onTap: () => _openSafetyFeatureModal(
                    context,
                    title: partners[i].title,
                    subtitle: 'Official Aviaj Global Safety Partner',
                    detailBody: partners[i].description,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 316,
                    height: 440,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AviajTheme.loveRed,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 82,
                          height: 82,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: partners[i].logoWidget,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          partners[i].title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Expanded(
                          child: Text(
                            partners[i].description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.2,
                              fontWeight: FontWeight.w500,
                              height: 1.44,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Learn More',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _openSafetyFeatureModal(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String detailBody,
  }) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AviajTheme.loveRed,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'AVIAJ SAFETY CENTER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF2B2B2B),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    detailBody,
                    style: const TextStyle(
                      color: Color(0xFF4A4A4A),
                      fontSize: 15,
                      height: 1.58,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF242424),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        'Got it',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// SECTION 5J: Aviaj Support / Help Center ("How can we help?" Hero + 3 Category Cards + "Popular topics" + "Safety Center" / "Support and resources" + Support Footer)
  Widget _buildSupportCenterSection(BuildContext context, bool isDesktop) {
    final categories = [
      (
        title: 'Finding love',
        subtitle:
            'Tips on matching, starting conversations, using Compliments, SuperSwipe, and Travel Mode.',
        body:
            '1. Complete your profile with 4–6 verified photos and authentic travel prompts.\n2. Use Compliments to share what caught your eye before matching.\n3. Turn on Travel Mode before your next trip to match with locals and fellow travelers ahead of arrival.\n4. Use In-app Video Calls to catch a quick vibe check from anywhere.',
      ),
      (
        title: 'Your profile',
        subtitle:
            'Manage your photos, prompts, verification badges, travel badges, and account settings.',
        body:
            '1. Tap Edit Profile to update your bio, Connection Intent (Travel Buddy, Romantic Date, or Local Host), and upcoming trips.\n2. Complete Photo Verification and ID Verification to earn your Verified badge.\n3. Switch between Date and AFF (Aviaj Friends Forever) anytime from your profile settings.',
      ),
      (
        title: 'Staying safe and secure',
        subtitle:
            'Everything you need to know about privacy controls, Incognito Mode, and reporting tools.',
        body:
            '1. Enable Incognito Mode so your profile is only visible to people you swipe right on.\n2. Private Detector™ automatically blurs unsolicited explicit images in chat.\n3. Use Share Date to send your live date details (who, where, and when) to a trusted friend or family member.\n4. Use Block, Report and Unmatch anytime—reports are 100% confidential.',
      ),
    ];

    final allTopics = [
      (
        title: 'Canceling subscriptions',
        subtitle: 'How to manage, upgrade, or cancel your Aviaj subscription.',
        body:
            'You can manage or cancel your Aviaj Explorer Plus or First Class VIP subscription at any time through your Apple App Store settings (iOS), Google Play Store subscriptions (Android), or directly from your Aviaj Web Account Billing portal. Your premium perks remain active through the end of your current billing cycle.',
      ),
      (
        title: 'Troubleshooting tips and current bugs',
        subtitle: 'Quick fixes for login, notifications, or connection issues.',
        body:
            'If the app feels slow or messages aren’t refreshing:\n• Check that you’re running the latest version of Aviaj from the App Store or Google Play.\n• Toggle Wi-Fi / cellular data or refresh your browser session.\n• Sign out and sign back in to resync your matches and Departure Circles.',
      ),
      (
        title: 'Verifying with your ID',
        subtitle: 'How to complete ID Verification and earn your Verified badge.',
        body:
            'Open your Aviaj profile settings and tap "ID Verification". Upload a valid government-issued photo ID and complete a quick live selfie check. Once confirmed, a blue "✓ ID verified" badge will appear on your profile.',
      ),
      (
        title: 'Our safety features',
        subtitle:
            'Explore Photo Verification, Private Detector, Deception Detector™, and Share Date.',
        body:
            'Aviaj combines automated AI protection (Deception Detector™ and Private Detector) with member-controlled tools (Photo & ID Verification, In-app Voice/Video Calls, Share Date, and 1-tap Block & Report) to keep every connection safe.',
      ),
      (
        title: 'Reporting someone',
        subtitle: 'How to confidentially block or report a profile or message.',
        body:
            'Tap the "•••" menu at the top of any profile or chat, or scroll to the bottom of a profile and select "Block and Report". Choose the reason for your report—the person will never be notified that you reported them, and our 24/7 Safety Team will review it immediately.',
      ),
      (
        title: 'Taking a break from online dating',
        subtitle: 'Pause your profile with Snooze Mode without losing your matches.',
        body:
            'Need a breather? Turn on Snooze Mode in Settings to hide your profile from discovery for 24 hours, 72 hours, a week, or indefinitely—while keeping all your existing matches and conversations intact.',
      ),
    ];

    final filteredTopics = _supportSearchQuery.trim().isEmpty
        ? allTopics
        : allTopics
              .where(
                (t) =>
                    t.title.toLowerCase().contains(
                      _supportSearchQuery.trim().toLowerCase(),
                    ) ||
                    t.subtitle.toLowerCase().contains(
                      _supportSearchQuery.trim().toLowerCase(),
                    ),
              )
              .toList();

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          // Main Support Center Body Container
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 64 : 20,
              vertical: isDesktop ? 24 : 16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 2. "How can we help?" Rounded Hero Card with Search Bar
                    Container(
                      height: isDesktop ? 365 : 290,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: AviajTheme.loveRed,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _langPack.supportHeroTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 64 : 38,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.8,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _langPack.supportHeroSubtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 28),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search_rounded,
                                    color: Color(0xFF2B2B2B),
                                    size: 21,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      onChanged: (val) {
                                        setState(() {
                                          _supportSearchQuery = val;
                                        });
                                      },
                                      style: const TextStyle(
                                        color: Color(0xFF1E1E1E),
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: _langPack.navSupport,
                                        hintStyle: const TextStyle(
                                          color: Color(0xFF6E6E6E),
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                  if (_supportSearchQuery.isNotEmpty)
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _supportSearchQuery = '';
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 18,
                                        color: Color(0xFF5A5A5A),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    // 3. 3 Category Cards Row ("Finding love", "Your profile", "Staying safe and secure")
                    if (isDesktop)
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (int i = 0; i < categories.length; i++) ...[
                              if (i > 0) const SizedBox(width: 24),
                              Expanded(
                                child: _buildSupportCategoryCard(
                                  context,
                                  title: categories[i].title,
                                  subtitle: categories[i].subtitle,
                                  body: categories[i].body,
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (int i = 0; i < categories.length; i++) ...[
                            if (i > 0) const SizedBox(height: 16),
                            _buildSupportCategoryCard(
                              context,
                              title: categories[i].title,
                              subtitle: categories[i].subtitle,
                              body: categories[i].body,
                            ),
                          ],
                        ],
                      ),

                    const SizedBox(height: 56),
                    // 4. "Popular topics" 2-Column Split Layout ("Popular\ntopics" + "Contact us" on left, 6 topic rows on right)
                    if (isDesktop)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: _buildPopularTopicsLeftColumn(context),
                          ),
                          const SizedBox(width: 36),
                          Expanded(
                            flex: 8,
                            child: _buildPopularTopicsList(
                              context,
                              filteredTopics,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPopularTopicsLeftColumn(context),
                          const SizedBox(height: 24),
                          _buildPopularTopicsList(context, filteredTopics),
                        ],
                      ),

                    const SizedBox(height: 56),
                    // 5. 2-Column Brand Callout Cards ("Safety Center" & "Support and resources")
                    _buildSupportBottomCalloutRow(context, isDesktop),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCategoryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String body,
  }) {
    return InkWell(
      onTap: () => _openSafetyFeatureModal(
        context,
        title: title,
        subtitle: subtitle,
        detailBody: body,
      ),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 27,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.7,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Read more',
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularTopicsLeftColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular\ntopics',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 56,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.6,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 24),
        InkWell(
          onTap: () => _openContactSupportModal(context),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFF1E1E1E), width: 1.1),
            ),
            child: const Text(
              'Contact us',
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularTopicsList(
    BuildContext context,
    List<({String title, String subtitle, String body})> topics,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < topics.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          InkWell(
            onTap: () => _openSafetyFeatureModal(
              context,
              title: topics[i].title,
              subtitle: topics[i].subtitle,
              detailBody: topics[i].body,
            ),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      topics[i].title,
                      style: const TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF1E1E1E),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSupportBottomCalloutRow(BuildContext context, bool isDesktop) {
    final safetyCenterCard = Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AviajTheme.loveRed,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Safety Center',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.7,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'For more information on how to make the most of your safety features and resources, visit our Safety Center.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              height: 1.48,
            ),
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () => _scrollToSection(_safetyCenterKey),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Visit Safety Center',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final supportResourcesCard = Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AviajTheme.loveRed,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Support and resources',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.7,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'For emotional support, find a free, confidential helpline using the button below. Helplines can’t respond to emergencies. If you’re in immediate danger, call your local emergency number.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              height: 1.48,
            ),
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () => _openSafetyFeatureModal(
              context,
              title: 'Global Confidential Helplines Directory',
              subtitle:
                  'Free, confidential 24/7 emotional support and crisis resources worldwide.',
              detailBody:
                  '• United States: National Domestic Violence Hotline — 1-800-799-SAFE (7233) or text "START" to 88788\n• India: National Commission for Women Helpline — 7827-170-170 / Emergency 112\n• United Kingdom: Refuge 24-Hour National Domestic Abuse Helpline — 0808 2000 247\n• Australia: 1800RESPECT — 1800 737 732 & The Survivor Hub\n• Global Online Support: Bloom powered by Chayn (bloom.chayn.co)',
            ),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Find a helpline',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (isDesktop) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: safetyCenterCard),
            const SizedBox(width: 26),
            Expanded(child: supportResourcesCard),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        safetyCenterCard,
        const SizedBox(height: 18),
        supportResourcesCard,
      ],
    );
  }

  void _openContactSupportModal(BuildContext context) {
    final subjectCtrl = TextEditingController();
    final messageCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AviajTheme.loveRed,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'AVIAJ HELP CENTER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Contact Aviaj Support',
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Our 24/7 Support & Trust specialists typically respond within 2 hours.',
                    style: TextStyle(
                      color: Color(0xFF4A4A4A),
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: subjectCtrl,
                    decoration: InputDecoration(
                      labelText: 'Topic (e.g. Subscription, ID Verification, Bug)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: messageCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'How can we help?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Your support request has been sent to the Aviaj Help Center team.',
                            ),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF242424),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        'Send message',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// SECTION 5K: "AVIAJ IS NOW APP-ONLY." Hero + "GET THE APP" 2-Phone Stage + "WHY SWITCH TO THE AVIAJ APP?" 3 Illustrated Cards
  Widget _buildAppOnlySwitchSection(BuildContext context, bool isDesktop) {
    final pack = widget.state.regionalPack;

    final reasons = [
      (
        title: 'Never miss a\nconnection',
        subtitle:
            'Get real-time notifications so you don’t miss a message.',
        painter: const _AppSwitchHandHeartPainter(),
      ),
      (
        title: 'Call without sharing\nyour number',
        subtitle:
            'Use our in-app voice and video calls to help move from match to IRL, safely.',
        painter: const _AppSwitchHandPhonePainter(),
      ),
      (
        title: 'Trust your matches\nare genuine',
        subtitle:
            'Chat confidently with verified members using easy in-app photo and ID verification.',
        painter: const _AppSwitchIdCardsPainter(),
      ),
    ];

    // Left 2-Phone Mockup Stage inside "GET THE APP"
    final twoPhoneStage = Container(
      height: isDesktop ? 490 : 410,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AviajTheme.loveRed,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 1. Left Tilted Phone ("9:41" + "Chats" + "Your matches (6)" + "Chats (Recent)")
          Positioned(
            left: isDesktop ? 34 : 12,
            bottom: -24,
            child: Transform.rotate(
              angle: -0.055,
              child: Container(
                width: isDesktop ? 225 : 180,
                height: isDesktop ? 405 : 335,
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  border: Border.all(
                    color: const Color(0xFF1E1E1E),
                    width: 2.2,
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '9:41',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Chats',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Your matches (6)',
                        style: TextStyle(
                          color: Color(0xFF2B2B2B),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AviajTheme.loveRed,
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: AviajNetworkImage(
                                    imageUrl: pack.profiles[1].imageUrl,
                                    width: 38,
                                    height: 38,
                                    fallbackLabel: '12+',
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -4,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AviajTheme.loveRed,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    '12+',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 7.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          ClipOval(
                            child: AviajNetworkImage(
                              imageUrl: pack.profiles[2].imageUrl,
                              width: 40,
                              height: 40,
                              fallbackLabel: 'M',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Chats (Recent)',
                        style: TextStyle(
                          color: Color(0xFF2B2B2B),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (final chat in [
                        (
                          name: 'James',
                          sub: 'Your move',
                          url: pack.profiles[1].imageUrl,
                        ),
                        (
                          name: 'Nick',
                          sub: 'It’s a match!',
                          url: pack.profiles[3].imageUrl,
                        ),
                        (
                          name: 'Kevin',
                          sub: 'Hey there!',
                          url: pack.profiles[4].imageUrl,
                        ),
                      ]) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              ClipOval(
                                child: AviajNetworkImage(
                                  imageUrl: chat.url,
                                  width: 34,
                                  height: 34,
                                  fallbackLabel: chat.name[0],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat.name,
                                      style: const TextStyle(
                                        color: Color(0xFF1E1E1E),
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      chat.sub,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFF6E6E6E),
                                        fontSize: 8.8,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. Right Upright Foreground Phone ("Aviaj" + "Tiana, 30" Portrait Card)
          Positioned(
            right: isDesktop ? 34 : 12,
            bottom: -16,
            child: Container(
              width: isDesktop ? 280 : 210,
              height: isDesktop ? 440 : 355,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                border: Border.all(
                  color: const Color(0xFF1E1E1E),
                  width: 2.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 20,
                    offset: const Offset(-6, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                    child: Row(
                      children: [
                        const Text(
                          'Aviaj',
                          style: TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.7,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.tune_rounded,
                          size: 18,
                          color: Colors.grey.shade800,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            AviajNetworkImage(
                              imageUrl: pack.profiles[0].imageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fallbackLabel: 'Tiana, 30',
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.ios_share_rounded,
                                  color: Colors.white,
                                  size: 13,
                                ),
                              ),
                            ),
                            const Positioned(
                              left: 14,
                              bottom: 18,
                              child: Text(
                                'Tiana, 30',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // Right "GET THE APP" Copy + QR Code Column
    final getTheAppRightColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'GET THE APP',
          style: TextStyle(
            color: const Color(0xFF242424),
            fontSize: isDesktop ? 62 : 38,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.6,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Download Aviaj from the App Store or Google Play and sign in with the same account you used on Aviaj web.',
          style: TextStyle(
            color: Color(0xFF242424),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Scan the QR code below with your phone or tablet to get started.',
          style: TextStyle(
            color: Color(0xFF242424),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Your matches and conversations are waiting for you on the app. 💛',
          style: TextStyle(
            color: Color(0xFF242424),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 28),
        InkWell(
          onTap: () => showMobileAppDownloadModal(context),
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: 176,
            height: 176,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.qr_code_2_rounded,
                  size: 176,
                  color: Color(0xFF1E1E1E),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: AviajTheme.loveRed,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const AppStoreDownloadBadges(lightOnDark: false),
      ],
    );

    return Column(
      children: [
        // 1. Top Soft Cream/Blush Banner ("AVIAJ IS NOW APP-ONLY.")
        Container(
          width: double.infinity,
          color: const Color(0xFFFFF8D6),
          padding: EdgeInsets.fromLTRB(
            isDesktop ? 64 : 20,
            isDesktop ? 42 : 24,
            isDesktop ? 64 : 20,
            isDesktop ? 88 : 56,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  Text(
                    _langPack.appOnlyHeroTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF242424),
                      fontSize: isDesktop ? 72 : 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.8,
                      height: 1.02,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _langPack.appOnlyHeroSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF242424),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _openSafetyFeatureModal(
                      context,
                      title: 'Why Aviaj is Now App-Only',
                      subtitle:
                          'Designed to bring you our most advanced safety tools, real-time notifications, and verified connections.',
                      detailBody:
                          'By focusing exclusively on the Aviaj iOS and Android apps, every member benefits from real-time push notifications, native HD voice & video calls, biometric Photo & ID Verification, and Deception Detector™ protection. Sign in on the mobile app with your existing account—all your matches and conversations are waiting for you.',
                    ),
                    child: const Text(
                      'Learn more',
                      style: TextStyle(
                        color: Color(0xFF242424),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 2. "GET THE APP" 2-Column Split Section (2-Phone Mockup Stage Left + QR Code Right)
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 64 : 20,
            vertical: isDesktop ? 76 : 48,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1140),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 11, child: twoPhoneStage),
                        const SizedBox(width: 64),
                        Expanded(flex: 10, child: getTheAppRightColumn),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        twoPhoneStage,
                        const SizedBox(height: 36),
                        getTheAppRightColumn,
                      ],
                    ),
            ),
          ),
        ),

        // 3. "WHY SWITCH TO THE AVIAJ APP?" Full-Bleed Brand Section with 3 Hand-Drawn Illustrated Cards
        Container(
          width: double.infinity,
          color: AviajTheme.loveRed,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 64 : 20,
            vertical: isDesktop ? 88 : 56,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WHY SWITCH TO THE AVIAJ APP?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 64 : 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.6,
                      height: 1.02,
                    ),
                  ),
                  const SizedBox(height: 44),
                  if (isDesktop)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (int i = 0; i < reasons.length; i++) ...[
                            if (i > 0) const SizedBox(width: 24),
                            Expanded(
                              child: _buildWhySwitchReasonCard(
                                title: reasons[i].title,
                                subtitle: reasons[i].subtitle,
                                painter: reasons[i].painter,
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int i = 0; i < reasons.length; i++) ...[
                          if (i > 0) const SizedBox(height: 20),
                          _buildWhySwitchReasonCard(
                            title: reasons[i].title,
                            subtitle: reasons[i].subtitle,
                            painter: reasons[i].painter,
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWhySwitchReasonCard({
    required String title,
    required String subtitle,
    required CustomPainter painter,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 235,
              color: const Color(0xFFFFF5CC),
              alignment: Alignment.center,
              child: CustomPaint(
                size: const Size(240, 165),
                painter: painter,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.7,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF2B2B2B),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      height: 1.46,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavbarLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isHighlighted;

  const _NavbarLink({
    required this.label,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: onTap,
        style: isHighlighted
            ? TextButton.styleFrom(
                backgroundColor: AviajTheme.warmSand,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              )
            : null,
        child: Text(
          label,
          style: TextStyle(
            color: isHighlighted ? AviajTheme.loveRed : AviajTheme.midnightNavy,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;
  final VoidCallback onTap;

  const _FooterColumn({
    required this.title,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AviajTheme.compassAmber,
              fontWeight: FontWeight.w900,
              fontSize: 11.5,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: onTap,
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom 3D perspective trapezoid clipper with smooth rounded corners.
/// Top edge slopes UP from left `(0, slant)` to right `(width, 0)`.
/// Bottom edge slopes DOWN from left `(0, height - slant)` to right `(width, height)`.
class _PerspectiveSlabClipper extends CustomClipper<Path> {
  final double slant;
  final double radius;

  const _PerspectiveSlabClipper({
    required this.slant,
    required this.radius,
  });

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final s = slant.clamp(0.0, h * 0.28);
    final r = math.min(radius, math.min(w, h) * 0.16);

    final points = <Offset>[
      Offset(0, s), // Top-left
      Offset(w, 0), // Top-right
      Offset(w, h), // Bottom-right
      Offset(0, h - s), // Bottom-left
    ];

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final prev = points[(i - 1 + points.length) % points.length];
      final curr = points[i];
      final next = points[(i + 1) % points.length];

      final vIn = prev - curr;
      final vOut = next - curr;
      final lenIn = vIn.distance;
      final lenOut = vOut.distance;

      if (lenIn == 0 || lenOut == 0) continue;

      final pStart = curr + (vIn / lenIn) * r;
      final pEnd = curr + (vOut / lenOut) * r;

      if (i == 0) {
        path.moveTo(pStart.dx, pStart.dy);
      } else {
        path.lineTo(pStart.dx, pStart.dy);
      }
      path.quadraticBezierTo(curr.dx, curr.dy, pEnd.dx, pEnd.dy);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _PerspectiveSlabClipper oldClipper) {
    return oldClipper.slant != slant || oldClipper.radius != radius;
  }
}

/// Custom clipper that produces the organic wavy / scalloped cloud silhouette
/// around "The Friendship Hub" hero photograph.
class _WavyFriendshipFrameClipper extends CustomClipper<Path> {
  const _WavyFriendshipFrameClipper();

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final padX = w * 0.022;
    final padY = h * 0.045;
    final ampX = w * 0.014;
    final ampY = h * 0.032;
    final cornerR = math.min(w, h) * 0.14;

    final path = Path();
    // Start after top-left rounded corner
    path.moveTo(padX + cornerR, padY);

    // Top wavy edge (3 gentle sinusoidal waves)
    const topSegments = 48;
    final topStart = padX + cornerR;
    final topEnd = w - padX - cornerR;
    for (int i = 1; i <= topSegments; i++) {
      final t = i / topSegments;
      final x = topStart + (topEnd - topStart) * t;
      final y = padY + math.sin(t * math.pi * 5) * ampY;
      path.lineTo(x, y);
    }

    // Top-right rounded corner
    path.quadraticBezierTo(w - padX, padY, w - padX, padY + cornerR);

    // Right wavy edge (2 gentle sinusoidal waves)
    const sideSegments = 32;
    final sideStart = padY + cornerR;
    final sideEnd = h - padY - cornerR;
    for (int i = 1; i <= sideSegments; i++) {
      final t = i / sideSegments;
      final y = sideStart + (sideEnd - sideStart) * t;
      final x = (w - padX) - math.sin(t * math.pi * 3) * ampX;
      path.lineTo(x, y);
    }

    // Bottom-right rounded corner
    path.quadraticBezierTo(
      w - padX,
      h - padY,
      w - padX - cornerR,
      h - padY,
    );

    // Bottom wavy edge (3 gentle sinusoidal waves)
    for (int i = 1; i <= topSegments; i++) {
      final t = i / topSegments;
      final x = topEnd - (topEnd - topStart) * t;
      final y = (h - padY) - math.sin(t * math.pi * 5) * ampY;
      path.lineTo(x, y);
    }

    // Bottom-left rounded corner
    path.quadraticBezierTo(padX, h - padY, padX, h - padY - cornerR);

    // Left wavy edge (2 gentle sinusoidal waves)
    for (int i = 1; i <= sideSegments; i++) {
      final t = i / sideSegments;
      final y = sideEnd - (sideEnd - sideStart) * t;
      final x = padX + math.sin(t * math.pi * 3) * ampX;
      path.lineTo(x, y);
    }

    // Top-left rounded corner
    path.quadraticBezierTo(padX, padY, padX + cornerR, padY);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _SafetySparkleStarPainter extends CustomPainter {
  const _SafetySparkleStarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.48;
    final path = Path()
      ..moveTo(cx, cy - r)
      ..quadraticBezierTo(cx, cy, cx + r, cy)
      ..quadraticBezierTo(cx, cy, cx, cy + r)
      ..quadraticBezierTo(cx, cy, cx - r, cy)
      ..quadraticBezierTo(cx, cy, cx, cy - r)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SafetyProhibitedPainter extends CustomPainter {
  const _SafetyProhibitedPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.42;
    final strokePaint = Paint()
      ..color = const Color(0xFFD9232E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    // Inner purple shape
    final innerPaint = Paint()
      ..color = const Color(0xFF6B2D83)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: center, width: r * 1.1, height: r * 0.65),
      innerPaint,
    );

    // Outer red circle and diagonal slash
    canvas.drawCircle(center, r, strokePaint);
    final d = r * 0.707;
    canvas.drawLine(
      Offset(center.dx - d, center.dy - d),
      Offset(center.dx + d, center.dy + d),
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SafetySpamSilhouettePainter extends CustomPainter {
  const _SafetySpamSilhouettePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF242424)
      ..style = PaintingStyle.fill;
    final cx = size.width / 2;
    // Head circle
    canvas.drawCircle(Offset(cx, size.height * 0.30), size.width * 0.19, paint);
    // Shoulders dome
    final path = Path()
      ..moveTo(cx - size.width * 0.38, size.height * 0.84)
      ..quadraticBezierTo(
        cx - size.width * 0.36,
        size.height * 0.56,
        cx,
        size.height * 0.56,
      )
      ..quadraticBezierTo(
        cx + size.width * 0.36,
        size.height * 0.56,
        cx + size.width * 0.38,
        size.height * 0.84,
      )
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SafetyCallBarIconsPainter extends CustomPainter {
  const _SafetyCallBarIconsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 1. Video camera icon on left (x: 0..22)
    final camRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(1, 4, 13, 12),
      const Radius.circular(3),
    );
    canvas.drawRRect(camRect, paint);
    final lensPath = Path()
      ..moveTo(14, 8)
      ..lineTo(20, 5)
      ..lineTo(20, 15)
      ..lineTo(14, 12);
    canvas.drawPath(lensPath, paint);

    // 2. Microphone icon on right (x: 30..46)
    final micRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(35, 2, 6, 10),
      const Radius.circular(3),
    );
    canvas.drawRRect(micRect, paint);
    canvas.drawArc(
      const Rect.fromLTWH(32, 5, 12, 10),
      0,
      math.pi,
      false,
      paint,
    );
    canvas.drawLine(const Offset(38, 15), const Offset(38, 18), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SafetyStarBadgePainter extends CustomPainter {
  const _SafetyStarBadgePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = size.width * 0.45;
    final innerR = size.width * 0.21;
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final angle = -math.pi / 2 + i * (math.pi / 5);
      final r = i.isEven ? outerR : innerR;
      final x = cx + math.cos(angle) * r;
      final y = cy + math.sin(angle) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom line-art illustration: Two sketched hands forming a heart in the center
class _AppSwitchHandHeartPainter extends CustomPainter {
  const _AppSwitchHandHeartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final heartFillPaint = Paint()
      ..color = const Color(0xFFFFC629)
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Center heart formed by the two hands
    final heartPath = Path()
      ..moveTo(cx, cy + 28)
      ..cubicTo(cx - 42, cy + 4, cx - 44, cy - 30, cx - 18, cy - 30)
      ..cubicTo(cx - 6, cy - 30, cx, cy - 18, cx, cy - 14)
      ..cubicTo(cx, cy - 18, cx + 6, cy - 30, cx + 18, cy - 30)
      ..cubicTo(cx + 44, cy - 30, cx + 42, cy + 4, cx, cy + 28)
      ..close();
    canvas.drawPath(heartPath, heartFillPaint);
    canvas.drawPath(heartPath, strokePaint);

    // Left hand outer contour & fingers
    final leftHand = Path()
      ..moveTo(14, cy + 32)
      ..quadraticBezierTo(44, cy + 4, 62, cy - 26)
      ..quadraticBezierTo(78, cy - 48, cx - 4, cy - 22)
      ..moveTo(34, cy + 46)
      ..quadraticBezierTo(68, cy + 32, cx - 2, cy + 28);
    canvas.drawPath(leftHand, strokePaint);

    // Right hand outer contour & fingers
    final rightHand = Path()
      ..moveTo(size.width - 14, cy + 32)
      ..quadraticBezierTo(size.width - 44, cy + 4, size.width - 62, cy - 26)
      ..quadraticBezierTo(size.width - 78, cy - 48, cx + 4, cy - 22)
      ..moveTo(size.width - 34, cy + 46)
      ..quadraticBezierTo(size.width - 68, cy + 32, cx + 2, cy + 28);
    canvas.drawPath(rightHand, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom line-art illustration: Hand holding an upright smartphone
class _AppSwitchHandPhonePainter extends CustomPainter {
  const _AppSwitchHandPhonePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final darkFill = Paint()
      ..color = const Color(0xFF242424)
      ..style = PaintingStyle.fill;

    final screenFill = Paint()
      ..color = const Color(0xFFFFC629)
      ..style = PaintingStyle.fill;

    final cx = size.width / 2 + 6;
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.44),
        width: 72,
        height: 124,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(phoneRect, darkFill);

    // Inner yellow screen
    final screenRect = Rect.fromCenter(
      center: Offset(cx, size.height * 0.39),
      width: 66,
      height: 94,
    );
    canvas.drawRect(screenRect, screenFill);
    canvas.drawRRect(phoneRect, strokePaint);

    // Sketched thumb & hand wrapping from bottom-left
    final thumbFill = Paint()
      ..color = const Color(0xFFFFF5CC)
      ..style = PaintingStyle.fill;
    final thumbPath = Path()
      ..moveTo(cx - 56, size.height - 6)
      ..quadraticBezierTo(cx - 52, size.height * 0.56, cx - 36, size.height * 0.50)
      ..quadraticBezierTo(cx - 10, size.height * 0.62, cx - 2, size.height * 0.68)
      ..quadraticBezierTo(cx + 4, size.height * 0.75, cx - 14, size.height * 0.78)
      ..quadraticBezierTo(cx - 28, size.height * 0.84, cx - 22, size.height - 4);
    canvas.drawPath(thumbPath, thumbFill);
    canvas.drawPath(thumbPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom line-art illustration: Two overlapping tilted ID verification cards
class _AppSwitchIdCardsPainter extends CustomPainter {
  const _AppSwitchIdCardsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final whiteFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final accentFill = Paint()
      ..color = const Color(0xFFFFC629)
      ..style = PaintingStyle.fill;

    // 1. Left tilted ID card
    canvas.save();
    canvas.translate(size.width * 0.36, size.height * 0.42);
    canvas.rotate(0.11);
    final card1 = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: 106, height: 70),
      const Radius.circular(6),
    );
    canvas.drawRRect(card1, whiteFill);
    canvas.drawRRect(card1, strokePaint);
    // Top yellow header strip
    canvas.drawRect(const Rect.fromLTWH(-52, -34, 104, 8), accentFill);
    // Left yellow photo box
    canvas.drawRect(const Rect.fromLTWH(-44, -18, 30, 38), accentFill);
    // Right text lines
    canvas.drawLine(const Offset(-6, -12), const Offset(16, -12), strokePaint);
    canvas.drawLine(const Offset(-6, -3), const Offset(28, -3), strokePaint);
    canvas.drawLine(const Offset(-6, 6), const Offset(12, 6), strokePaint);
    canvas.restore();

    // 2. Right tilted overlapping ID card
    canvas.save();
    canvas.translate(size.width * 0.64, size.height * 0.58);
    canvas.rotate(-0.14);
    final card2 = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: 106, height: 70),
      const Radius.circular(6),
    );
    canvas.drawRRect(card2, whiteFill);
    canvas.drawRRect(card2, strokePaint);
    // Top yellow header strip
    canvas.drawRect(const Rect.fromLTWH(-52, -34, 104, 8), accentFill);
    // Barcode box
    canvas.drawRect(const Rect.fromLTWH(-34, -18, 68, 12), accentFill);
    for (double x = -28; x <= 28; x += 6) {
      canvas.drawLine(Offset(x, -15), Offset(x, -9), strokePaint);
    }
    // Bottom lines
    canvas.drawLine(const Offset(-34, 4), const Offset(22, 4), strokePaint);
    canvas.drawLine(const Offset(-34, 14), const Offset(8, 14), strokePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LanguageSelectorDropdownCard extends StatefulWidget {
  final String selectedLanguageLabel;
  final List<({String label, AviajRegion region})> options;
  final double tabLeftOffset;
  final double tabWidth;
  final double tabHeight;
  final ValueChanged<({String label, AviajRegion region})> onSelect;
  final VoidCallback onClose;

  const _LanguageSelectorDropdownCard({
    required this.selectedLanguageLabel,
    required this.options,
    required this.tabLeftOffset,
    required this.tabWidth,
    required this.tabHeight,
    required this.onSelect,
    required this.onClose,
  });

  @override
  State<_LanguageSelectorDropdownCard> createState() =>
      _LanguageSelectorDropdownCardState();
}

class _LanguageSelectorDropdownCardState
    extends State<_LanguageSelectorDropdownCard> {
  final ScrollController _scrollController = ScrollController();
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final selectedIdx = widget.options.indexWhere(
        (o) => o.label == widget.selectedLanguageLabel,
      );
      if (selectedIdx > 8) {
        final maxExtent = _scrollController.position.maxScrollExtent;
        final target = ((selectedIdx - 8) * 36.0).clamp(0.0, maxExtent);
        _scrollController.jumpTo(target);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 248,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Connected Globe + Up-Chevron Tab ("🌐 ∧") aligned directly over the header pill
          Padding(
            padding: EdgeInsets.only(left: widget.tabLeftOffset),
            child: GestureDetector(
              onTap: widget.onClose,
              child: Container(
                width: widget.tabWidth,
                height: widget.tabHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFF1E1E1E),
                    width: 1.5,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.language_rounded,
                      color: Color(0xFF1E1E1E),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: Color(0xFF1E1E1E),
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Scrollable 28-Language Dropdown List Card
          Container(
            width: 248,
            height: 472,
            decoration: BoxDecoration(
              color: const Color(0xFFFAF9F4),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFE5E4DD),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  itemCount: widget.options.length,
                  itemBuilder: (context, index) {
                    final option = widget.options[index];
                    final isSelected =
                        option.label == widget.selectedLanguageLabel;
                    final isHovered = _hoveredIndex == index;
                    final isHighlighted = isSelected || isHovered;

                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => _hoveredIndex = index),
                      onExit: (_) => setState(() {
                        if (_hoveredIndex == index) _hoveredIndex = null;
                      }),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => widget.onSelect(option),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.5,
                            horizontal: 8,
                          ),
                          child: Text(
                            option.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isHighlighted
                                  ? const Color(0xFF141414)
                                  : const Color(0xFF595959),
                              fontSize: 15.5,
                              fontWeight: isHighlighted
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterAviajWordmarkPainter extends CustomPainter {
  const _FooterAviajWordmarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const double refFontSize = 300.0;
    final tp = TextPainter(
      text: const TextSpan(
        text: 'AVIAJ',
        style: TextStyle(
          color: AviajTheme.loveRed,
          fontSize: refFontSize,
          fontWeight: FontWeight.w900,
          height: 1.0,
          letterSpacing: -8,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final metrics = tp.computeLineMetrics();
    final baseline =
        metrics.isNotEmpty ? metrics.first.baseline : tp.height * 0.80;
    final glyphBottom = baseline + (refFontSize * 0.06);
    final scale = size.width / tp.width;
    final dy = size.height - (glyphBottom * scale);

    canvas.save();
    canvas.translate(0, dy);
    canvas.scale(scale, scale);
    tp.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FooterAviajWordmarkPainter oldDelegate) =>
      false;
}
