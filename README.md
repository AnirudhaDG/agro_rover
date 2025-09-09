# Environmental Data Analysis

This notebook analyzes environmental data collected by the agro rover across the field. We'll import necessary libraries and load the cleaned sensor data for comprehensive analysis.



```python
# Display first 10 rows of the clean data
print("First 10 rows of the clean environmental data:")
print(df.head(10).to_markdown(index=False))
```

    First 10 rows of the clean environmental data:
    | timestamp                  |   camera_id | image_path                                |   latitude |   longitude |   temperature_f |   moisture_pct |   ec_us_cm |    ph |   n_mg_kg |   p_mg_kg |   k_mg_kg |
    |:---------------------------|------------:|:------------------------------------------|-----------:|------------:|----------------:|---------------:|-----------:|------:|----------:|----------:|----------:|
    | 1970-01-01T06:31:11.739203 |           0 | capture_data/cam0_1970-01-01_06-31-11.jpg |    12.9704 |     79.1561 |            31.4 |            6.7 |        337 |  9.59 |       220 |       300 |       760 |
    | 1970-01-01T06:31:22.772735 |           0 | capture_data/cam0_1970-01-01_06-31-22.jpg |    12.9704 |     79.1561 |            30.1 |            6.7 |        338 |  7.67 |       220 |       300 |       770 |
    | 1970-01-01T06:31:44.327990 |           0 | capture_data/cam0_1970-01-01_06-31-44.jpg |    12.9704 |     79.1561 |            28.9 |            8.5 |        106 | 10    |       110 |       140 |       370 |
    | 1970-01-01T06:31:54.540762 |           0 | capture_data/cam0_1970-01-01_06-31-54.jpg |    12.9704 |     79.1561 |            28.7 |            0   |        354 |  7.85 |       230 |       310 |       790 |
    | 1970-01-01T06:32:25.187522 |           0 | capture_data/cam0_1970-01-01_06-32-25.jpg |    12.9704 |     79.1561 |            30   |            0   |        100 |  7.41 |       100 |       140 |       360 |
    | 1970-01-01T06:34:25.138680 |           0 | capture_data/cam0_1970-01-01_06-34-25.jpg |    12.9704 |     79.1561 |            32.1 |            0   |         28 | 10    |        70 |        90 |       240 |
    | 1970-01-01T06:36:20.846582 |           0 | capture_data/cam0_1970-01-01_06-36-20.jpg |    12.9705 |     79.1561 |            30.8 |            6.1 |        154 |  7.27 |       130 |       180 |       450 |
    | 1970-01-01T06:47:09.572071 |           0 | capture_data/cam0_1970-01-01_06-47-09.jpg |    12.9705 |     79.1561 |            30.9 |            0   |        100 |  7.88 |       100 |       140 |       360 |
    | 1970-01-01T06:47:31.639204 |           0 | capture_data/cam0_1970-01-01_06-47-31.jpg |    12.9705 |     79.1561 |            31.8 |            0   |        200 |  9.79 |       150 |       210 |       530 |
    | 1970-01-01T06:47:42.675368 |           0 | capture_data/cam0_1970-01-01_06-47-42.jpg |    12.9705 |     79.1561 |            29.6 |           14.1 |        272 |  8.3  |       190 |       260 |       650 |


## Time Series Analysis

### Individual Metric Trends Over Time

Create a comprehensive time series plot showing how each environmental metric changes over time. We'll display both raw data points and smoothed trend lines using Savitzky-Golay filtering to better visualize patterns and trends.

### Normalized Metrics Comparison

Normalize all environmental metrics to a 0-1 scale and plot them together. This allows us to compare the relative changes of different metrics on the same scale and identify correlations between various environmental parameters.


