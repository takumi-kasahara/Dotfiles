/**
 * @see {@link https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Experimental_features}
 * @see {@link https://github.com/mozilla-firefox/firefox/blob/main/browser/app/profile/firefox.js}
 * @see {@link https://kb.mozillazine.org/About:config_entries}
 * @see {@link https://support.mozilla.org/en-US/kb/how-stop-firefox-making-automatic-connections}
 * @see {@link https://wiki.mozilla.org/Privacy/Privacy_Task_Force/firefox_about_config_privacy_tweeks}
 */
// #region Gecko
user_pref("accessibility.browsewithcaret_shortcut.enabled", false);
user_pref("accessibility.force_disabled", 1);
user_pref("accessibility.typeaheadfind", false);
user_pref("browser.contentblocking.category", "strict");
user_pref("browser.contentblocking.database.enabled", true);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", true);
user_pref("browser.crashReports.unsubmittedCheck.enabled", true);
user_pref("browser.places.speculativeConnect.enabled", false);
user_pref("browser.privatebrowsing.autostart", true);
user_pref("browser.safebrowsing.downloads.enabled", true);
user_pref("browser.safebrowsing.malware.enabled", true);
user_pref("browser.safebrowsing.phishing.enabled", true);
user_pref("browser.send_pings", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.tabs.crashReporting.includeURL", true);
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("cookiebanners.service.mode", 1); // 1: Reject All
user_pref("dom.battery.enabled", false);
user_pref("dom.disable_open_during_load", true);
user_pref("dom.event.clipboardevents.enabled", false);
user_pref("dom.event.contextmenu.enabled", false);
user_pref("dom.events.dataTransfer.protected.enabled", true);
user_pref("dom.private-attribution.submission.enabled", false); // Disable Privacy-Preserving Attribution.
user_pref("dom.security.https_only_mode.upgrade_local", false);
user_pref("dom.security.https_only_mode", true);
user_pref("extensions.blocklist.enabled", true);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("extensions.getAddons.cache.enabled", false);
user_pref("general.smoothScroll", true);
user_pref("geo.enabled", false);
user_pref("gfx.webrender.all", true);
user_pref("javascript.enabled", true);
user_pref("media.eme.enabled", false);
user_pref("media.gmp-gmpopenh264.enabled", false);
user_pref("media.gmp-widevinecdm.enabled", false);
user_pref("media.hardwaremediakeys.enabled", false);
user_pref("media.peerconnection.enabled", false);
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);
user_pref("network.captive-portal-service.enabled", false);
user_pref("network.cookie.sameSite.laxByDefault", true);  /** @see {@link https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Experimental_features#samesitelax_by_default} */
user_pref("network.connectivity-service.enabled", false);
user_pref("network.dns.disableIPv6", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.http.idempotencyKey.enabled", true);   /** @see {@link https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Experimental_features#idempotency-key} */
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("network.http.windows-sso.enabled", true);
user_pref("network.IDN_show_punycode", true);             /** @see {@link https://kb.mozillazine.org/Network.IDN_show_punycode} */
user_pref("network.preconnect", false);
user_pref("network.predictor.enabled", false);
user_pref("network.prefetch-next", false);
user_pref("network.proxy.socks_remote_dns", true);
user_pref("network.proxy.socks5_remote_dns", true);
user_pref("network.trr.mode", 3); // DNS-over-HTTPS: Max Protection
user_pref("places.history.enabled", false);
user_pref("privacy.clearHistory.formdata", true);
user_pref("privacy.clearHistory.siteSettings", true);
user_pref("privacy.clearOnShutdown_v2.formdata", true);
user_pref("privacy.clearOnShutdown_v2.siteSettings", true);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.siteSettings", true);
user_pref("privacy.clearSiteData.historyFormDataAndDownloads", true);
user_pref("privacy.cpd.offlineApps", true);
user_pref("privacy.cpd.siteSettings", true);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.fingerprintingProtection", true);
user_pref("privacy.firstparty.isolate", true);
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.emailtracking.enabled", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.webrtc.globalMuteToggles", true);
user_pref("security.integrity_policy.enabled", true);
user_pref("security.integrity_policy.stylesheet.enabled", true);  /** @see {@link https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Experimental_features#integrity_policy_for_stylesheet_resources} */
user_pref("signon.autofillForms", true);
user_pref("signon.autologin.proxy", true);
user_pref("signon.generation.enabled", true);
user_pref("signon.management.page.breach-alerts.enabled", true);
user_pref("signon.rememberSignons", false);
user_pref("webgl.disabled", true);
user_pref("xpinstall.signatures.required", true);
user_pref("xpinstall.whitelist.required", true);
// #region mousewheel.*
user_pref("middlemouse.paste", true);
user_pref("mousewheel.autodir.enabled", true);
user_pref("mousewheel.autodir.honourroot", true);
// #endregion
// #region browser.cache.*
/**
 * @see {@link https://kb.mozillazine.org/Browser.cache.check_doc_frequency}
 * 0: Check once per browser session
 * 1: Check every time I view the page
 * 2: Never check (always use cached page)
 * 3: Check when the page is out of date (automatically determined)
 */
