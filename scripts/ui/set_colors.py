import os
import yaml
import re

dotfiles_path = os.getenv('DOTFILES')
if not dotfiles_path:
    raise Exception("Dotfiles environment variable not set")

xresources_path = os.path.join(dotfiles_path, 'X11', '.Xresources')
alacritty_path = os.path.join(dotfiles_path, 'alacritty', 'alacritty.yml')
alacritty_colors = {}

with open(xresources_path, 'r') as f:
    for line in f:
        match = re.match(r'^\*color(\d+):\s*(#[0-9a-fA-F]{6})\s*$', line)
        if match:
            alacritty_colors[int(match.group(1))] = match.group(2)

new_alacritty_colors = {
    'colors': {
        'primary': {
            'background': alacritty_colors.get(0, '0x000000'),
            'foreground': alacritty_colors.get(7, '0xffffff'),
        },
        'normal': {
            'black':   alacritty_colors.get(0, '0x000000'),
            'red':     alacritty_colors.get(1, '0xff0000'),
            'green':   alacritty_colors.get(2, '0x00ff00'),
            'yellow':  alacritty_colors.get(3, '0xffff00'),
            'blue':    alacritty_colors.get(4, '0x0000ff'),
            'magenta': alacritty_colors.get(5, '0xff00ff'),
            'cyan':    alacritty_colors.get(6, '0x00ffff'),
            'white':   alacritty_colors.get(7, '0xffffff'),
        },
        'bright': {
            'black':   alacritty_colors.get(8, '0x000000'),
            'red':     alacritty_colors.get(9, '0xff0000'),
            'green':   alacritty_colors.get(10, '0x00ff00'),
            'yellow':  alacritty_colors.get(11, '0xffff00'),
            'blue':    alacritty_colors.get(12, '0x0000ff'),
            'magenta': alacritty_colors.get(13, '0xff00ff'),
            'cyan':    alacritty_colors.get(14, '0x00ffff'),
            'white':   alacritty_colors.get(15, '0xffffff'),
        },
    }
}


with open(alacritty_path, 'r') as f:
    alacritty_yml = yaml.safe_load(f)

alacritty_yml.update(new_alacritty_colors)

with open(alacritty_path, 'w') as f:
    yaml.dump(alacritty_yml, f)