```python
# Convert timestamp to readable format
df["time_str"] = pd.to_datetime(df["timestamp"]).dt.strftime("%H:%M:%S")


# Normalize metrics (0–1 scaling)
scaler = MinMaxScaler()
df_norm = df.copy()
df_norm[metrics] = scaler.fit_transform(df[metrics].astype(float))

# Plot smoothed normalized values on same graph
fig, ax = plt.subplots(figsize=(14, 6))

x = np.arange(len(df))

for col in metrics:
    y = df_norm[col].values
    
    # Smooth with Savitzky-Golay or rolling mean
    window = min(11, len(y) if len(y) % 2 == 1 else len(y)-1)
    if window >= 5:
        y_smooth = savgol_filter(y, window, polyorder=2)
    else:
        y_smooth = pd.Series(y).rolling(window=3, min_periods=1).mean().to_numpy()
    
    ax.plot(x, y_smooth, linewidth=2, label=col)

# X-axis labels (time)
step = max(1, len(x)//10)
ax.set_xticks(x[::step])
ax.set_xticklabels(df["time_str"].iloc[::step], rotation=45, ha="right", fontsize=8)

ax.set_xlabel("Time (HH:MM:SS)", fontsize=12)
ax.set_ylabel("Normalized Value (0–1)", fontsize=12)
ax.set_title("Normalized Environmental Metrics Over Time", fontsize=16)
ax.legend(fontsize=9)
ax.grid(True, linestyle="--", alpha=0.6)

plt.tight_layout()
plt.savefig("./plots/normalized_metrics_over_time.png", dpi=300, bbox_inches="tight")
plt.show()
```


    
![png](README_files/README_4_0.png)
    


## Spatial Analysis

### Geographic Distribution of Environmental Metrics

Visualize how each environmental metric varies across the field using scatter plots. Each point represents a measurement location with color-coded values showing the spatial distribution and helping identify areas with similar characteristics or potential hotspots.


```python
n_metrics = len(metrics)
n_cols = 3  # up to 3 plots per row
n_rows = math.ceil(n_metrics / n_cols)

fig, axes = plt.subplots(n_rows, n_cols, figsize=(6*n_cols, 5*n_rows))
axes = axes.flatten()

for i, col in enumerate(metrics):
    sc = axes[i].scatter(
        df["longitude"].to_numpy().ravel(),
        df["latitude"].to_numpy().ravel(),
        c=df[col].to_numpy().ravel(),
        cmap="viridis", s=60, edgecolor="k"
    )
    axes[i].set_title(f"{col} (spatial distribution)", fontsize=12)
    axes[i].set_xlabel("Longitude")
    axes[i].set_ylabel("Latitude")

    # Force plain formatting (no scientific notation)
    axes[i].xaxis.set_major_formatter(mticker.ScalarFormatter(useOffset=False))
    axes[i].yaxis.set_major_formatter(mticker.ScalarFormatter(useOffset=False))

    # Rotate ticks for clarity
    for label in axes[i].get_xticklabels():
        label.set_rotation(30)
        label.set_fontsize(8)
    for label in axes[i].get_yticklabels():
        label.set_fontsize(8)

    cbar = plt.colorbar(sc, ax=axes[i], shrink=0.85)
    cbar.ax.tick_params(labelsize=8)

# Hide unused axes
for j in range(n_metrics, len(axes)):
    fig.delaxes(axes[j])

plt.tight_layout()
plt.subplots_adjust(top=0.92, hspace=0.4, wspace=0.35)
plt.savefig("./plots/spatial_scatter_plots.png", dpi=300, bbox_inches="tight")
plt.show()
```


    
![png](README_files/README_6_0.png)
    


## Statistical Analysis

### Correlation Between Environmental Metrics

Generate a correlation heatmap to understand the statistical relationships between different environmental parameters. This helps identify which factors are interconnected and may influence each other in the agricultural system.


```python
plt.figure(figsize=(10, 6))
corr = df[metrics].corr()
sns.heatmap(corr, annot=True, cmap="coolwarm", fmt=".2f")
plt.title("Correlation Heatmap of Metrics", fontsize=14)
plt.tight_layout()
plt.savefig("./plots/correlation_heatmap.png", dpi=300, bbox_inches="tight")
plt.show()
```


    
![png](README_files/README_8_0.png)
    


### Spatial Interpolation Heatmaps