user_pref("browser.cache.check_doc_frequency", 0);
user_pref("browser.cache.disk_cache_ssl", false);
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.memory.enable", true);
user_pref("browser.cache.memory.max_entry_size", -1);
// #endregion
// #region browser.sessionstore.*
user_pref("browser.sessionstore.cleanup.forget_closed_after", 3600000); // 1 Hour
user_pref("browser.sessionstore.interval", 60000); // 1 Minute
/**
 * @see {@link https://kb.mozillazine.org/Browser.sessionstore.privacy_level}
 * 0: everywhere
 * 1: unencrypted sites
 * 2: nowhere
 */
user_pref("browser.sessionstore.privacy_level", 2);
// #endregion
// #region font.*
user_pref("browser.display.use_document_fonts", 1);
user_pref("font.language.group", "ja");
user_pref("font.cjk_pref_fallback_order", "ja,zh-cn,zh-hk,zh-tw,ko");
user_pref("font.default.ja", "serif");
user_pref("font.name.serif.ja", "BIZ UDPMincho");
user_pref("font.name.sans-serif.ja", "BIZ UDPGothic");
user_pref("font.name.monospace.ja", "BIZ UDGothic");
// #endregion
// #region intl.*
/** @see {@link https://firefox-source-docs.mozilla.org/intl/locale.html} */
user_pref("browser.search.region", "JP");
user_pref("intl.accept_languages", "ja");
user_pref("intl.locale.requested", "");
user_pref("intl.regional_prefs.use_os_locales", true);
user_pref("privacy.spoof_english", 2);
// #endregion
// #region devtools.*
// #region visible
user_pref("devtools.debugger.breakpoints-visible", false);
user_pref("devtools.debugger.call-stack-visible", false);
user_pref("devtools.debugger.dom-mutation-breakpoints-visible", false);
user_pref("devtools.debugger.event-listeners-visible", false);
user_pref("devtools.debugger.expressions-visible", false);
user_pref("devtools.debugger.scopes-visible", false);
user_pref("devtools.debugger.threads-visible", false);
user_pref("devtools.debugger.xhr-breakpoints-visible", false);
// #endregion
user_pref("devtools.aboutdebugging.collapsibilities.processes", false);
user_pref("devtools.accessibility.enabled", true);
user_pref("devtools.application.enabled", true);
user_pref("devtools.cache.disabled", true);
user_pref("devtools.chrome.enabled", true);
user_pref("devtools.command-button-errorcount.enabled", true);
user_pref("devtools.command-button-frames.enabled", true);
user_pref("devtools.command-button-measure.enabled", true);
user_pref("devtools.command-button-pick.enabled", true);
user_pref("devtools.command-button-responsive.enabled", true);
user_pref("devtools.command-button-rulers.enabled", true);
user_pref("devtools.command-button-screenshot.enabled", true);
user_pref("devtools.custom-formatters.enabled", true);
user_pref("devtools.debugger.hide-ignored-sources", true);
user_pref("devtools.debugger.ignore-caught-exceptions", true);
user_pref("devtools.debugger.pause-on-caught-exceptions", false);
user_pref("devtools.debugger.pause-on-exceptions", false);
user_pref("devtools.debugger.pending-selected-location", "{}");
user_pref("devtools.debugger.remote-enabled", true);
user_pref("devtools.debugger.show-content-scripts", true);
user_pref("devtools.debugger.source-map-ignore-list-enabled", true);
user_pref("devtools.debugger.start-panel-size", 300);
user_pref("devtools.debugger.ui.editor-wrapping", false);
user_pref("devtools.dom.enabled", true);
user_pref("devtools.editor.autoclosebrackets", true);
user_pref("devtools.editor.detectindentation", true);
user_pref("devtools.editor.expandtab", true);
user_pref("devtools.everOpened", true);
user_pref("devtools.f12_enabled", true);
user_pref("devtools.inspector.activeSidebar", "layoutview");
user_pref("devtools.inspector.draggable_properties", true);
user_pref("devtools.inspector.rule-view.focusNextOnEnter", true);
user_pref("devtools.inspector.selectedSidebar", "layoutview");
user_pref("devtools.inspector.showUserAgentStyles", true);
user_pref("devtools.inspector.simple-highlighters-reduced-motion", true);
user_pref("devtools.inspector.simple-highlighters.message-dismissed", true);
user_pref("devtools.inspector.three-pane-enabled", true);
user_pref("devtools.markup.collapseAttributes", true);
user_pref("devtools.memory.enabled", true);
user_pref("devtools.netmonitor.columnsData", "[{\"name\":\"override\",\"minWidth\":20,\"width\":2}, {\"name\":\"status\",\"minWidth\":30,\"width\":5}, {\"name\":\"method\",\"minWidth\":30,\"width\":5}, {\"name\":\"domain\",\"minWidth\":30,\"width\":10}, {\"name\":\"file\",\"minWidth\":30,\"width\":25}, {\"name\":\"url\",\"minWidth\":30,\"width\":25},{\"name\":\"initiator\",\"minWidth\":30,\"width\":10},{\"name\":\"type\",\"minWidth\":30,\"width\":5},{\"name\":\"transferred\",\"minWidth\":30,\"width\":10},{\"name\":\"contentSize\",\"minWidth\":30,\"width\":5},{\"name\":\"waterfall\",\"minWidth\":150,\"width\":15}]");
user_pref("devtools.netmonitor.enabled", true);
user_pref("devtools.netmonitor.filters", "[\"all\"]");
user_pref("devtools.netmonitor.persistlog", true);
user_pref("devtools.performance.enabled", true);
user_pref("devtools.responsive.reloadNotification.enabled", true);
user_pref("devtools.responsive.touchSimulation.enabled", true);
user_pref("devtools.responsive.userAgent", null);
user_pref("devtools.responsive.viewport.height", 480);
user_pref("devtools.responsive.viewport.pixelRatio", 0);
user_pref("devtools.responsive.viewport.width", 320);
user_pref("devtools.screenshot.audio.enabled", true);
user_pref("devtools.screenshot.clipboard.enabled", true);
user_pref("devtools.serviceWorkers.testing.enabled", true);
user_pref("devtools.source-map.client-service.enabled", true);
user_pref("devtools.storage.enabled", true);
user_pref("devtools.styleeditor.atRulesSidebarWidth", 238);
user_pref("devtools.styleeditor.autocompletion-enabled", true);
user_pref("devtools.styleeditor.enabled", true);
user_pref("devtools.styleeditor.navSidebarWidth", 245);
user_pref("devtools.styleeditor.showAtRulesSidebar", true);
user_pref("devtools.toolbox.footer.height", 0);
user_pref("devtools.toolbox.host", "window");
user_pref("devtools.toolbox.selectedTool", "inspector");
user_pref("devtools.toolbox.sidebar.width", 500);
user_pref("devtools.toolbox.splitconsole.enabled", true);
user_pref("devtools.toolbox.splitconsole.open", true);
user_pref("devtools.toolbox.splitconsoleHeight", 100);
user_pref("devtools.toolbox.tabsOrder", null);
user_pref("devtools.toolsidebar-height.inspector", 0);
user_pref("devtools.toolsidebar-width.inspector.splitsidebar", 350);
user_pref("devtools.toolsidebar-width.inspector", 700);
user_pref("devtools.webconsole.filter.css", false);
user_pref("devtools.webconsole.filter.debug", true);
user_pref("devtools.webconsole.filter.error", true);
user_pref("devtools.webconsole.filter.info", true);
user_pref("devtools.webconsole.filter.log", true);
user_pref("devtools.webconsole.filter.net", false);
user_pref("devtools.webconsole.filter.netxhr", false);
user_pref("devtools.webconsole.filter.warn", true);
user_pref("devtools.webconsole.persistlog", true);
user_pref("devtools.webconsole.timestampMessages", true);
// #endregion
// #region layout.css.*
user_pref("layout.css.always_underline_links", true);
user_pref("layout.forms.input-type-search.enabled", true);      /** @see {@link https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Experimental_features#layout_for_input_typesearch} */
user_pref("layout.forms.reveal-password-button.enabled", true); /** @see {@link https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Experimental_features#toggle_password_display} */
// #endregion
// #region print.*
user_pref("print.more-settings.open", false);
user_pref("print.print_footercenter", "&PT");
user_pref("print.print_footerleft", "");
user_pref("print.print_footerright", "");
user_pref("print.print_headercenter", "&U");
user_pref("print.print_headerleft", "");
user_pref("print.print_headerright", "");
user_pref("print_printer", "Mozilla Save to PDF");
user_pref("print.printer_Mozilla_Save_to_PDF.print_bgcolor", true);
user_pref("print.printer_Mozilla_Save_to_PDF.print_bgimages", true);
user_pref("print.printer_Mozilla_Save_to_PDF.print_orientation", 0); // 0: Portrait, 1: Landscape
user_pref("print.printer_Mozilla_Save_to_PDF.print_paper_id", "iso_a3");
user_pref("print.printer_Mozilla_Save_to_PDF.print_shrink_to_fit", true);
user_pref("print.printer_Mozilla_Save_to_PDF.print_ignore_unwriteable_margins", true);
user_pref("print.printer_Mozilla_Save_to_PDF.print_margin_top", "0");
user_pref("print.printer_Mozilla_Save_to_PDF.print_margin_bottom", "0");
user_pref("print.printer_Mozilla_Save_to_PDF.print_margin_left", "0");
user_pref("print.printer_Mozilla_Save_to_PDF.print_margin_right", "0");
// #endregion
// #region reader.*
user_pref("reader.color_scheme", null); // auto
user_pref("reader.content_width", 5);
user_pref("reader.font_type", "serif");
user_pref("reader.line_height", 5);
// #endregion
// #region pdfjs.*
user_pref("pdfjs.defaultZoomValue", "page-fit"); // Actual Size
user_pref("pdfjs.enableAltText", true);
user_pref("pdfjs.enableAltTextForEnglish", true);
user_pref("pdfjs.enableScripting", false);
user_pref("pdfjs.scrollModeOnLoad", 1); // 1: Horizontal scrolling
// #endregion
// #region network.http.referer.*
/**
 * @see {@link https://wiki.mozilla.org/Security/Referrer}
 * 0: no-referrer
 * 1: same-origin
 * 2: strict-origin-when-cross-origin
 * 3: no-referrer-when-downgrade
 */
