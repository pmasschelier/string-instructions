#!/usr/bin/env python3
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np
import subprocess
import pandas as pd
import sys
import io
from os.path import basename
from string import Template
from mplcursors import cursor


class Blog:
    def __init__(self, filename, figsize=(6, 6), axis=True):
        self.filename = filename
        self.figsize = figsize
        self.axis = axis

    def set_plot(self, figsize=(6, 6)):
        sns.set_theme(style="white", palette="bright")
        COLOR = "grey"
        mpl.rcParams["text.color"] = COLOR
        mpl.rcParams["axes.labelcolor"] = COLOR
        mpl.rcParams["xtick.color"] = COLOR
        mpl.rcParams["ytick.color"] = COLOR
        plt.figure(figsize=self.figsize)
        sns.set_context("paper")

    def save_plot(self):
        if self.axis:
            plt.axis("on")
        else:
            plt.axis("off")
        plt.savefig(
            self.filename,
            format="svg",
            bbox_inches="tight",
            pad_inches=0.3,
            transparent=True,
        )
        plt.show()

    def __enter__(self):
        self.set_plot()
        return self

    def __exit__(self, exc_type, exc_value, exc_traceback):
        self.save_plot()


def run_benchmark(program_name):
    """
    Execute the given program and capture its CSV output
    """
    try:
        result = subprocess.run(
            program_name,
            shell=True,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True,
        )
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error executing program: {e}", file=sys.stderr)
        print(f"Program stderr: {e.stderr}", file=sys.stderr)
        sys.exit(1)


def process_csv_data(csv_data):
    """
    Process CSV data where:
    - First column is the benchmark name
    - Fifth column contains the values for calculations
    Returns a DataFrame with means and standard deviations for each benchmark
    """
    # Read CSV data without header (explicitly set header=None)
    df = pd.read_csv(
        io.StringIO(csv_data),
        header=None,
        names=["Benchmark", "Col2", "Col3", "Col4", "Value"],
    )

    # Check if there are enough columns
    if len(df.columns) < 5:
        print(
            f"Error: CSV data doesn't have enough columns. Expected at least 5, got {len(df.columns)}"
        )
        sys.exit(1)

    # Create a new DataFrame with only the relevant columns
    processed_df = df[["Benchmark", "Value"]]
    processed_df.loc[:, "Value"] = processed_df["Value"] / 1e6

    # Calculate mean and standard deviation for each benchmark
    result_df = (
        processed_df.groupby("Benchmark")["Value"]
        .agg(["mean", "min", "max"])
        .reset_index()
    )

    # Rename columns for clarity
    result_df.columns = ["Benchmark", "Mean", "Min", "Max"]

    # Sort by mean values in ascending order
    result_df.sort_values("Mean", inplace=True)
    return processed_df, result_df


def create_bar_chart(function, result_df, aggregated_df):
    """
    Create a bar chart with error bars using seaborn with the calculated means and standard deviations
    """
    # Create the bar chart with error bars using seaborn
    ax = sns.barplot(
        x="Benchmark",
        y="Value",
        hue="Benchmark",
        data=result_df,
        order=aggregated_df["Benchmark"],
        errorbar=("ci", 99),
        palette="viridis_r",
        edgecolor="black",
        capsize=0.2,
    )

    # Add labels and title with improved styling
    ax.set_xlabel("Benchmarks", fontsize=12, fontweight="bold")
    ax.set_ylabel("Execution time (ms)", fontsize=12, fontweight="bold")
    ax.set_title(f"{function}", fontsize=14, fontweight="bold")

    # Rotate x-axis labels for better readability if needed
    plt.xticks(rotation=45, ha="right")

    # Improve layout
    # plt.tight_layout()

    cursor(hover=True)


def create_echarts_config(name, result_df):
    names_json = result_df["Benchmark"].to_json(orient="values")
    means_json = result_df["Mean"].to_json(orient="values")
    stds_json = result_df["Std"].to_json(orient="values")
    option_tmpl = Template("""
{
    "title": {
        "text": "Benchmarking of several memcpy implementations"
    },
    "tooltip": {},
    "legend": {
        "data": "execution time (in ns)"
    },
    "xAxis": {
        "data": $names
    },
    "yAxis": {},
    "series": [
        {
            "name": "execution time (in ns)",
            "type": "bar",
            "data": $mean
        },
        {
            "type": 'custom',
            "name": 'error',
            "itemStyle": {
                "borderWidth": 1.5
            },
            renderItem: function (params, api) {
                var xValue = api.value(0);
                var highPoint = api.coord([xValue, api.value(1)]);
                var lowPoint = api.coord([xValue, api.value(2)]);
                var halfWidth = api.size([1, 0])[0] * 0.1;
                var style = api.style({
                    stroke: api.visual('color'),
                    fill: undefined
                });
                return {
                    type: 'group',
                    children: [
                        {
                            type: 'line',
                            transition: ['shape'],
                            shape: {
                                x1: highPoint[0] - halfWidth,
                                y1: highPoint[1],
                                x2: highPoint[0] + halfWidth,
                                y2: highPoint[1]
                            },
                            style: style
                        },
                        {
                            type: 'line',
                            transition: ['shape'],
                            shape: {
                                x1: highPoint[0],
                                y1: highPoint[1],
                                x2: lowPoint[0],
                                y2: lowPoint[1]
                            },
                            style: style
                        },
                        {
                            type: 'line',
                            transition: ['shape'],
                            shape: {
                                x1: lowPoint[0] - halfWidth,
                                y1: lowPoint[1],
                                x2: lowPoint[0] + halfWidth,
                                y2: lowPoint[1]
                            },
                            style: style
                        }
                    ]
                };
            },
            encode: {
                x: 0,
                y: [1, 2]
            },
            data: $std,
            z: 100
        }
    ]
}
    """)
    option_json = option_tmpl.substitute(
        {"names": names_json, "mean": means_json, "std": stds_json}
    )
    page_tmpl = Template(
        """
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>ECharts</title>
    <!-- Download ECharts from cdnjs -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/echarts/5.6.0/echarts.min.js" integrity="sha512-XSmbX3mhrD2ix5fXPTRQb2FwK22sRMVQTpBP2ac8hX7Dh/605hA2QDegVWiAvZPiXIxOV0CbkmUjGionDpbCmw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  </head>
  <body>
    <!-- Prepare a DOM with a defined width and height for ECharts -->
    <div id="main" style="width: 600px;height:400px;"></div>
    <script type="text/javascript">
      // Initialize the echarts instance based on the prepared dom
      var myChart = echarts.init(document.getElementById('main'));

      // Specify the configuration items and data for the chart
      var option = `$option_json`;

      // Display the chart using the configuration items and data just specified.
      myChart.setOption(JSON.parse(option));
    </script>
  </body>
</html>
    """
    )
    print(page_tmpl.substitute({"option_json": option_json}))


def main():
    if len(sys.argv) < 2:
        print("Usage: python benchmark_analyzer_seaborn.py 'program_to_run'")
        sys.exit(1)

    program_path = sys.argv[1]
    program_name = basename(program_path)
    print(f"Running benchmark: {program_name}", file=sys.stderr)

    # Run the program and get CSV output
    csv_data = run_benchmark(program_path)

    # Process the CSV data
    result_df, aggregated = process_csv_data(csv_data)

    # create_echarts_config(program_name, result_df)
    # Create the bar chart
    with Blog(f"{program_name}.svg"):
        create_bar_chart(program_name.split("/")[-1], result_df, aggregated)


if __name__ == "__main__":
    main()
