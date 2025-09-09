# Environmental Data Analysis

This notebook analyzes environmental data collected by the agro rover across the field. We'll import necessary libraries and load the cleaned sensor data for comprehensive analysis.


    First 10 rows of the clean environmental data:





<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>timestamp</th>
      <th>camera_id</th>
      <th>image_path</th>
      <th>latitude</th>
      <th>longitude</th>
      <th>temperature_f</th>
      <th>moisture_pct</th>
      <th>ec_us_cm</th>
      <th>ph</th>
      <th>n_mg_kg</th>
      <th>p_mg_kg</th>
      <th>k_mg_kg</th>
      <th>time_str</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1970-01-01 06:31:11.739203</td>
      <td>0</td>
      <td>capture_data/cam0_1970-01-01_06-31-11.jpg</td>
      <td>12.970372</td>
      <td>79.156086</td>
      <td>31.4</td>
      <td>6.7</td>
      <td>337.0</td>
      <td>9.59</td>
      <td>220.0</td>
      <td>300.0</td>
      <td>760.0</td>
      <td>06:31:11</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1970-01-01 06:31:22.772735</td>
      <td>0</td>
      <td>capture_data/cam0_1970-01-01_06-31-22.jpg</td>
      <td>12.970372</td>
      <td>79.156084</td>
      <td>30.1</td>
      <td>6.7</td>
      <td>338.0</td>
      <td>7.67</td>
      <td>220.0</td>
      <td>300.0</td>
      <td>770.0</td>
      <td>06:31:22</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1970-01-01 06:31:44.327990</td>
      <td>0</td>
      <td>capture_data/cam0_1970-01-01_06-31-44.jpg</td>
      <td>12.970372</td>
      <td>79.156084</td>
      <td>28.9</td>
      <td>8.5</td>
      <td>106.0</td>
      <td>10.00</td>
      <td>110.0</td>
      <td>140.0</td>
      <td>370.0</td>
      <td>06:31:44</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1970-01-01 06:31:54.540762</td>
      <td>0</td>
      <td>capture_data/cam0_1970-01-01_06-31-54.jpg</td>
      <td>12.970373</td>
      <td>79.156082</td>
      <td>28.7</td>
      <td>0.0</td>
      <td>354.0</td>
      <td>7.85</td>
      <td>230.0</td>
      <td>310.0</td>
      <td>790.0</td>
      <td>06:31:54</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1970-01-01 06:32:25.187522</td>
      <td>0</td>
      <td>capture_data/cam0_1970-01-01_06-32-25.jpg</td>
      <td>12.970361</td>
      <td>79.156098</td>
      <td>30.0</td>
      <td>0.0</td>
      <td>100.0</td>
      <td>7.41</td>
      <td>100.0</td>
      <td>140.0</td>
      <td>360.0</td>
      <td>06:32:25</td>
    </tr>
    <tr>
      <th>5</th>
      <td>1970-01-01 06:34:25.138680</td>
      <td>0</td>
      <td>capture_data/cam0_1970-01-01_06-34-25.jpg</td>
      <td>12.970415</td>
      <td>79.156106</td>
      <td>32.1</td>
      <td>0.0</td>
      <td>28.0</td>
      <td>10.00</td>
      <td>70.0</td>
      <td>90.0</td>
      <td>240.0</td>
      <td>06:34:25</td>
    </tr>
    <tr>
      <th>6</th>
      <td>1970-01-01 06:36:20.846582</td>
      <td>0</td>
      <td>capture_data/cam0_1970-01-01_06-36-20.jpg</td>
      <td>12.970464</td>
      <td>79.156107</td>
      <td>30.8</td>
      <td>6.1</td>
      <td>154.0</td>
      <td>7.27</td>
      <td>130.0</td>
      <td>180.0</td>
      <td>450.0</td>
      <td>06:36:20</td>
    </tr>
    <tr>
      <th>7</th>
      <td>1970-01-01 06:47:09.572071</td>
      <td>0</td>
      <td>capture_data/cam0_1970-01-01_06-47-09.jpg</td>
      <td>12.970518</td>
      <td>79.156117</td>
      <td>30.9</td>
      <td>0.0</td>
      <td>100.0</td>
      <td>7.88</td>
      <td>100.0</td>
      <td>140.0</td>
      <td>360.0</td>
      <td>06:47:09</td>
    </tr>
    <tr>
      <th>8</th>
      <td>1970-01-01 06:47:31.639204</td>
      <td>0</td>
      <td>capture_data/cam0_1970-01-01_06-47-31.jpg</td>
      <td>12.970518</td>
      <td>79.156117</td>
      <td>31.8</td>
      <td>0.0</td>
      <td>200.0</td>
      <td>9.79</td>
      <td>150.0</td>
      <td>210.0</td>
      <td>530.0</td>
      <td>06:47:31</td>
    </tr>
    <tr>
      <th>9</th>
      <td>1970-01-01 06:47:42.675368</td>
      <td>0</td>
      <td>capture_data/cam0_1970-01-01_06-47-42.jpg</td>
      <td>12.970517</td>
      <td>79.156118</td>
      <td>29.6</td>
      <td>14.1</td>
      <td>272.0</td>
      <td>8.30</td>
      <td>190.0</td>
      <td>260.0</td>
      <td>650.0</td>
      <td>06:47:42</td>
    </tr>
  </tbody>