user_pref("network.http.referer.defaultPolicy.trackers", 0);
user_pref("network.http.referer.defaultPolicy.trackers.pbmode", 0);
user_pref("network.http.referer.hideOnionSource", true);
user_pref("network.http.referer.sendFromRefresh", false);
user_pref("network.http.referer.spoofSource", true);
// 0: send the full URL
// 1: send the URL without its query string
// 2: only send the origin
user_pref("network.http.referer.trimmingPolicy", 2);
// 0: send the referrer in all cases
// 1: send a referrer only when the base domains are the same
// 2: send a referrer only on same-origin
user_pref("network.http.referer.XOriginPolicy", 2);
// 0: send the full URL
// 1: send the URL without its query string
// 2: only send the origin
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);
// #endregion
// #endregion
// #region Firefox
user_pref("app.update.auto", true);
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.altClickSave", true);
user_pref("browser.bookmarks.autoExportHTML", true);
user_pref("browser.bookmarks.defaultLocation", "unfiled_____"); // Other Bookmarks
user_pref("browser.bookmarks.openInTabClosesMenu", false);
user_pref("browser.bookmarks.showMobileBookmarks", true);
user_pref("browser.ctrlTab.sortByRecentlyUsed", false);
user_pref("browser.download.always_ask_before_handling_new_types", true);
user_pref("browser.download.autohideButton", true);
user_pref("browser.download.dir", "");
user_pref("browser.download.folderList", 1);
user_pref("browser.download.lastDir", "");
user_pref("browser.download.useDownloadDir", false); // Always ask you where to save files.
/**
 * @see {@link https://kb.mozillazine.org/Browser.link.open_newwindow}
 * 1: current window/tab
 * 2: new window
 * 3: new tab in most recent window
 */
