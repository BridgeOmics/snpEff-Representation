## Pipeline
This directory contains a Python script (`parseSnpEffOutput.py`) for data parsing, which takes an input directory and loops through it, parsing snpEff_stats.csv.

### Dependancies
#### Python
<pre>
  
</pre>


### 1. Run this script
<pre>
usage: parseSnpEffOutput.py [-h] --inputs INPUTS [INPUTS ...] [--prefixes PREFIXES [PREFIXES ...]] [--outdir OUTDIR]

Extract statistics tables from snpEff output CSV files.

options:
  -h, --help            show this help message and exit
  --inputs, -i INPUTS [INPUTS ...]
                        List of input snpEff stats CSV files.
  --prefixes, -p PREFIXES [PREFIXES ...]
                        Optional list of output prefixes for each input file (same order).
  --outdir, -o OUTDIR   Base output directory (default: current folder).
</pre>

### 2. After successfully running `parseSnpEffOutput.py`, run `dataRepresentation.R` in the R environment. 
