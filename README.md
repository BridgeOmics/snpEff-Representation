# snpEff-Representation
This repository contains a Jupyter Notebook written for the snpEff data parsing and visualization.

### Why Customize snpEff Output Visualization?

snpEff is one of the most widely used tools for variant annotation, offering detailed impact predictions, functional classifications, codon/AA changes, and a convenient auto-generated HTML report. While the report is useful for quick inspection, it offers limited customization, no programmatic access to individual plots, and cannot be easily embedded into scientific pipelines, publications, or automated dashboards. Researchers often need tailored visualizations. For example, barplots with consistent color themes, heatmaps for codon or amino-acid change matrices, or comparative plots across multiple samples (e.g., tumor vs normal).
To address this gap, we built a Python Jupyter Notebook workflow that parses the snpEff statistics output file (*_stats.csv) and automatically generates customizable, publication-ready visualizations. This includes barplots, heatmaps, pie charts, and line charts, all created using standard Python libraries such as matplotlib and seaborn. The notebook gives full control over colors, layout, themes, and filtering-something the built-in snpEff HTML report cannot provide.

We are sharing this workflow so researchers can more easily integrate snpEff results into downstream analyses, generate consistent visual summaries, and adapt the plots to their own reporting or publication needs.

### Dependancies:
<pre>
pip install pandas
pip install numpy
pip install matplotlib
pip install seaborn
</pre>