user_pref("browser.link.open_newwindow", 3);
/**
 * @see {@link https://kb.mozillazine.org/Browser.link.open_newwindow.restriction}
 * 0: no restrictions - divert everything
 * 1: don't divert window.open at all
 * 2: don't divert window.open with features
 */
user_pref("browser.link.open_newwindow.restriction", 2);
user_pref("browser.ml.linkPreview.enabled", false);
user_pref("browser.ml.linkPreview.longPress", false);
user_pref("browser.ml.linkPreview.optin", false);
user_pref("browser.newtabpage.enabled", true);
user_pref("browser.search.context.loadInBackground", true); // Open links in background.
user_pref("browser.search.openintab", true); // Open search results in a new tab.
/**
 * @see {@link https://wiki.mozilla.org/Session_Restore}
 * 0: blank
 * 1: home (browser.startup.homepage)
 * 2: last visited page
 * 3: resume previous browser session
 */
user_pref("browser.startup.page", 3);
user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("browser.tabs.groups.enabled", false);
user_pref("browser.tabs.groups.smart.userEnabled", false);
user_pref("browser.tabs.hoverPreview.showThumbnails", false);
user_pref("browser.tabs.insertRelatedAfterCurrent", true); // Open new tabs to the right of the parent tab.
user_pref("browser.tabs.loadBookmarksInBackground", true);
user_pref("browser.tabs.loadBookmarksInTabs", true);
user_pref("browser.tabs.loadDivertedInBackground", true);
user_pref("browser.tabs.warnOnClose", false);
user_pref("browser.tabs.warnOnCloseOtherTabs", false);
user_pref("browser.tabs.warnOnOpen", false);
user_pref("browser.taskbar.previews.enable", false);
user_pref("browser.taskbarTabs.enabled", false);
user_pref("browser.toolbars.bookmarks.showOtherBookmarks", false);
user_pref("browser.toolbars.bookmarks.visibility", "always");
user_pref("browser.urlbar.keepPanelOpenDuringImeComposition", true);
user_pref("browser.warnOnQuit", true);
user_pref("browser.warnOnQuitShortcut", true);
user_pref("findbar.entireword", false);
user_pref("findbar.highlightAll", true);
// #region browser.uiCustomization.*
user_pref("browser.uiCustomization.horizontalTabstrip", "[\"firefox-view-button\",\"tabbrowser-tabs\",\"new-tab-button\"]");
user_pref("browser.uiCustomization.navBarWhenVerticalTabs", "[\"vertical-spacer\",\"back-button\",\"forward-button\",\"urlbar-container\",\"new-identity-button\",\"jid1-mnnxcxisbpnsxq_jetpack-browser-action\",\"bookmarks-menu-button\",\"history-panelmenu\",\"downloads-button\",\"unified-extensions-button\"]");
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"_73a6fe31-595d-460b-a920-fcc0f8843232_-browser-action\"],\"nav-bar\":[\"vertical-spacer\",\"back-button\",\"forward-button\",\"urlbar-container\",\"security-level-button\",\"new-identity-button\",\"bookmarks-menu-button\",\"history-panelmenu\",\"downloads-button\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[],\"vertical-tabs\":[\"tabbrowser-tabs\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"_73a6fe31-595d-460b-a920-fcc0f8843232_-browser-action\",\"developer-button\",\"screenshot-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"TabsToolbar\",\"vertical-tabs\",\"unified-extensions-area\",\"toolbar-menubar\",\"PersonalToolbar\"],\"currentVersion\":22,\"currentVersionBaseBrowser\":2,\"currentVersionTorBrowser\":1,\"newElementCount\":0}");
user_pref("sidebar.backupState", "{}");
user_pref("sidebar.main.tools", "");
user_pref("sidebar.position_start", true);
user_pref("sidebar.revamp", true);
user_pref("sidebar.verticalTabs", true);
user_pref("sidebar.visibility", "expand-on-hover");
// #endregion
// #region browser.search.*
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.showSearchSuggestionsFirst", false);
user_pref("browser.urlbar.suggest.bookmark", true);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.recentsearches", false);
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.suggest.trending", false);
// #endregion
// #region permissions.*
user_pref("permissions.default.camera", 2);               // 2: Disabled
user_pref("permissions.default.desktop-notification", 2); // 2: Disabled
user_pref("permissions.default.geo", 2);                  // 2: Disabled
user_pref("permissions.default.microphone", 2);           // 2: Disabled
user_pref("permissions.default.xr", 2);                   // 2: Disabled
// #endregion
// #endregion
// #region Tor Browser
user_pref("browser.new_identity.confirm_newnym", false);
user_pref("browser.security_level.security_slider", 4); // 1: Safest, 2: Safer, 4: Standard
user_pref("privacy.resistFingerprinting.letterboxing.didForceSize", true);
user_pref("privacy.resistFingerprinting.letterboxing.rememberSize", true);
user_pref("privacy.resistFingerprinting.letterboxing.vcenter", true);
user_pref("torbrowser.homepage.yec2024.message", 0);
user_pref("torbrowser.settings.quickstart.enabled", true);
// #endregion
