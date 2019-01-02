#!/bin/bash
cd ../automorphic-website/tex
make tags
cd ../../automorphic-tools
python update.py
python macros.py
python graphs.py
