I made this to play Dan Worrall's "I Won The Loudness War", and it does. Running `make` will build the game to `release/loud.gb`. The only input missing is the audio file; it takes a stereo, signed 8-bit, 44.1kHz, raw PCM file at `data.raw`, which gets mixed to mono, see `raw2bin.c` for how it's processed. The dependencies to build are the tcc C compiler, and RGBASM. The Nix flake can make a shell with these dependencies.

My assembly code may be horrifying to those who know assembly.
