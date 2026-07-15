import sys
import os.path

config.load_autoconfig(True)

font = "FiraCode Nerd Font Mono Bold"

base00 = "#1e1e2e"
base01 = "#181825"
base02 = "#313244"
base03 = "#45475a"
base04 = "#585b70"
base05 = "#cdd6f4"
base06 = "#f5e0dc"
base07 = "#b4befe"
base08 = "#f38ba8"
base09 = "#fab387"
base0A = "#f9e2af"
base0B = "#a6e3a1"
base0C = "#94e2d5"
base0D = "#89b4fa"
base0E = "#cba6f7"
base0F = "#f2cdcd"

secretsExists = False
secretFile = os.path.expanduser("~/.config/qutebrowser/qutesecrets.py")

if os.path.isfile(secretFile):
    sys.path.append(os.path.dirname(secretFile))
    import qutesecrets
    secretsExists = True

quickmarksFile = os.path.join(os.path.dirname(__file__), "quickmarks")
quickmarksHtmlFilePath = os.path.join(os.path.dirname(__file__), "quickmarks.html")

if os.path.isfile(quickmarksFile):
    quickmarksHtmlFileText = (
        '<!DOCTYPE html><html><head><title>My Local Dashboard Awesome Homepage</title>'
        '<meta name="viewport" content="width=device-width, initial-scale=1">'
        '<style>'
        f'body {{background-color: {base00}}}'
        f'a, p {{font-weight: bold;font-family:{font};font-size:24px;text-align:center;'
        f'color: {base07};line-height: 1.35;margin-top: 0;margin-bottom: 0;text-decoration: none;}}'
        f'a:hover {{color: {base07};background-color: {base0A};}}'
        'div {margin:auto;width:50%;text-align:center;}'
        f'.ascii {{color: {base0C};font-family:{font}, monospace;font-size:14px;'
        'line-height:1.1;white-space:pre;display:inline-block;text-align:left;}'
        f'.title{{color: {base0A};text-decoration:underline;}}'
        '</style></head><body>'
        '<br><br><div class="icon"><pre class="ascii">\n'
        ' \u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2557 \u2588\u2588\u2557   \u2588\u2588\u2557\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2557\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2557\n'
        '\u2588\u2588\u2554\u2550\u2550\u2550\u2588\u2588\u2557\u2588\u2588\u2551   \u2588\u2588\u2551\u255a\u2550\u2550\u2588\u2588\u2554\u2550\u2550\u255d\u2588\u2588\u2554\u2550\u2550\u2550\u2550\u255d\n'
        '\u2588\u2588\u2551   \u2588\u2588\u2551\u2588\u2588\u2551   \u2588\u2588\u2551   \u2588\u2588\u2551   \u2588\u2588\u2588\u2588\u2588\u2557\n'
        '\u2588\u2588\u2551\u25aa\u25aa \u2588\u2588\u2551\u2588\u2588\u2551   \u2588\u2588\u2551   \u2588\u2588\u2551   \u2588\u2588\u2554\u2550\u2550\u255d\n'
        '\u255a\u2588\u2588\u2588\u2588\u2588\u2588\u2554\u255d\u255a\u2588\u2588\u2588\u2588\u2588\u2588\u2554\u255d   \u2588\u2588\u2551   \u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2557\n'
        ' \u255a\u2550\u2550\u25aa\u25aa\u2550\u255d  \u255a\u2550\u2550\u2550\u2550\u2550\u255d    \u255a\u2550\u255d   \u255a\u2550\u2550\u2550\u2550\u2550\u2550\u255d\n'
        '</pre></div><br><br>'
        '<p class="title">Quickmarks</p><br><div>'
    )
    with open(quickmarksFile) as myQuickmarks:
        for line in myQuickmarks:
            parts = line.split()
            if len(parts) >= 2:
                quickmarksHtmlFileText += f'<a href="{parts[1]}">{parts[0]}</a><br>'
    quickmarksHtmlFileText += "</div></body></html>"
    with open(quickmarksHtmlFilePath, "w") as quickmarksHtmlFile:
        quickmarksHtmlFile.write(quickmarksHtmlFileText)

config.set("content.blocking.method", "both")

config.set("scrolling.smooth", True)
config.set(
    "qt.args",
    [
        "disable-gpu",
        "enable-quic",
        "allow-file-access-from-files",
    ],
)

