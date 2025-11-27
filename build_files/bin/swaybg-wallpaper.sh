#! /usr/bin/nu
let theme = ^dconf read /org/gnome/desktop/interface/color-scheme
let theme = match $theme {
  "'prefer-dark'" => "dark"
  _ => "light"
}
let image = $"/usr/share/backgrounds/($theme)-blur.png"
exec /usr/bin/swaybg -m fill -i $image 
