#!/usr/bin/env bash

sudo mkdir /usr/share/fonts/firacode
mkdir ./tmp-fonts
cd ./tmp-fonts

curl $(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep "browser_download_url.*FiraCode.zip" | cut -d : -f 2,3 | tr -d \") -LO
unzip FiraCode.zip
sudo mv FiraCodeNerdFont*.ttf /usr/share/fonts/firacode/

sudo mkdir /usr/share/fonts/atkinson-hyperlegible
curl -LO https://raw.githubusercontent.com/googlefonts/atkinson-hyperlegible/main/fonts/ttf/AtkinsonHyperlegible-Regular.ttf
curl -LO https://raw.githubusercontent.com/googlefonts/atkinson-hyperlegible/main/fonts/ttf/AtkinsonHyperlegible-Bold.ttf
curl -LO https://raw.githubusercontent.com/googlefonts/atkinson-hyperlegible/main/fonts/ttf/AtkinsonHyperlegible-Italic.ttf
curl -LO https://raw.githubusercontent.com/googlefonts/atkinson-hyperlegible/main/fonts/ttf/AtkinsonHyperlegible-BoldItalic.ttf
sudo mv AtkinsonHyperlegible*.ttf /usr/share/fonts/atkinson-hyperlegible/

cd -
rm -rf ./tmp-fonts