config.set("content.cookies.accept", "no-3rdparty", "chrome-devtools://*")
config.set("content.cookies.accept", "no-3rdparty", "devtools://*")

config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36",
    "https://accounts.google.com/*",
)
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36",
    "https://*.slack.com/*",
)

config.set("content.images", True, "chrome-devtools://*")
config.set("content.images", True, "devtools://*")

config.set("content.javascript.enabled", True, "chrome-devtools://*")
config.set("content.javascript.enabled", True, "devtools://*")
config.set("content.javascript.enabled", True, "chrome://*/*")
config.set("content.javascript.enabled", True, "qute://*/*")

c.tabs.favicons.scale = 1.0
c.tabs.last_close = "close"
c.tabs.position = "top"
c.tabs.width = "3%"
c.window.transparent = False

c.colors.webpage.darkmode.enabled = True
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.policy.images = "never"

c.url.default_page = str(config.configdir) + "/home.html"
c.url.start_pages = str(config.configdir) + "/home.html"

c.url.searchengines = {
    "DEFAULT": "https://search.brave.com/search?q={}&source=web",
}

config.set("completion.open_categories", ["searchengines", "quickmarks", "bookmarks"])

config.set("downloads.location.directory", "~/Downloads")
config.set("downloads.location.prompt", False)
config.set("downloads.position", "bottom")
config.set("downloads.remove_finished", 5000)

config.set("fileselect.handler", "external")
config.set(
    "fileselect.single_file.command",
    ["foot", "--app-id", "filechoose_yazi", "yazi", "--chooser-file", "{}"],
)
config.set(
    "fileselect.multiple_files.command",
    ["foot", "--app-id", "filechoose_yazi", "yazi", "--chooser-file", "{}"],
)
config.set(
    "fileselect.folder.command",
    ["foot", "--app-id", "filechoose_yazi", "yazi", "--chooser-file", "{}"],
)

config.bind("<Alt-x>", "cmd-set-text :")
config.bind("<Space>.", "cmd-set-text :")
config.bind("<Space>b", "bookmark-list")
config.bind("<Space>h", "history")
config.bind("<Space>gh", "open https://github.com")
config.bind("<Space>gl", "open https://gitlab.com")
config.bind("<Space>gc", "open https://codeberg.org")
if secretsExists:
    config.bind("<Space>gg", "open " + qutesecrets.mygiteadomain)
config.bind("<Ctrl-p>", "completion-item-focus prev", mode="command")
config.bind("<Ctrl-n>", "completion-item-focus next", mode="command")
config.bind("<Ctrl-p>", "fake-key <Up>", mode="normal")
config.bind("<Ctrl-n>", "fake-key <Down>", mode="normal")
config.bind("<Ctrl-p>", "fake-key <Up>", mode="insert")
config.bind("<Ctrl-n>", "fake-key <Down>", mode="insert")
config.bind("<Ctrl-p>", "fake-key <Up>", mode="passthrough")
config.bind("<Ctrl-n>", "fake-key <Down>", mode="passthrough")

config.bind("t", "open -t")
config.bind("x", "tab-close")
config.bind("yf", "hint links yank")
config.bind("<Ctrl-Tab>", "tab-next")
config.bind("<Ctrl-Shift-Tab>", "tab-prev")

config.bind("<Shift-Escape>", "mode-leave", mode="passthrough")
config.bind("<Ctrl-T>", "open -t", mode="passthrough")
config.bind("<Ctrl-W>", "tab-close", mode="passthrough")
config.bind("<Ctrl-Tab>", "tab-next", mode="passthrough")
config.bind("<Ctrl-Shift-Tab>", "tab-prev", mode="passthrough")
config.bind("<Ctrl-B>", "cmd-set-text -s :quickmark-load -t", mode="passthrough")
config.bind("<Ctrl-O>", "cmd-set-text -s :open -t", mode="passthrough")
config.bind("<Ctrl-F>", "cmd-set-text /", mode="passthrough")
config.bind("<Ctrl-R>", "reload", mode="passthrough")
config.unbind("<Ctrl-X>")
config.unbind("<Ctrl-A>")

config.bind(",m", "hint links spawn mpv {hint-url}")

