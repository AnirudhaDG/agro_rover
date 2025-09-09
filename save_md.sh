#!/bin/bash
jupyter nbconvert --to markdown data_analytics.ipynb \
  --TagRemovePreprocessor.enabled=True \
  --TagRemovePreprocessor.remove_cell_tags='{"remove_cell"}' \
  --output README.md