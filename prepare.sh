git clone https://github.com/BattleCh1cken/notebookinator
cd notebookinator
just install
cd ..

cargo install typst-live
cargo install --git https://github.com/astrale-sharp/typstfmt.git --tag 0.2.7
cargo install typos-cli

# add fonts
sudo mkdir /usr/share/fonts/truetype/telemarines
sudo cp -R ./assets/fonts /usr/share/fonts/truetype