c.colors.completion.fg = base05
c.colors.completion.odd.bg = base01
c.colors.completion.even.bg = base00
c.colors.completion.category.fg = base0A
c.colors.completion.category.bg = base00
c.colors.completion.category.border.top = base00
c.colors.completion.category.border.bottom = base00
c.colors.completion.item.selected.fg = base05
c.colors.completion.item.selected.bg = base02
c.colors.completion.item.selected.border.top = base02
c.colors.completion.item.selected.border.bottom = base02
c.colors.completion.item.selected.match.fg = base0B
c.colors.completion.match.fg = base0B
c.colors.completion.scrollbar.fg = base05
c.colors.completion.scrollbar.bg = base00
c.colors.contextmenu.disabled.bg = base01
c.colors.contextmenu.disabled.fg = base04
c.colors.contextmenu.menu.bg = base00
c.colors.contextmenu.menu.fg = base05
c.colors.contextmenu.selected.bg = base02
c.colors.contextmenu.selected.fg = base05
c.colors.downloads.bar.bg = base00
c.colors.downloads.start.fg = base00
c.colors.downloads.start.bg = base0D
c.colors.downloads.stop.fg = base00
c.colors.downloads.stop.bg = base0C
c.colors.downloads.error.fg = base08
c.colors.hints.fg = base00
c.colors.hints.bg = base0A
c.colors.hints.match.fg = base05
c.colors.keyhint.fg = base05
c.colors.keyhint.suffix.fg = base05
c.colors.keyhint.bg = base00
c.colors.messages.error.fg = base00
c.colors.messages.error.bg = base08
c.colors.messages.error.border = base08
c.colors.messages.warning.fg = base00
c.colors.messages.warning.bg = base0E
c.colors.messages.warning.border = base0E
c.colors.messages.info.fg = base05
c.colors.messages.info.bg = base00
c.colors.messages.info.border = base00
c.colors.prompts.fg = base05
c.colors.prompts.border = base00
c.colors.prompts.bg = base00
c.colors.prompts.selected.bg = base02
c.colors.prompts.selected.fg = base05
c.colors.statusbar.normal.fg = base0B
c.colors.statusbar.normal.bg = base00
c.colors.statusbar.insert.fg = base00
c.colors.statusbar.insert.bg = base0D
c.colors.statusbar.passthrough.fg = base00
c.colors.statusbar.passthrough.bg = base0C
c.colors.statusbar.private.fg = base00
c.colors.statusbar.private.bg = base01
c.colors.statusbar.command.fg = base05
c.colors.statusbar.command.bg = base00
c.colors.statusbar.command.private.fg = base05
c.colors.statusbar.command.private.bg = base00
c.colors.statusbar.caret.fg = base00
c.colors.statusbar.caret.bg = base0E
c.colors.statusbar.caret.selection.fg = base00
c.colors.statusbar.caret.selection.bg = base0D
c.colors.statusbar.progress.bg = base0D
c.colors.statusbar.url.fg = base05
c.colors.statusbar.url.error.fg = base08
c.colors.statusbar.url.hover.fg = base05
c.colors.statusbar.url.success.http.fg = base0C
c.colors.statusbar.url.success.https.fg = base0B
c.colors.statusbar.url.warn.fg = base0E
c.colors.tabs.bar.bg = base00
c.colors.tabs.indicator.start = base0D
c.colors.tabs.indicator.stop = base0C
c.colors.tabs.indicator.error = base08
c.colors.tabs.odd.fg = base05
c.colors.tabs.odd.bg = base01
c.colors.tabs.even.fg = base05
c.colors.tabs.even.bg = base00
c.colors.tabs.pinned.even.bg = base0C
c.colors.tabs.pinned.even.fg = base07
c.colors.tabs.pinned.odd.bg = base0B
c.colors.tabs.pinned.odd.fg = base07
c.colors.tabs.pinned.selected.even.bg = base02
c.colors.tabs.pinned.selected.even.fg = base05
c.colors.tabs.pinned.selected.odd.bg = base02
c.colors.tabs.pinned.selected.odd.fg = base05
c.colors.tabs.selected.odd.fg = base05
c.colors.tabs.selected.odd.bg = base02
c.colors.tabs.selected.even.fg = base05
c.colors.tabs.selected.even.bg = base02

c.fonts.default_family = font
c.fonts.default_size = "14pt"

c.fonts.web.family.standard = font
c.fonts.web.family.serif = font
c.fonts.web.family.sans_serif = font
c.fonts.web.family.fixed = font
c.fonts.web.family.fantasy = font
c.fonts.web.family.cursive = font
