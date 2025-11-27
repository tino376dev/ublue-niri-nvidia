#! /usr/bin/nu
let theme = ^dconf read /org/gnome/desktop/interface/color-scheme
let theme = match $theme {
  "'prefer-dark'" => "dark"
  _ => "light"
}
let image = $"/usr/share/backgrounds/($theme).png"
exec /usr/bin/awww img $image
