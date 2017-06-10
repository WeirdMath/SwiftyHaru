#!/bin/bash

jazzy -o ../docs/ \
      --source-directory .. \
      --readme ../README.md \
      -a 'Sergej Jaskiewicz' \
      -u 'https://twitter.com/broadway_lamb' \
      -m 'SwiftyHaru' \
      -g 'https://github.com/WeirdMath/SwiftyHaru' \
      -x '-scheme,SwiftyHaru' \
