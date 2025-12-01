#!/usr/bin/env python3
"""
Extract and organize statistics from snpEff output CSV files.
Usage:
  python parse_snpeff_stats.py --inputs hcc1395normal_snpeff_stats.csv hcc1395tumor_snpeff_stats.csv --prefixes hcc1395normal_snpeff hcc1395tumor_snpeff --outdir snpeff_results
"""

import pandas as pd
import os
import argparse

def parse_snpeff_stats(input_file, output_dir):
	data_dict = {}
	extractDataFlag = False
	countBlankLine = 0
	firstLine = True
	title = ""
	
	if not os.path.exists(output_dir):
		os.makedirs(output_dir)
	
	with open(input_file) as f:
		for line in f:
			if firstLine:
				firstLine = False
				continue
			
			if line.startswith(("# Change rate by chromosome", "# Variantss by type", "# Effects by impact", "# Effects by functional class", "# Count by effects", "# Count by genomic region", "# Ts/Tv summary", "# InDel lengths", "# Base changes", "# Codon change table", "# Amino acid change table")):
				extractDataFlag = True
				countBlankLine = 0
				title = line.strip()
				data_dict[title] = {}
			
			if line.startswith("\n"):
				countBlankLine += 1
			
			if extractDataFlag and (countBlankLine == 1):
				lineArr = [x.strip() for x in line.strip().split(",")]
				if len(lineArr) > 1:
					if title in ["# Variantss by type", "# Effects by impact", "# Effects by functional class", "# Count by effects", "# Count by genomic region", "# Ts/Tv summary"]:
						data_dict[title][lineArr[0]] = lineArr[1]
					elif title == "# Change rate by chromosome":
						data_dict[title][lineArr[0]] = lineArr[2]
					elif title in ["# InDel lengths", "# Base changes", "# Amino acid change table"]:
						data_dict[title][lineArr[0]] = lineArr[1:]
					elif extractDataFlag and (countBlankLine == 1 or title == "# Codon change table"):
						lineArr = [x.strip() for x in line.strip().split(",")]
						if len(lineArr) > 1:
							data_dict[title][lineArr[0]] = lineArr[1:]
	
	# Export parsed data to CSV
	for key in data_dict.keys():
		f_name = key.replace("# ", "").replace(" ", "_").replace("/", "_")
		
		if key in ["# Base changes", "# Codon change table", "# Amino acid change table"]:
			df = pd.DataFrame(data_dict[key])
			if not df.empty:
				df.to_csv(os.path.join(output_dir, f"{f_name}.csv"), index=False)
		elif key == "# InDel lengths":
			df = pd.DataFrame(data_dict[key])
			if not df.empty:
				df.columns = ['features', 'values']
				df.to_csv(os.path.join(output_dir, f"{f_name}.csv"), index=False)
		elif key in ["# Variantss by type", "# Effects by impact", "# Effects by functional class", "# Count by effects", "# Count by genomic region", "# Change rate by chromosome"]:
			listOfValues = list(data_dict[key].items())[1:]
			df = pd.DataFrame(listOfValues, columns=['features', 'values'])
			if not df.empty:
				df.to_csv(os.path.join(output_dir, f"{f_name}.csv"), index=False)
		elif key == "# Ts/Tv summary":
			listOfValues = list(data_dict[key].items())[:-1]
			df = pd.DataFrame(listOfValues, columns=['features', 'values'])
			if not df.empty:
				df.to_csv(os.path.join(output_dir, f"{f_name}.csv"), index=False)

def main():
	parser = argparse.ArgumentParser(description="Extract statistics tables from snpEff output CSV files.")
	parser.add_argument("--inputs", "-i", nargs="+", required=True, help="List of input snpEff stats CSV files.")
	parser.add_argument("--prefixes", "-p", nargs="+", help="Optional list of output prefixes for each input file (same order).")
	parser.add_argument("--outdir", "-o", default=".", help="Base output directory (default: current folder).")
	
	args = parser.parse_args()
	
	if args.prefixes and len(args.inputs) != len(args.prefixes):
		parser.error("Number of prefixes must match number of input files.")
	
	for idx, input_file in enumerate(args.inputs):
		prefix = args.prefixes[idx] if args.prefixes else os.path.splitext(os.path.basename(input_file))[0]
		output_dir = os.path.join(args.outdir, prefix)
		print(f"Processing: {input_file} : {output_dir}")
		parse_snpeff_stats(input_file, output_dir)

if __name__ == "__main__":
	main()