</table>
</div>



## Time Series Analysis

### Individual Metric Trends Over Time

Create a comprehensive time series plot showing how each environmental metric changes over time. We'll display both raw data points and smoothed trend lines using Savitzky-Golay filtering to better visualize patterns and trends.


    
![png](README_files/README_5_0.png)
    


### Normalized Metrics Comparison

Normalize all environmental metrics to a 0-1 scale and plot them together. This allows us to compare the relative changes of different metrics on the same scale and identify correlations between various environmental parameters.


    
![png](README_files/README_7_0.png)
    


## Spatial Analysis

### Geographic Distribution of Environmental Metrics

Visualize how each environmental metric varies across the field using scatter plots. Each point represents a measurement location with color-coded values showing the spatial distribution and helping identify areas with similar characteristics or potential hotspots.


    
![png](README_files/README_9_0.png)
    


## Statistical Analysis

### Correlation Between Environmental Metrics

Generate a correlation heatmap to understand the statistical relationships between different environmental parameters. This helps identify which factors are interconnected and may influence each other in the agricultural system.


    
![png](README_files/README_11_0.png)
    


### Spatial Interpolation Heatmaps

Create continuous spatial heatmaps using interpolation to show smooth distributions of each environmental metric across the field. This provides a comprehensive view of spatial patterns and gradients that can guide precision agriculture decisions.


    
![png](README_files/README_13_0.png)
    


## Additional Data Exploration

### Coordinate Data Analysis

Load and examine the coordinate data to understand the spatial coverage and sampling pattern of the agro rover's data collection across the field.




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>latitude</th>
      <th>longitude</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>12.970372</td>
      <td>79.156087</td>
    </tr>
    <tr>
      <th>1</th>
      <td>12.970372</td>
      <td>79.156086</td>
    </tr>
    <tr>
      <th>2</th>
      <td>12.970372</td>
      <td>79.156086</td>
    </tr>
    <tr>
      <th>3</th>
      <td>12.970372</td>
      <td>79.156084</td>
    </tr>
    <tr>
      <th>4</th>
      <td>12.970373</td>
      <td>79.156082</td>
    </tr>
    <tr>
      <th>5</th>
      <td>12.970361</td>
      <td>79.156098</td>
    </tr>
    <tr>
      <th>6</th>
      <td>12.970361</td>
      <td>79.156098</td>
    </tr>
    <tr>
      <th>7</th>
      <td>12.970362</td>
      <td>79.156098</td>
    </tr>
    <tr>
      <th>8</th>
      <td>12.970362</td>
      <td>79.156098</td>
    </tr>
    <tr>
      <th>9</th>
      <td>12.970362</td>
      <td>79.156097</td>
    </tr>
  </tbody>
</table>
</div>




    
![png](README_files/README_16_0.png)
    


## Sample Field Images

Display sample images captured by the agro rover during its field survey to provide visual context for the environmental data analysis.


    
![png](README_files/README_18_0.png)
    