Create continuous spatial heatmaps using interpolation to show smooth distributions of each environmental metric across the field. This provides a comprehensive view of spatial patterns and gradients that can guide precision agriculture decisions.


```python
df_clean = df.dropna(subset=["latitude", "longitude"] + metrics)

lat = df_clean["latitude"].values
lon = df_clean["longitude"].values

# Define voxel grid resolution (increase 200j for smoother maps)
grid_x, grid_y = np.mgrid[
    lon.min():lon.max():200j,
    lat.min():lat.max():200j
]

# Subplots
n = len(metrics)
cols = 3
rows = int(np.ceil(n / cols))

fig, axes = plt.subplots(rows, cols, figsize=(18, 12))
axes = axes.flatten()

for i, metric in enumerate(metrics):
    values = df_clean[metric].values

    try:
        grid_z = griddata((lon, lat), values, (grid_x, grid_y), method="cubic")
    except Exception:
        grid_z = griddata((lon, lat), values, (grid_x, grid_y), method="linear")

    # Plot heatmap
    im = axes[i].imshow(
        grid_z.T, extent=(lon.min(), lon.max(), lat.min(), lat.max()),
        origin="lower", cmap="viridis", aspect="auto"
    )
    fig.colorbar(im, ax=axes[i], label=metric, shrink=0.8)
    axes[i].scatter(lon, lat, c="k", s=10, alpha=0.6)
    axes[i].set_title(metric)
    axes[i].set_xlabel("Longitude")
    axes[i].set_ylabel("Latitude")

# Hide unused axes
for j in range(i + 1, len(axes)):
    axes[j].axis("off")

plt.tight_layout()
plt.savefig("./plots/spatial_heatmaps.png", dpi=300, bbox_inches="tight")
plt.show()
```


    
![png](README_files/README_10_0.png)
    


## Additional Data Exploration

### Coordinate Data Analysis

Load and examine the coordinate data to understand the spatial coverage and sampling pattern of the agro rover's data collection across the field.


```python
coor_data = pd.read_csv("./coordinate_data.csv")
print(coor_data.head(10).to_markdown(index=False))
```

    |   latitude |   longitude |
    |-----------:|------------:|
    |    12.9704 |     79.1561 |
    |    12.9704 |     79.1561 |
    |    12.9704 |     79.1561 |
    |    12.9704 |     79.1561 |
    |    12.9704 |     79.1561 |
    |    12.9704 |     79.1561 |
    |    12.9704 |     79.1561 |
    |    12.9704 |     79.1561 |
    |    12.9704 |     79.1561 |
    |    12.9704 |     79.1561 |



```python
# Display the map plot
from IPython.display import Image, display
display(Image("./support_images/map_plot.png"))
```


    
![png](README_files/README_13_0.png)
    


## Sample Field Images

Display sample images captured by the agro rover during its field survey to provide visual context for the environmental data analysis.


```python
import matplotlib.pyplot as plt
import matplotlib.image as mpimg

# Create figure with 3 subplots side by side
fig, axes = plt.subplots(1, 3, figsize=(15, 5))

# Load and display the three pictures
image_paths = [
    "./capture_data/picture1.jpg",
    "./capture_data/picture2.jpg", 
    "./capture_data/picture3.jpg"
]

titles = ["Picture 1", "Picture 2", "Picture 3"]

for i, (path, title) in enumerate(zip(image_paths, titles)):
    try:
        img = mpimg.imread(path)
        axes[i].imshow(img)
        axes[i].set_title(title, fontsize=12)
        axes[i].axis('off')  # Hide axes for cleaner look
    except FileNotFoundError:
        axes[i].text(0.5, 0.5, f'Image not found:\n{path}', 
                     ha='center', va='center', transform=axes[i].transAxes)
        axes[i].set_title(title, fontsize=12)
        axes[i].axis('off')

plt.tight_layout()
plt.suptitle("Field Images Captured During Data Collection", fontsize=16, y=1.02)
plt.show()
```


    
![png](README_files/README_15_0.png)
    

