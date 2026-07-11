# Introduction

`us_minila_r` is a custom XKB layout for the Filco MINILA-R keyboard.

I use a MINILA keyboard, but the default US layout is not very friendly for
this keyboard's compact physical layout. The most noticeable issue is the
position of `Esc` and `` ` ``/`~`: on a small keyboard, `Esc` is used frequently,
especially in Vim-like workflows, while the default layout keeps it on the
dedicated escape key position.

This layout keeps the normal US keymap almost unchanged and only adjusts the
keys that are inconvenient on the MINILA:

- The physical `` ` ``/`~` key (`<TLDE>`) outputs `Escape` by default.
- `Shift` + the physical `` ` ``/`~` key still outputs `~`.
- The physical `Esc` key (`<ESC>`) outputs `` ` ``.

In short, it makes `Esc` easier to reach while still keeping access to
`` ` `` and `~`.

# Install

Execute the following command in project root directory

```
mkdir -p ~/.xkb/symbols

cp ./dot/xkb/us_minila_r ~/.xkb/symbols/
```

Or

```
mkdir -p ~/.config/xkb/symbols

cp ./dot/xkb/us_minila_r ~/.config/xkb/symbols/
```


Then, you can set the keyboard layout in your system settings.
